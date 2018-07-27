I_sample = imread('sample3.jpg');
I_old = single(rgb2gray(I_sample));
I_new = single(rgb2gray(imread('sample4.jpg')));

[F,D] = vl_sift(I_old) ;
[C,V] = vl_sift(I_new) ;
[matches, scores] = vl_ubcmatch(D, V) ;
imshow(I_old);
hold on;
plot(F(1,matches(1,:)),F(2,matches(1,:)), 'r*', 'LineWidth', 2, 'MarkerSize', 2);
% images={'sample3.jpg','sample4.jpg'}';
% montage(images, 'Size', [1 2]);