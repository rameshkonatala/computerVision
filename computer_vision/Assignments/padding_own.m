function [image1,image2] = padding_own(image1,image2)
    height1     = size(image1,1); 
    width1      = size(image1,2); 
    height2     = size(image2,1); 
    width2      = size(image2,2);
    if height1>=height2
        image2 = padarray(image2,[height1-height2 0],'post');
    else
        image1 = padarray(image1,[height2-height1 0],'post');
    end
    if width1>=width2
        image2 = padarray(image2,[0 width1-width2],'post');
    else
        image1 = padarray(image1,[0 width2-width1],'post');
    end
end