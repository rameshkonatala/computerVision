img = imread('landscape-a.jpg');
img2 = imread('landscape-b.jpg');
greyimg = rgb2gray(img);
greyimg2 = rgb2gray(img2);
kappa = im2single(greyimg);
kappa2 = im2single(greyimg2);

[F,D] = vl_sift(kappa);
[C,V] = vl_sift(kappa2);
[matches, scores] = vl_ubcmatch(D, V);

firstImageVector = zeros(2,116);
secondImageVector = zeros(2,116);
for i = 1:10
    indexa = matches(1,i)
    indexb = matches(2,i)
    x1 = F(1,indexa) 
    y1 = F(2,indexa)
    x2 = C(1,indexb)
    y2 = C(2,indexb)
    firstImageVector(1,i) = x1;
    firstImageVector(2,i) = y1;
    secondImageVector(1,i) = x2;
    secondImageVector(2,i) = y2;
end

imshow(img)
hold on;
scatter(firstImageVector(1,:),firstImageVector(2,:))
figure;
imshow(img2)
hold on;
scatter(secondImageVector(1,:),secondImageVector(2,:))

hold on;
figure(2) ; clf ;
imagesc(cat(2, img, img2)) ;

xa = F(1,matches(1,:)) ;
xb = C(1,matches(2,:)) + size(kappa,2) ;
ya = F(2,matches(1,:)) ;
yb = C(2,matches(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 0.2, 'color', 'b');

vl_plotframe(F(:,matches(1,:))) ;
fb(1,:) = C(1,:) + size(kappa,2) ;
vl_plotframe(C(:,matches(2,:))) ;
axis image off;


