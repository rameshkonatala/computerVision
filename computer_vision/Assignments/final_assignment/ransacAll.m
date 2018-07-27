function ransacSummary = ransacAll(threshold)
    baseStruct      = load("baseStruct.mat");
    matchedStruct   = load("matchedStruct.mat");
    for i=1:19
       F_im1                                = baseStruct.str(i).F;
       if i==19
            F_im2                                = baseStruct.str(1).F; 
       else
            F_im2                                = baseStruct.str(i+1).F; 
       end 
       matches12                            = matchedStruct.matchedStr(i).a;
       [points1,points2]                    = getCoordinatesFromMatches(F_im1,F_im2, matches12);
       inlierSummary                        = RANSAC(points1,points2,threshold);
       ransacSummary(i).randomIndices       = inlierSummary.randomIndices;
       ransacSummary(i).inliers             = inlierSummary.inliers;
       ransacSummary(i).inlierCount         = inlierSummary.inlierCount;
       ransacSummary(i).image1Inliers       = inlierSummary.image1Inliers;
       ransacSummary(i).image2Inliers       = inlierSummary.image2Inliers;
       save('ransacSummary.mat', 'ransacSummary')
    end
    
end

function [points1,points2] = getCoordinatesFromMatches(F_im1,F_im2, matches_12)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
points1             = F_im1(1:2,matches_12(1,:));
points2             = F_im2(1:2,matches_12(2,:));

end

function inlierSummary = RANSAC(points1,points2,threshold)

oneVector                           = ones(1,size(points1,2));
points1                             = vertcat(points1,oneVector);
points2                             = vertcat(points2,oneVector);
T1                                  = getNormalizationMatrixT(points1);
nomarlizedPoints1                   = normalizeMatrix(points1,T1);
T2                                  = getNormalizationMatrixT(points2);
nomarlizedPoints2                   = normalizeMatrix(points2,T2);

    for i = 1:10000
        randomIndices                       = getRandomIndices(points1);
        randomPoints1                       = points1(:,randomIndices);
        randomPoints2                       = points2(:,randomIndices);
        A                                   = constructA(randomPoints1,randomPoints2);
        F                                   = getF(A);
        F                                   = denormalizeMatrix(F,T2,T1);
        distances                           = sampsonDistance2SetsOfPoints(points1,points2,F);
        %threshold                           = 10;
        distances                           = distances<threshold;
        inliers                             = find(distances==1);
        image1Inliers                       = points1(:,inliers);
        image2Inliers                       = points2(:,inliers);
        inlierCount                         = size(inliers,2);
        iterationSummary(i).randomIndices   = randomIndices;
        iterationSummary(i).inliers         = inliers;
        iterationSummary(i).image1Inliers   = image1Inliers;
        iterationSummary(i).image2Inliers   = image2Inliers;
        iterationSummary(i).inlierCount     = inlierCount;
    end
    [~,ind] = max([iterationSummary.inlierCount]);
    inlierSummary = iterationSummary(ind)
end

function A = constructA(points1,points2)
    A = zeros(size(points1,2),9);
    x = points1(1,:);
    y = points1(2,:);
    x1 = points2(1,:);
    y1 = points2(2,:);
    A(:,1) = (x.*x1)';
    A(:,2) = (x.*y1)';
    A(:,3) = (x)';
    A(:,4) = (y.*x1)';
    A(:,5) = (y.*y1)';
    A(:,6) = (y)';
    A(:,7) = (x1)';
    A(:,8) = (y1)';
    A(:,9) = ones(size(points1,2),1)';
end

function F = getF(A)
    [U,S,V] = svd(A);
    [x,y] = find(S==min(min(S(S>0))));
    F = V(:,x);
    F = reshape(F,[3,3]);
    [U,S,V] = svd(F);
    [x,y] = find(S==min(min(S(S>0))));
    S(x,y) = 0;
    F = U*S*V';
end

function T = getNormalizationMatrixT(A)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% A = 3xN
Ax = A(1,:);
Ay = A(2,:);
Mx =  mean(Ax);
My =  mean(Ay);
d1 = (Ax-Mx).^2;
d2 = (Ay-My).^2;
d = mean(sqrt(d1+d2));
v2 = sqrt(2);
T = [v2/d 0 -Mx*v2/d;...
    0 v2/d -My*v2/d;...
    0 0 1];
end


function di = sampsonDistance2SetsOfPoints(P1, P2, F)
%Creates the distance vector for these 2 images or sets of point matches
%P1 and P2 are 3xN matrices of points. F is a 3x3 Fundamental Matrix
%Returns: di, a 1xN matrix containing the sampson distance for the points
%pi and pi2 at index i
sz = size(P1);
width = sz(2);
di = zeros(1,width);
i = 1;

while i<=width
    pi = P1(:,i);
    pi2 = P2(:,i);
    di(i) = sampsonDistance2Points(pi,pi2,F);
    i = i+1;
end

end

function di = sampsonDistance2Points(pi, pi2, F)

%variables: pi and pi2 are 3x1 matrices . F is a 3x3 Fundamental MAtrix
%This function returns the distance between the 2 points as calculated with this possible
%fundamental matrix. Use a threshold with the outcome of this function to
%determine if it is an inlier

%transposes of the required matrices
Tpi2 = pi2.';
TF = F.';

topOfEquation = (Tpi2*F*pi)^2;
Fpi = F*pi;
FTpi2 = TF*pi2;
bot1 = Fpi(1)^2;
bot2 = Fpi(2)^2;
bot3 = FTpi2(1)^2;
bot4 = FTpi2(2)^2;

bottomOfEquation = bot1+bot2+bot3+bot4;
di = topOfEquation/bottomOfEquation;

end


function [NM] = normalizeMatrix(A,T)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%A is 3xN matrix of points
% T is 3x3 normalization matrix obtained by getNormalizationMatrix(A)

NM = T*A;
end


function DM = denormalizeMatrix(F2, T1, T2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%transpose T2
TP2 = T2.';
F = TP2*F2*T1;
DM = F;

end


function indices = getRandomIndices(points)
    minX = 995;
    minY = 642;
    maxX = 3066;
    maxY = 2123;
    lengthOfSegment_x = (maxX - minX)/4;
    lengthOfSegment_y = (maxY - minY)/2;
    points = vertcat(points,zeros(1,size(points,2)));
    for i = 1:size(points,2)
        if (points(1,i) < minX+lengthOfSegment_x) && (points(1,i) > minX) && (points(2,i) < minY + lengthOfSegment_y)  && (points(2,i) > minY)
            points(4,i) = 1;
        elseif (points(1,i) < minX+(2*lengthOfSegment_x)) && (points(1,i) > minX+(lengthOfSegment_x)) && (points(2,i) < minY + (lengthOfSegment_y))  && (points(2,i) > minY)
            points(4,i) = 2;
        elseif (points(1,i) < minX+(3*lengthOfSegment_x)) && (points(1,i) > minX+(2*lengthOfSegment_x)) && (points(2,i) < minY + (lengthOfSegment_y))  && (points(2,i) > minY)
            points(4,i) = 3;
        elseif (points(1,i) < minX+(4*lengthOfSegment_x)) && (points(1,i) > minX+(3*lengthOfSegment_x)) && (points(2,i) < minY + (lengthOfSegment_y))  && (points(2,i) > minY)
            points(4,i) = 4;
        elseif (points(1,i) < minX+(1*lengthOfSegment_x)) && (points(1,i) > minX+(0*lengthOfSegment_x)) && (points(2,i) < minY + (2*lengthOfSegment_y))  && (points(2,i) > minY + (lengthOfSegment_y))
            points(4,i) = 5;
        elseif (points(1,i) < minX+(2*lengthOfSegment_x)) && (points(1,i) > minX+(1*lengthOfSegment_x)) && (points(2,i) < minY + (2*lengthOfSegment_y))  && (points(2,i) > minY + (lengthOfSegment_y))
            points(4,i) = 6;
        elseif (points(1,i) < minX+(3*lengthOfSegment_x)) && (points(1,i) > minX+(2*lengthOfSegment_x)) && (points(2,i) < minY + (2*lengthOfSegment_y))  && (points(2,i) > minY + (lengthOfSegment_y))
            points(4,i) = 7;
        elseif (points(1,i) < minX+(4*lengthOfSegment_x)) && (points(1,i) > minX+(3*lengthOfSegment_x)) && (points(2,i) < minY + (2*lengthOfSegment_y))  && (points(2,i) > minY + (lengthOfSegment_y))
            points(4,i) = 8;
        
        else 
            points(4,i) = 9;
        end
    end
    indices = [];
    for i = 1:8
       [~,col] = find(points == i);
       if size(col,1)>0
            index = randsample(col,1);
       else
           col = linspace(1,size(points,2),size(points,2))';
           index = randsample(col,1);
       end
       indices = [indices index];
    end
end
