function [image] = readImages(index)
    files = dir('modelCastle_features/*.png');
    %imageSize = size(imread((strcat('model_castle/',files(1).name))));
    %images = zeros(size(files,1),imageSize(1),imageSize(2),imageSize(3));
    image = (imread((strcat('modelCastle_features/',files(index).name))));
    
end
