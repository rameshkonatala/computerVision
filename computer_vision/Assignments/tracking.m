function newCoordinates = tracking(im1,im2,oldCoordinates)
    newCoordinates = zeros(215,2);
    points = 1;
    [x,y,u,v] = optical_flow(im1,im2);
    while points<=size(oldCoordinates,1)
       x = ceil(oldCoordinates(points,1)/15);
       y = ceil(oldCoordinates(points,2)/15);
       du = u(x,y);
       dv = v(x,y);
       newX = oldCoordinates(points,1)+dv;
       newY = oldCoordinates(points,2)+du;
       newCoordinates(points,1) = newX;
       newCoordinates(points,2) = newY;
       points = points+1; 
    end
end