function [points1,points2] = sift_own(image1,image2)
    im1 = single(rgb2gray(image1));
    im2 = single(rgb2gray(image2));
    threshold = 5;
    [F,D]               = vl_sift(im1);
    [C,V]               = vl_sift(im2);
    [matches, scores]   = vl_ubcmatch(D, V,threshold) ;
    points1             = F(1:2,matches(1,:));
    points2             = C(1:2,matches(2,:));
    points1_plot        = points1;
    points2_plot        = [points2(1,:)+size(im2,2);points2(2,:)];
    graphics = 1;
    if graphics
        figure();
        clf ;
        imagesc(cat(2, (image1), (image2)));
        hold on;
        h = line([points1_plot(1,:) ; points2_plot(1,:)], [points1_plot(2,:); points2_plot(2,:)]) ;
        set(h,'linewidth', 0.2, 'color', 'b');
        axis image off;
    end
end