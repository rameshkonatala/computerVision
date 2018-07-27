I_sample        = imread('landscape-a.jpg');
I               = rgb2gray(I_sample);
im              = im2double(I);
sigmaRange      = [0.5 1 2];
count           = 0;
for sigma = sigmaRange
    F = laplacian(im,sigma);
    [r,c] = harris(F,sigma);
    points = [r,c];
    if count>1
        points = intersect(points_prev,points,'rows');
    end
    count=count+1;
    points_prev = points;
end

r = points(:,1);
c = points(:,2);

figure(3);
imshow(I_sample);
hold on;
plot(r,c,'*')

function F = laplacian(im,sigma)
    gaussian_double_der_x = gaussianDoubleDer(sigma);
    F_x = convn(im,gaussian_double_der_x,'same');
    gaussian_double_der_y = gaussianDoubleDer(sigma)';
    F_y = convn(im,gaussian_double_der_y,'same');
    F = sigma*sigma*(F_x+F_y);
end

function Gdd = gaussianDoubleDer(sigma)
    kernelSize = 51;
    kernel = (linspace(-kernelSize/2,kernelSize/2,kernelSize));
    Gdd = ((exp(-kernel.^2/(2*sigma^2)) / ((sigma^5)*sqrt(2*pi)))).*(kernel.^2-sigma^2);
end