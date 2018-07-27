function pointViewMatrix = getPointViewMatrix(ransacSummaryStruct)
    ransacSummary           = ransacSummaryStruct.ransacSummary;
    pointViewMatrix         = zeros(4,size(ransacSummary(1).image1Inliers,2));
    pointViewMatrix(1:2,:)  = ransacSummary(1).image1Inliers(1:2,:);
    pointViewMatrix(3:4,:)  = ransacSummary(1).image2Inliers(1:2,:);
    for i = 2:size(ransacSummary,2)
        index = i*2;
        previous_matches    = pointViewMatrix(index-1:index,:);
        new_matches         = ransacSummary(i).image1Inliers(1:2,:);
        if i == size(ransacSummary,2)
            
            [~, IA, IB] = intersect(previous_matches',ransacSummary(1).image1Inliers(1:2,:)','rows');
            
            if IA ~= 0
                pointViewMatrix(1:2,IA) = ransacSummary(i).image2Inliers(1:2,IB);
            end
            columns = linspace(1,size(ransacSummary(i).image2Inliers,2),size(ransacSummary(i).image2Inliers,2));
            c = setdiff(columns,IA');
            if c ~= 0
                zero_mat = zeros(size(pointViewMatrix,1)-4,length(c));
                zero_mat = [zero_mat; ransacSummary(i).image1Inliers(1:2,c)];
                zero_mat = [zero_mat; ransacSummary(i).image2Inliers(1:2,c)];
                pointViewMatrix = horzcat(pointViewMatrix,zero_mat);
            end       

            
            
            [~, IA]         = setdiff(ransacSummary(i).image2Inliers(1:2,:)',pointViewMatrix(1:2,:)','rows');
            if IA ~= 0
                zero_mat                = zeros(size(pointViewMatrix,1),length(IA));
                zero_mat(1:2,:)         = ransacSummary(i).image2Inliers(1:2,IA); 
                zero_mat(end-1:end,:)   = ransacSummary(i).image1Inliers(1:2,IA); 
                pointViewMatrix         = horzcat(pointViewMatrix,zero_mat);
            end
        else

            [~, IA, IB] = intersect(previous_matches',new_matches','rows');
            pointViewMatrix = [pointViewMatrix; zeros(2,size(pointViewMatrix,2))];
            if IA ~= 0
                
                pointViewMatrix(index+1:index+2,IA) = ransacSummary(i).image2Inliers(1:2,IB);
            end
            columns = linspace(1,size(ransacSummary(i).image2Inliers,2),size(ransacSummary(i).image2Inliers,2));
            c = setdiff(columns,IA');
            if c ~= 0
                zero_mat = zeros(size(pointViewMatrix,1)-4,length(c));
                zero_mat = [zero_mat; ransacSummary(i).image1Inliers(1:2,c)];
                zero_mat = [zero_mat; ransacSummary(i).image2Inliers(1:2,c)];
                pointViewMatrix = horzcat(pointViewMatrix,zero_mat);
            end
            
        end
end
