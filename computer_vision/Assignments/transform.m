function [image1_transformed,image2_transformed,x] = transform(image1,image2)
    %[image1,image2]     = padding_own(image1,image2);
    [points1,points2]   = sift_own(image1,image2);
    x                   = alignment_iterations(points1,points2);
    T = [x(1) x(2) x(5); x(3) x(4) x(6); 0 0 1];
    tform = maketform('affine', T');
    image1_transformed = imtransform(image1,tform, 'bicubic');
    tform = maketform('affine', inv(T)' );
    image2_transformed = imtransform(image2,tform, 'bicubic');
    figure;
    subplot(2,2,1), imshow(image1);title('Image 1');
    subplot(2,2,2), imshow(image2);title('Image 2')
    subplot(2,2,3), imshow(image2_transformed);title('Image 2 transformed to image 1')
    subplot(2,2,4), imshow(image1_transformed);title('Image 1 transformed to image 2')
    %show_transform(image1,image2,points1,points1_transformed);
end

function x = alignment_iterations(points1,points2)
    N               = 100;
    inliers         = [];
    transformations = [];
    for i = 1:N
        [inlier_count,x]    = alignment(points1,points2);
        inliers             = [inliers inlier_count];
        transformations     = [transformations x];
    end
    best_index      = find(inliers == max(inliers));
    best_x          = transformations(best_index);
end

function [inliers,x] = alignment(points1,points2)
    P = 6;
    perm = randperm(size(points1,2));
    seed = perm(1:P);
    A = [];
    B = [];
    for i = 1:P
        a = points1(:,seed(i))';
        b = points2(:,seed(i))';
        A = cat(1,A,[a(1) a(2) 0 0 1 0;0 0 a(1) a(2) 0 1]);
        B = cat(1,B,[b(1);b(2)]);
    end
    A_new = [];
    x = pinv(A)* B;
    for i = 1:size(points1,2);
        a = points1(:,i)';
        A_new = cat(1,A_new,[a(1) a(2) 0 0 1 0;0 0 a(1) a(2) 0 1]);
    end
    B_new                   =   A_new*x;
    points1_transformed     =   reshape(B_new,size(points2));
    inlier_threshold        = 10;
    inliers                 = find(sqrt(sum((points1_transformed-points2).^2)) < inlier_threshold);
    inliers                 = size(inliers,2);
end


function [] = show_transform(image1,image2,points1,points1_transformed);
    points1_plot        = points1;
    points2_plot        = [points1_transformed(1,:)+size(image2,2);points1_transformed(2,:)];
    figure();
    clf ;
    imshow(cat(2, image1, image2));
    hold on;
    h = line([points1_plot(1,:) ; points2_plot(1,:)], [points1_plot(2,:); points2_plot(2,:)]) ;
    set(h,'linewidth', 0.2);
    axis image off;
end