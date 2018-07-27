% TuDelft - Faculty of Aerospace Engineering
% Computer Vision
% Rohan Camlesh Chotalal -> Student Number: 4746317
% File name: main.m

% Add the sift "library" also used in the second lab:
run('VLFEATROOT/toolbox/vl_setup');

%% 1. Matching

% Folder where all the images are saved:
img_folder = 'TeddyBearPNG';

% Perform this for the all Teddy Bear images
num = 1:20;

%% Step 1 and 2) Detect interest points in each image and extract SIFT descriptors

% Initilization of the cell array that keeps the extracted data for each
% frame/image:
data_img = cell(1,length(num));

for i = 1:length(num)
    if i < 10
        img_name = 'obj02_00';
    else
        img_name = 'obj02_0';
    end
    filename = [img_folder '/' img_name num2str(num(i)) '.png.harhes.sift'];
    [feat,desc,nb,~] = loadFeatures(filename);
    % create auxiliary cell:
    x = feat(1,:);
    y = feat(2,:);
    aux_cell = {x,y;nb,desc}; % {x_feat, y_feat; nb, desc}
    % Append new cell to the global cell array:
    data_img{i} = aux_cell;
end

%% Step 3) Determine the matches for given two consecutive images

% Initilization of the cell array that keeps the information of the matches
matches = cell(1,length(num));

for i = 1:length(num) % i states the current frame
    if i == length(num)
        aux_match = vl_ubcmatch(data_img{i}{2,2},data_img{1}{2,2});
    else
        aux_match = vl_ubcmatch(data_img{i}{2,2},data_img{i+1}{2,2});
    end
    % Append new cell to the global cell array:
    matches{i} = aux_match; % indices for vectors x and y of the matches for 
                            % the current frame (i) and next frame (i+1)
end

%%  Step 4) Remove inconsistent matches with the eight-point Algorithm used with RANSAC: 

% [SOLVE] --> R�PIDO!!! ROHAN, tu consegues bro!! 
%newmatches = matches(:,inliers);

%% Step 5) Already done. It says to repeat the previous steps for all the images in the folder:
% Done with the previous for loop!

%% 2. Chainning
% Create the point-view matrix! Not easy, will do that with the provided
% matches

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

% Function test:
% point_view_mat_2 = p_mat_build(matches,num);


