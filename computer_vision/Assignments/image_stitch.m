function stitched_image = image_stitch(image1,image2)
    [image1_transformed,image2_transformed,x] = transform(image1,image2);
    T = [x(1) x(2) x(5); x(3) x(4) x(6); 0 0 1];
    corners_image1 = [1 1;size(image1,2) 1;size(image1,2) size(image1,1);1 size(image1,1)];
    corners_image2 = [1 1;size(image2,2) 1;size(image2,2) size(image2,1);1 size(image2,1)];
    vectors = [1;1;1;1];
    corners_image2 = [corners_image2 vectors];
    transformed_corners_image2 = (inv(T)*corners_image2')';
    minCorners = min(transformed_corners_image2);
    maxCorners = max(transformed_corners_image2);
    image2_transformed_padded = padarray(image2_transformed,floor(minCorners(2)-corners_image1(1,1)),0,'pre');
    image2_transformed_padded = padarray(image2_transformed_padded,ceil(corners_image1(4,2)-maxCorners(2)),0,'post');
    image2_slice = image2_transformed_padded(:,floor(corners_image1(2,1)-minCorners(1)):end);
    %[image1_padding,image2_transformed_padding] = padding_own(image1,image2_transformed);
    final = zeros(max(size(image1,1),size(image2_slice,1)),size(image1,2)+size(image2_slice,2));
    final = [image1,image2_slice];
    figure(2);
    imshow(final);
end