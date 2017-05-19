function [ region_rob ] = robot_fit( im_original, config )
% ROBOT_FIT Extract robot positions.
%   region_rob = ROBOT_FIT(Im, Config). Take the original image and extract the
%   robot and its position. If not robot found, return empty array.

% Main variables
size_image = size(im_original, 1)*size(im_original, 2);

% 1. Go to HSV ref to threshold value (black)
hsv_im = rgb2hsv(im_original);
thresh = hsv_im(:,:,3) < config.black_v_thresh;

% 2. Get matching regions and look for bigest (according also to limit
% size)
region_rob = regionprops(thresh, 'Area', 'Image', 'Orientation', 'Centroid');

areas = [];
for i = length(region_rob)-1:-1:1
    if region_rob(i).Area/size_image < config.size_min_thresh ...
        || region_rob(i).Area/size_image > config.size_max_thresh
        region_rob(i) = [];
        continue
    end
    
    areas = [region_rob(i).Area, areas];
end

if length(areas) == 0
    region_rob = [];
    return
end

[~, I] = max(areas);
region_rob = region_rob(I);

% 3. Look for angle of arrrow (according to x axis)
% Project point on main axis to look for direction. Region of arrow head
% will be more dense
ids = find(region_rob.Image == 1);
[row, col] = ind2sub(size(region_rob.Image), ids);
thetha_ref2 = deg2rad(region_rob.Orientation) + pi/2;

% 4. Check interval [-pi, pi] is correct
% Center image according to image center .... Could be an issue
% (considering centroid might be better)
X = row - size(region_rob.Image,1)/2; Y = col - size(region_rob.Image,2)/2;
base = [cos(thetha_ref2); sin(thetha_ref2)];
v = dot([X,Y]',base*ones(1, length(X))); % Project point on axis

% Check if need to inverse dirrection (arrow head pointing other direction)
if sum(v < 0) > sum(v > 0)
    region_rob.Orientation = radtodeg(pi) + region_rob.Orientation;
end

region_rob = rmfield(region_rob, {'Image', 'Area'});

end

