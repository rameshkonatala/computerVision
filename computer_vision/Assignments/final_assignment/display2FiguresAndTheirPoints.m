function display2FiguresAndTheirPoints(index)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%load Structs
index2 = index+1;
if(index2>19)
    index2 = 1;
end

base = load('baseStruct.mat', 'str');
base = base.str;
matched = load('matchedStruct.mat');
matched = matched.matchedStr;
ransac = load('ransacSummary.mat');
ransac = ransac.ransacSummary;
image1 = readImages(index);
image2 = readImages(index2);

pointsToDisplayInFigure1 = getPoints(base,matched,ransac,index, index2);
figure;
displayPoints(pointsToDisplayInFigure1,image1,image2);
title('Points');
%
pointsToDisplayInFigure2 = getMatchedPoints(base,matched,ransac,index, index2);
figure;
displayPoints(pointsToDisplayInFigure2,image1,image2);
title('Matches');

end


function points = getPoints(base, matched, ransac, index, index2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
baseIndex = base(index).F;
secondBaseIndex = base(index2).F;
matchedIndex = matched(index).a;
ransacIndex = ransac(index).randomIndices;

i = 1;
s = size(ransacIndex);
width = s(2);
while i<=width
    currentRansacIndex = ransacIndex(i);
    firstIndex = matchedIndex(1,currentRansacIndex);
    secondIndex = matchedIndex(2,currentRansacIndex);
    firstX = baseIndex(1,firstIndex);
    firstY = baseIndex(2,firstIndex);
    secondX = secondBaseIndex(1,secondIndex);
    secondY = secondBaseIndex(2,secondIndex);
    points(1,i) = firstX;
    points(2,i) = firstY;
    points(3,i) = secondX;
    points(4,i) = secondY;
    
    
    i = i+1;
end    

end

function matchedPoints = getMatchedPoints(base, matched, ransac, index, index2)
    firstPoints = ransac(index).image1Inliers;
    secondPoints = ransac(index).image2Inliers;
    k = size(firstPoints);
    curWidth = k(2);
    p = 1;
    while p<=curWidth
        matchedPoints(1,p) = firstPoints(1,p);
        matchedPoints(2,p) = firstPoints(2,p);
        matchedPoints(3,p) = secondPoints(1,p);
        matchedPoints(4,p) = secondPoints(2,p);
        p = p+1;
    end
end




function d = displayPoints(a, im1, im2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
im3 = cat(2,im1,im2);
imsize = size(im1);
imwidth = imsize(2);
imshow(im3);
hold on;
i = 1;
s = size(a);
width = s(2);
while i<=width
    plot(a(1,i) , a(2,i) ,'r*', 'LineWidth', 2, 'MarkerSize', 5);
    a(3,i) = a(3,i)+imwidth;
    plot(a(3,i) , a(4,i) ,'r*', 'LineWidth', 2, 'MarkerSize', 5); 
    i = i+1; 
end
h = line([a(1,:) ; a(3,:)], [a(2,:); a(4,:)]) ;
        set(h,'linewidth', 0.2, 'color', 'b');

end


