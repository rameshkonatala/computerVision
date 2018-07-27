function points3D = get3Dpoints(pointViewMatrixSegment)
    points3D = zeros(3,size(pointViewMatrixSegment,2));
    columnsWithNoZeros     = all(pointViewMatrixSegment);
    pointViewMatrixSegment = pointViewMatrixSegment(:,columnsWithNoZeros)
    if size(pointViewMatrixSegment,2)>3
        %pointViewMatrixSegment = normalize(pointViewMatrixSegment,2);
        [U,W,V] = svd(pointViewMatrixSegment);
        U = U(:,1:3);
        W = W(1:3,1:3);
        V = V(:,1:3);
        M = U*sqrt(W);
        S = sqrt(W)*V';
        points3D(:,columnsWithNoZeros) = S;
        save('M','M');
% %solve for affine ambiguity
        
%         A = M(1:2,:);
%         L0= pinv(A'*A);
% 
%         % Solve for L
%         L = lsqnonlin(@myfun,L0);
%         % Recover C
%         [C,p] = chol(L,'lower');
%         % Update M and S
%         if size(C,1)>0
%             M = M*C;
%             S = pinv(C)*S;
%             points3D(:,columnsWithNoZeros) = S;
%         end
    end

end