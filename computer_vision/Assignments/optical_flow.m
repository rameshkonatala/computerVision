function [x,y,u,v] = optical_flow(im1,im2)
    image = im1;
    im1 = int8(im1);
    im2 = int8(im2);
    [dIdX,dIdY] = getdIdXAnddIdY(im1,1,1);
    [dIdT] = getdIdT(im1,im2);
    regionsdIdX = getRegions(dIdX);
    regionsdIdY = getRegions(dIdY);
    regionsdIdT = getRegions(dIdT);
    flowVectors = -getFlowVectors(regionsdIdX,regionsdIdY,regionsdIdT);
    maxX = size(im1,1);
    maxY = size(im2,2);
    %[x,y] = meshgrid(maxX-1:-15:7.5,maxY-1:-15:7.5);
    [x,y] = meshgrid(7.5:15:maxX-1,7.5:15:maxY-1);
    u = reshape(flowVectors(1,:),[size(x,1),size(x,2)]);
    v = reshape(flowVectors(2,:),[size(x,1),size(x,2)]);
    imshow(image);
    hold on
    quiver(y,x,v,u);

    %quiver(u,v);
end

% function [dIdX,dIdY] = getdIdXAnddIdY(image)
%     i =1;
%     j=1;
%     maxX = size(image,1);
%     maxY = size(image,2);
%     dIdX = zeros(size(image,2),size(image,1));
%     dIdY = zeros(size(image,2 ),size(image,1));
%     
%     while i<maxX
%         while j<maxY
%             dIdX(i,j) = image(i,j) - image(i+1,j);
%             dIdY(i,j) = image(i,j) - image(i,j+1);
%             j = j+1;
%         end
%         j=1;
%         i = i+1;
%     end
%     
% end

function [dIdT] = getdIdT(image1,image2)
    i =1;
    j=1;
    maxX = size(image1,1);
    maxY = size(image1,2);
    image1 = gaussianConv(image1,1,1);
    image2 = gaussianConv(image2,1,1);
    dIdT = zeros(size(image1,1),size(image1,2));
    while i<maxX
        while j<maxY
            dIdT(i,j) = image1(i,j) - image2(i,j);
            j = j+1;
        end
        j=1;
        i = i+1;
    end
    
end


function regions = getRegions(image)
    regions=[];
    i=1;
    while i+14 <= size(image,1)
       j=1;
        while j+14 <= size(image,2)
            temp    = image(i:i+14,j:j+14);
            temp    = temp(:);
            regions  = [regions;temp'];
            j       = j+15;
       end
       i=i+15;
    end
end


function flowVectors = getFlowVectors(regionsdIdX,regionsdIdY,regionsdIdT)
    max = size(regionsdIdT,1);
    flowVectors = zeros(2,max);
    i=1;
    
    while i<=max
        A = [regionsdIdX(i,:)' regionsdIdY(i,:)'];
        b = -regionsdIdT(i,:)';
        flowVectors(:,i) = pinv(A.'*A)*A.'*b;
        i = i+1;
    end

end

function [dIdX,dIdY] = getdIdXAnddIdY(image,sigma_x,sigma_y)
    gaussian_x = gaussianDer(sigma_x);
    gaussian_y = gaussianDer(sigma_y)';
    dIdX = convn(image,gaussian_y,'same');
    dIdY = convn(image,gaussian_x,'same');
end

function Gd = gaussianDer(sigma)
    kernelSize = 51;
    kernel = (linspace(-kernelSize/2,kernelSize/2,kernelSize));
    temp = (exp(-kernel.^2/(2*sigma^2)) / ((sigma^3)*sqrt(2*pi)));
    Gd = -kernel.*temp;
end

function G = gaussian(sigma)
    kernelSize = 51;
    kernel = (linspace(-kernelSize/2,kernelSize/2,kernelSize));
    G = exp(-kernel.^2/(2*sigma^2)) / (sigma*sqrt(2*pi));
end


function imOut = gaussianConv(image_path,sigma_x,sigma_y)
    gaussian_x = gaussian(sigma_x);
    gaussian_y = gaussian(sigma_y)';
    x = gaussian_x;
    y = gaussian_y;
    temp = convn(image_path,gaussian_y,'same');
    imOut = convn(temp,gaussian_x,'same');
end