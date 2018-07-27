function main()
    matchThreshold      = 1.5;
    distanceThreshold   = 100;
    %siftAndStructImages();
    str = load("baseStruct.mat");
    %matchAndStruct(str.str, matchThreshold);
    ransacAll(distanceThreshold);
    
    %display2FiguresAndTheirPoints(1);
    pointViewMatrix = getPointViewMatrix(load("ransacSummary.mat"));
    [pointsCloudAfterProcruster,pointsCloud] = getPointsAfterProcrustes(pointViewMatrix);
    plot3DPoints(pointsCloud,pointsCloudAfterProcruster);   
end