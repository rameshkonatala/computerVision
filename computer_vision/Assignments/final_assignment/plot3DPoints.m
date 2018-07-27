function plot3DPoints(pointsCloud,pointsCloudAfterProcruster)
    pointsProcruster = [];
    points = [];
    for i = 1:size(pointsCloudAfterProcruster,2)
        pointsProcruster = horzcat(pointsProcruster,pointsCloudAfterProcruster(i).points);
    end
    
    figure(1);
    plot3(pointsProcruster(1,:),pointsProcruster(2,:),pointsProcruster(3,:),'.k','MarkerSize',12);
    
    for i = 1:size(pointsCloud,2)
        points = horzcat(points,pointsCloud(i).points);
    end
    figure(2);
    plot3(points(1,:),points(2,:),points(3,:),'.k','MarkerSize',12);
    
    x = points(1,:);
    y = points(2,:);
    z = points(3,:);
    tri = delaunay(x,y);
    [r,c] = size(tri);
    figure(3);
    h = trisurf(tri, x, y, z);
    axis vis3d;
    rotate3d on;
end

