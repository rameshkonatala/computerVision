function a_gaussian_grey(I,sigma)
    I = im2double(I);
    sigma_x = sigma;
    sigma_y = sigma;
    gaussianImage = gaussianConv(I,sigma_x,sigma_y);
    gaussianImage_default = imgaussfilt(I, sigma);
    subplot(1,2,1)
    imshow(gaussianImage);
    title('Gaussian image with two 1D operations');
    subplot(1,2,2)
    imshow(gaussianImage_default)
    title('Gaussian image with default matlab 2D function')
    figure();
    [magnitude,orientation] = gradmag(I,sigma_x,sigma_y);
    subplot(1,2,1)
    imshow(magnitude);
    title('magnitude of the gradient');
    subplot(1,2,2)
    imshow(orientation,[-pi,pi]);
    title('orientation of the gradient');
    colormap(hsv);
    colorbar;
    figure
    [u,v] = quiver_values(I,sigma_x,sigma_y);
    [m,n] = size(u);
    [x,y] = meshgrid(0:1:n-1,m-1:-1:0);
    quiver(x,y,u,v);
    magnitude_vs_sigma(I);
    threshold_vs_sigma(I);
    impulse_image();
    end

function impulse_image()
    impulse_matrix=zeros(7);
    index_impulse_matrix = ceil(size(impulse_matrix)./2);
    impulse_matrix(index_impulse_matrix(1),index_impulse_matrix(2))=1;
    figure()
    imshow(impulse_matrix);
    for sigma = [0.5 1 2 3 4 5] 
        figure()
        derivative_label = ['0^{th} derivative in x';'0^{th} derivative in y';'1^{st} derivative in x';'1^{st} derivative in y';'2^{nd} derivative in x';'2^{nd} derivative in y';'xy derivative         ';'yx derivative         ';];
        for i = [1 2 3 4 5 6 7 8]
            subplot(4,2,i)
            image = ImageDerivatives(impulse_matrix,sigma,i);
            imshow(image);
            title(sprintf('impulse image with %s(sigma = %f)', derivative_label(i,:),sigma))
        end
    end
end


function F=ImageDerivatives(img,sigma,type)
    
    switch type
        case 1
            gaussian_x = gaussian(sigma);
            F = convn(img,gaussian_x,'same');
        case 2
            gaussian_y = gaussian(sigma)';
            F = convn(img,gaussian_y,'same');            
        case 3
            gaussian_der_x = gaussianDer(sigma);
            F = convn(img,gaussian_der_x,'same');
        case 4
            gaussian_der_y = gaussianDer(sigma)';
            F = convn(img,gaussian_der_y,'same');
        case 5
            gaussian_double_der_x = gaussianDoubleDer(sigma);
            F = convn(img,gaussian_double_der_x,'same');
        case 6
            gaussian_double_der_y = gaussianDoubleDer(sigma)';
            F = convn(img,gaussian_double_der_y,'same');            
        case 7
            gaussian_der_x = gaussianDer(sigma);
            img_x = convn(img,gaussian_der_x,'same');            
            gaussian_der_y = gaussianDer(sigma)';
            F = convn(img_x,gaussian_der_y,'same');
        case 8
            gaussian_der_y = gaussianDer(sigma)';
            img_y = convn(img,gaussian_der_y,'same');            
            gaussian_der_x = gaussianDer(sigma);
            F = convn(img_y,gaussian_der_x,'same');            
    end
end

function threshold_vs_sigma(image_path)
    
    for i = [30,50,70]
        figure()    
        sigma = 0;
        while sigma<11
            subplot(4,3,sigma+1)
            [magnitude,orientation] = gradmag(image_path,sigma,sigma);
            magnitude = mean(magnitude,3);
            range=max(max(magnitude))-min(min(magnitude));
            threshold_value = (range*i)/100;
            magnitude = magnitude>threshold_value;
            imshow(magnitude);
            title(sprintf('magnitude vs sigma = %d(threshold=%d%%)', sigma,i))
            sigma=sigma+1;
        end
    end
end

function magnitude_vs_sigma(image_path)
    figure()
    sigma = 0;
    while sigma<11
        subplot(4,3,sigma+1)
        [magnitude,orientation] = gradmag(image_path,sigma,sigma);
        magnitude = mean(magnitude,3);
        imshow(magnitude);
        title(sprintf('magnitude vs sigma = %d', sigma))
        sigma=sigma+1;
    end
    
    figure()
    sigma=0;
    while sigma < 11
        subplot(4,3,sigma+1)
        [magnitude,orientation] = gradmag(image_path,sigma,sigma);
        orientation= mean(orientation,3);
        imshow(orientation);
        title(sprintf('orientation vs sigma = %d', sigma))
        sigma=sigma+1;
    end
end

function [u,v] = quiver_values(image_path,sigma_x,sigma_y)
    gaussian_der_x = gaussianDer(sigma_x);
    u = convn(image_path,gaussian_der_x,'same');
    u = mean(u,3);
    gaussian_der_y = gaussianDer(sigma_y)';
    v = convn(image_path,gaussian_der_y,'same');
    v = mean(v,3);
end


function [magnitude,orientation] = gradmag(image_path,sigma_x,sigma_y)
    gaussian_x = gaussianDer(sigma_x);
    gaussian_y = gaussianDer(sigma_y)';
    gy = convn(image_path,gaussian_y,'same');
    gx = convn(image_path,gaussian_x,'same');
    magnitude = sqrt(gy.^2+gx.^2);
    magnitude = mean(magnitude,3);
    orientation = atan(gy./gx);
    orientation = mean(orientation,3);
end


function imOut = gaussianConv(image_path,sigma_x,sigma_y)
    gaussian_x = gaussian(sigma_x);
    gaussian_y = gaussian(sigma_y)';
    x = gaussian_x;
    y = gaussian_y;
    temp = convn(image_path,gaussian_y,'same');
    imOut = convn(temp,gaussian_x,'same');
end

function G = gaussian(sigma)
    kernelSize = 51;
    kernel = (linspace(-kernelSize/2,kernelSize/2,kernelSize));
    G = exp(-kernel.^2/(2*sigma^2)) / (sigma*sqrt(2*pi));
end

function Gd = gaussianDer(sigma)
    kernelSize = 51;
    kernel = (linspace(-kernelSize/2,kernelSize/2,kernelSize));
    temp = (exp(-kernel.^2/(2*sigma^2)) / ((sigma^3)*sqrt(2*pi)));
    Gd = -kernel.*temp;
end

function Gdd = gaussianDoubleDer(sigma)
    kernelSize = 51;
    kernel = (linspace(-kernelSize/2,kernelSize/2,kernelSize));
    Gdd = ((exp(-kernel.^2/(2*sigma^2)) / ((sigma^5)*sqrt(2*pi)))).*(kernel.^2-sigma^2);
end
