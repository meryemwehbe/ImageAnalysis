function [ region_rob ] = robot_fit( im_original, config )
% ROBOT_FIT Extract robot positions.
%   region_rob = ROBOT_FIT(Im, Config). Take the original image and extract the
%   robot and its position. If not robot found, return empty array.

% Main variables
size_image = size(im_original, 1)*size(im_original, 2);

% 1. Go to HSV ref to threshold value (black)
hsv_im = rgb2hsv(im_original);
thresh = hsv_im(:,:,3) < config.black_v_thresh;
% thresh = bwmorph(BW, 'spur', 50);

% 2. Get matching regions and look for bigest (according also to limit
% size)
region_rob = regionprops(thresh, 'Perimeter', 'FilledArea', 'Image', ...
    'Eccentricity', 'Orientation', 'Centroid');

prob_all = [];

for i = length(region_rob):-1:1
    % Check if area and ratio in correct range
    if region_rob(i).FilledArea/size_image < config.size_min_thresh ...
        || region_rob(i).FilledArea/size_image > config.size_max_thresh
        region_rob(i) = [];
        continue
    end
    % Check compacity limit
    region_rob(i).Compacity = region_rob(i).Perimeter^2/region_rob(i).FilledArea ;
    
    prob = normpdf(region_rob(i).Compacity, config.cmp_arrow_thresh, 4) ...
        * normpdf(region_rob(i).Eccentricity, config.ecc_arrow_thresh, 0.1);
    if prob < 1e-3
        region_rob(i) = [];
        continue
    end
    prob_all = [prob, prob_all];
end

if isempty(prob_all)
    region_rob = [];
    return
end

[V, I] = max(prob_all);
region_rob = region_rob(I);
region_rob(1).Prob = V;

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

if ~config.debug
    region_rob = rmfield(region_rob, {'Image', 'FilledArea', 'Perimeter'});
end


end

