function [pointsCloudAfterProcruster,pointsCloud] = getPointsAfterProcrustes(pointViewMatrix)
    numberOfSegments = 5;
    lengthOfSegment = 5;
    segments = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33];
    count = 1;
    for i = segments
        pointViewMatrixSegment  = pointViewMatrix(i:(i+lengthOfSegment),:);
        pointsCloud(count).points      = get3Dpoints(pointViewMatrixSegment);
        count  = count + 1;
    end
    for i = 1:size(pointsCloud,2)
       pointsCloudAfterProcruster(i).points = zeros(3,size(pointsCloud(1).points,2));
    end
    for i = 1:(size(pointsCloud,2)-1)
       index1 = find(all(pointsCloud(i).points)==1);
       index2 = find(all(pointsCloud(i+1).points)==1);
       [~,ia,ib] = intersect(index1,index2);
       if size(ia,1) > 0 
            [d,Z] = procrustes(pointsCloud(i).points(:,index1(ia)),pointsCloud(i+1).points(:,index2(ib)));
       end
       for j = 1:size(ia,1)
           pointsCloudAfterProcruster(i).points(:,ia(j))   = pointsCloud(i).points(:,ia(j));
           pointsCloudAfterProcruster(i+1).points(:,ib(j)) = Z(:,j);
       end
    end
end