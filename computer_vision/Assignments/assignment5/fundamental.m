im1 = imread('TeddyBearPNG/obj02_001.png');
im2 = imread('TeddyBearPNG/obj02_002.png');

I_old = single(rgb2gray(im1));
I_new = single(rgb2gray(im2));
center = [size(im1,1)/2,size(im1,2)/2];
[F,D] = vl_sift(I_old) ;
[C,V] = vl_sift(I_new) ;
[matches, scores] = vl_ubcmatch(D, V);
points1             = F(1:2,matches(1,:));
points2             = C(1:2,matches(2,:));
[row1,col1] = find(points1>)



% points1_plot        = points1;
% points2_plot        = [points2(1,:)+size(I_new,2);points2(2,:)];
% graphics = 1;
% if graphics
%     figure();
%     clf ;
%     imagesc(cat(2, (im1), (im2)));
%     hold on;
%     h = line([points1_plot(1,:) ; points2_plot(1,:)], [points1_plot(2,:); points2_plot(2,:)]) ;
%     set(h,'linewidth', 0.2, 'color', 'b');
%     axis image off;
% end