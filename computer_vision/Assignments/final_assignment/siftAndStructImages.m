function str = siftAndStructImages()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    i = 1;
    files = dir('modelCastle_features/*.haraff.sift');
    
    
while i<=19
    file = strcat('modelCastle_features/',files(i).name);
    [feat nb dim]=loadFeatures(file);
    Fi = feat(1:4,:);
    Di = feat(6:133,:);
    goodPoints = removeBadPoints(Fi(1:2,:));
    [~,ia,ib] = intersect(Fi(1:2,:)',goodPoints','rows');
    Fi = Fi(:,ia);
    Di = Di(:,ia);
    str(i).F = Fi;
    str(i).D = Di;
    %
    i = i+1
end

%store in file
save('baseStruct.mat', 'str')
end


function [feat nb dim]=loadFeatures(file)
fid = fopen(file, 'r');
dim=fscanf(fid, '%f',1);
if dim==1
dim=0;
end
nb=fscanf(fid, '%d',1);
feat = fscanf(fid, '%f', [5+dim, inf]);
fclose(fid);
end

function outPoints = removeBadPoints(inPoints)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
minX = 995;
minY = 642;
maxX = 3066;
maxY = 2123;

i = 1;
s = size(inPoints);
width = s(2);
outpointCounter = 1;
outPoints(1,1) = -1;
outPoints(2,1) = -1;
while i<=width
    inPointX = inPoints(1,i);
    inPointY = inPoints(2,i);
    if(inPointX>minX && inPointX<maxX && inPointY>minY && inPointY<maxY)
        outPoints(1,outpointCounter) = inPointX;
        outPoints(2,outpointCounter) = inPointY;
        outpointCounter = outpointCounter +1;
    end
        
    i = i+1;
end


end
