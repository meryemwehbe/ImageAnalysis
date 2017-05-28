function [ homes, regular, homeless, ordered_dest, avoid_map ] = shape_fit( im_original, config, robot_pos )
% SHAPE_FIT Extract shapes positions.
%   region = SHAPE_FIT(Im, Config). Take the original image and extract the
%   shapes and their position. If not shape not found or home badly 
%   detected return empty array.

if nargin < 3
    robot_pos = []
end

% Main variables
size_image = size(im_original, 1)*size(im_original, 2);

% 1. Split forground / background
%[BW, T] = edge(rgb2gray(im_original),'Canny', []);
BW = edge(rgb2gray(im_original),'Canny', [0.01, 0.05]);

BW = bwmorph(BW, 'thicken', 1);
BW = bwmorph(BW, 'close', 1);
BW = bwmorph(BW, 'shrink', 1);
% BW = bwmorph(BW, 'bridge', 5);
BW = bwmorph(BW, 'spur', 50);


% figure()
% imshow(BW); hold on;
% BW = bwmorph(BW, 'remove', inf);
% figure()
% imshow(BW); hold on;
% BW = bwmorph(BW, 'clean', inf);
% figure()
% imshow(BW); hold on;
% BW = bwmorph(BW, 'diag', inf);
% figure()
% imshow(BW); hold on;
% BW = bwmorph(BW, 'close', 5);
% figure()
% imshow(BW); hold on;

% 2. Remove fake results (robot, table, small shapes, ... etc)
region = regionprops(BW, 'BoundingBox', 'FilledArea', 'Perimeter', ...
    'Centroid', 'Image', 'PixelIdxList');

homes_sz = [];
% 
% figure()
% imshow(BW); hold on;
% 4. Detection of colors (HSV)
f_rob_dist = @ (reg, rob) sqrt((reg.Centroid(1)-rob.Centroid(1)).^2 + ...
    (reg.Centroid(2)-rob.Centroid(2)).^2);

for i = length(region):-1:1
    
    % Check if area and ratio in correct range
    if region(i).FilledArea/size_image < config.size_min_thresh ...
            || region(i).FilledArea/size_image > config.size_max_thresh
        region(i) = [];
        continue
    end
    % Check compacity limit
    if region(i).Perimeter^2/region(i).FilledArea > config.compacity_thresh
        region(i) = [];
        continue
    end
    % Check if not robo detection
    if ~isempty(robot_pos) && f_rob_dist(robot_pos(1), region(i)) < 20
        region(i) = [];
        continue
    end
    % Check shape fitting
    region(i).ShapeProb = shape_classifier(region(i));
    if max(region(i).ShapeProb) < config.prop_shape_thresh
        % Fake shape ? -> put it as null
        region(i) = [];
        continue
    end
    % Set as not home (default)
    region(i).Home = 0;
    region(i).Compacity = region(i).Perimeter^2/region(i).FilledArea;
    homes_sz = [region(i).FilledArea, homes_sz];
end

if length(region) < config.n_homes
    homes = [];
    regular = [];
    homeless = [];
    ordered_dest = [] ;
    avoid_map = [];
    return 
end

% 3. Set homes regions (based on top K sizes)
[~, I] = sort(homes_sz);
for i = I(end-(config.n_homes-1):end)
    region(i).Home = 1;
end

% 4. Detection of colors (HSV)
f_dist = @ (c_est, c_ref) sqrt((cos(2*pi*c_est)-cos(2*pi*c_ref)).^2 + ...
    (sin(2*pi*c_est)-sin(2*pi*c_ref)).^2);
range = (-config.r_color_detect:1:config.r_color_detect);
% Look for color of every region
for i = 1:length(region)
    % Get color matrix (not only central point)
    sub_color = im_original(floor(region(i).Centroid(2))+range, ...
        floor(region(i).Centroid(1))+range, :);
    % Get median approximation of color of shape
    sub_color = rgb2hsv(median(reshape(sub_color, [], 3), 1));
    
    % Check if grey
    if sub_color(2) < config.color_saturation_thresh
        region(i).Color = config.color_str{end};
    else
        % Get minimal distance (only Hue and Saturation)
        [~, I] = min(f_dist(sub_color(1), config.color_hue_thresh));
        region(i).Color = config.color_str{I};
    end
    region(i).ColorHSV = sub_color;
end

% 5. Detection of shape (based on compacity)
for i = 1:length(region)
    [~, id_shape] = max(region(i).ShapeProb);
    region(i).Shape = config.shape_str{id_shape};
end

% 6. Region ordering

[homes, regular, homeless, ordered_dest] = Ordering( region, config );
avoid_map = zeros(size(im_original, 1), size(im_original, 2));

% Avoid zone homeless
for i=1:length(homeless)
    % im_avoid(homeless_objects(i).PixelIdxList) = 1;
    bb = ceil(homeless(i).BoundingBox);
    avoid_map(bb(2):bb(2)+bb(4), bb(1):bb(1)+bb(3)) = 1;
end

% Avoid zone shape_center
for i=1:length(regular)
    % im_avoid(homeless_objects(i).PixelIdxList) = 1;
    cen = ceil(regular(i).Centroid);
    avoid_map(cen(2)-config.shape_avoid_rad:cen(2)+config.shape_avoid_rad, ...
        cen(1)-config.shape_avoid_rad:cen(1)+config.shape_avoid_rad) = 1;
end

% If not debug remove useless fields in structure
if ~config.debug
    homes = rmfield(homes, {'Perimeter', 'FilledArea', 'Image', ...
        'ShapeProb', 'Compacity', 'PixelIdxList'});
    regular = rmfield(regular, {'Perimeter', 'FilledArea', 'Image', ...
        'ShapeProb', 'Compacity', 'PixelIdxList'});
    homeless = rmfield(homeless, {'Perimeter', 'FilledArea', 'Image', ...
        'ShapeProb', 'Compacity', 'PixelIdxList'});
end


end

