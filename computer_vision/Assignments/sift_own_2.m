image1 = imread('landscape-a.jpg');
image2 = imread('landscape-b.jpg');
[points1,points2] = sift_own(image1,image2);