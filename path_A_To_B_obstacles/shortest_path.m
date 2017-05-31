function [ path_real, map_avoid ] = shortest_path( bin_img, region_robot, point_stop, config )
%shortest_path Calculates the path from A to B avoiding ostacles in the
%binary img

robot_radius = ceil(max(region_robot.BoundingBox(3:4)));
point_start = ceil(region_robot.Centroid);
bin_robot_shape = strel('disk',robot_radius,0).Neighborhood;

%caclulating the scaling factor to perform the alg on the smaller img
scale_factor = size(bin_img,2)/50;

% reshape the image to make the alg faster
bin_img_small = logical(imresize(bin_img, floor(size(bin_img)/scale_factor)));
bin_robot_small = logical(imresize(bin_robot_shape, floor(size(bin_robot_shape)/scale_factor/2))); %dilute the image with the img 2ce smallr than the robot !!!

rad = 6;
%calculate dilution with the robot size
im_obst_with_robot = imdilate(bin_img_small, bin_robot_small);

point_start_fl = floor(point_start/scale_factor);
point_stop_fl = floor(point_stop/scale_factor);

% Around stat point
span_x = point_start_fl(2)+ceil((-rad/2:1:rad/2)); 
span_x = span_x(span_x > 0 & span_x <= size(im_obst_with_robot, 1));
span_y = point_start_fl(1)+ceil((-rad/2:1:rad/2));
span_y = span_y(span_y > 0 & span_y <= size(im_obst_with_robot, 2));
im_obst_with_robot(span_x, span_y) = 0;

% Around end point
span_x = point_stop_fl(2)+ceil((-rad/2:1:rad/2)); 
span_x = span_x(span_x > 0 & span_x <= size(im_obst_with_robot, 1));
span_y = point_stop_fl(1)+ceil((-rad/2:1:rad/2));
span_y = span_y(span_y > 0 & span_y <= size(im_obst_with_robot, 2));
im_obst_with_robot(span_x, span_y) = 0;

try
    [r,c] = shpath(im_obst_with_robot, point_start_fl(2),point_start_fl(1),point_stop_fl(2), point_stop_fl(1));
    path = [r,c]*scale_factor; path = [path(:,2), path(:,1)];
    
    % Remove points to close
%     ids_start = find( sqrt(sum((ones(length(path),1)*point_start ... 
%         - [path(:, 2), path(:,1)]).^2, 2)) > config.max_dist_err);
%     if isempty(ids_start)
%         ids_start = 1;
%     else
%         ids_start = ids_start(1);
%     end
%     path = path(ids_start:end, :);
    path_real = dpsimplify(path,1);
    path_real(1, :) = point_start;
    path_real(end, :) = point_stop;

catch
    path_real = [];
end

map_avoid = logical(imresize(im_obst_with_robot, floor(size(im_obst_with_robot)*scale_factor)));
path_real = [[point_start(1), point_start(2)]; path_real; [point_stop(1), point_stop(2)]];

end
