function point_view_mat = p_mat_build(matches,num)

point_view_mat = zeros(2,size(matches{1},2));

% Step 1 - Fill in the first two views:
point_view_mat(1,:) = matches{1}(1,:);
point_view_mat(2,:) = matches{1}(2,:);

for i = 2:length(num) % i states the current frame
    previous_matches = point_view_mat(i,:);
    new_matches = matches{i}; % new matches of the current frame
    if i == length(num)
        % Add information about the new points - add new columns -> compare
        % new matches of the first row
        [~, IA] = setdiff(new_matches(2,:),point_view_mat(1,:));
        if IA ~= 0
            zero_mat = zeros(size(point_view_mat,1),length(IA));
            zero_mat(1,:) = new_matches(2,IA); % add the matches in the first view
            zero_mat(end,:) = new_matches(1,IA); % add the new matches in the last view
            point_view_mat = horzcat(point_view_mat,zero_mat);
        end
    else
        [~, IA, IB] = intersect(previous_matches,new_matches(1,:));
        % Add information about previous matches - add new line
        if IA ~= 0 % if previous points were already found, add new line due to new frame
            point_view_mat = [point_view_mat; zeros(1,size(point_view_mat,2))];
            point_view_mat(i+1,IA) = new_matches(2,IB);
        end
        % Add information about the new points - add new columns
        [~, IA] = setdiff(new_matches(1,:),new_matches(2,IB));
        if IA ~= 0
            zero_mat = zeros(size(point_view_mat,1)-1,length(IA));
            zero_mat = [zero_mat; new_matches(2,IA)];
            point_view_mat = horzcat(point_view_mat,zero_mat);
        end
    end
end