I = imread('sample.jpg');
I=rgb2gray(I);
I = im2double(I);
gaussianImage = gaussianConv(I,5,5);
gaussianImage_default = imgaussfilt(I, 5);
subplot(1,2,1)
imshow(gaussianImage);
title('Gaussian image with two 1D operations');
subplot(1,2,2)
imshow(gaussianImage_default)
title('Gaussian image with default matlab 2D function')
figure();
[magnitude,orientation] = gradmag(I,2,2);
subplot(1,2,1)
imshow(magnitude);
title('magnitude of the gradient');
subplot(1,2,2)
imshow(orientation,[-pi,pi]);
title('orientation of the gradient');
colormap(hsv);
colorbar;




function [magnitude,orientation] = gradmag(image_path,sigma_x,sigma_y)
    gaussian_x = gaussianDer(sigma_x)';
    gaussian_y = gaussianDer(sigma_y);
    gy = convn(image_path,gaussian_y,'same');
    gx = convn(image_path,gaussian_x,'same');
    magnitude = sqrt(gy.^2+gx.^2);
    orientation = atan(gy./gx);
end


function imOut = gaussianConv(image_path,sigma_x,sigma_y)
    gaussian_x = gaussian(sigma_x)';
    gaussian_y = gaussian(sigma_y);
    temp = convn(image_path,gaussian_y,'same');
    imOut = convn(temp,gaussian_x,'same');
end

function G = gaussian(sigma)
    kernelSize = 51;
    kernel = (linspace(-kernelSize/2,kernelSize/2,kernelSize))';
    G = exp(-kernel.^2/(2*sigma^2)) / (sigma*sqrt(2*pi));
end

function Gd = gaussianDer(sigma)
    kernelSize = 51;
    kernel = (linspace(-kernelSize/2,kernelSize/2,kernelSize))';
    temp = (exp(-kernel.^2/(2*sigma^2)) / (sigma*sqrt(2*pi)));
    Gd = kernel.*temp;
end
