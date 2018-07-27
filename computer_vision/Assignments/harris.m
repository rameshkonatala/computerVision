function [r, c] = harris(im, sigma)
% inputs: 
% im: double grayscale image
% sigma: integration-scale
% outputs:  The row and column of each point is returned in r and c
% This function finds Harris corners at integration-scale sigma.
% The derivative-scale is chosen automatically as gamma*sigma

gamma = 0.7; % The derivative-scale is gamma times the integration scale

% Calculate Gaussian Derivatives at derivative-scale
% Hint: use your previously implemented function in assignment 1 
g_der_x =  gaussianDer(sigma*gamma);
g_der_y =  gaussianDer(sigma*gamma)';
Ix = conv2(im,g_der_x,'same');
Iy = conv2(im,g_der_y,'same');
% Allocate an 3-channel image to hold the 3 parameters for each pixel
M = zeros(size(Ix,1), size(Ix,2), 3);



% Calculate M for each pixel
M(:,:,1) = Ix.^2;
M(:,:,2) = Iy.^2;
M(:,:,3) = Ix.*Iy;

% Smooth M with a gaussian at the integration scale sigma.
M = imfilter(M, fspecial('gaussian', ceil(sigma*6+1), sigma), 'replicate', 'same');

% Compute the cornerness R
trace = M(:,:,1)+M(:,:,2);
det = (M(:,:,1).^M(:,:,2))-(M(:,:,3).^2);
R = det-((0.06)*(trace).^2);
% Set the threshold 
threshold =  0.9;

% Find local maxima
% Dilation will alter every pixel except local maxima in a 3x3 square area.
% Also checks if R is above threshold
R = ((R>threshold) & ((imdilate(R, strel('square', 3))==R))) ; %.* sigma;

% Display corners
figure(1)
imshow(R,[]);

% Return the coordinates
[c,r] = find(R==1);

end

function Gd = gaussianDer(sigma)
    kernelSize = 3;
    kernel = (linspace(-kernelSize/2,kernelSize/2,kernelSize));
    temp = (exp(-kernel.^2/(2*sigma^2)) / ((sigma^3)*sqrt(2*pi)));
    Gd = -kernel.*temp;
end

