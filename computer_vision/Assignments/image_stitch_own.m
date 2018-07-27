im1 = rgb2gray(imread('left.jpg'));
im2 = rgb2gray(imread('right.jpg'));
stitched_image = image_stitch(im1,im2); 