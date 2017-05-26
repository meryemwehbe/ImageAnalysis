function [ path ] = shortest_path( bin_img, robot_radius,point_start, point_stop )
%shortest_path Calculates the path from A to B avoiding ostacles in the
%binary img

bin_robot_shape = strel('disk',robot_radius,0).Neighborhood;
size_r = floor(size(bin_robot_shape,1)/2);

% Replacing the start and stop points as accessible (remove obstacles)

%%Checking if we're not out of bounds
start_coeff_y1=max(point_start(2)-size_r,1);
start_coeff_y2=min(point_start(2)+size_r,size(bin_img, 1));
start_coeff_x1=max(point_start(1)-size_r,1);
start_coeff_x2=min(point_start(1)+size_r,size(bin_img, 2));

stop_coeff_y1=max(point_stop(2)-size_r,1);
stop_coeff_y2=min(point_stop(2)+size_r,size(bin_img, 1));
stop_coeff_x1=max(point_stop(1)-size_r,1);
stop_coeff_x2=min(point_stop(1)+size_r,size(bin_img, 2));

% Replacing the start and stop points as accessible (remove obstacles)
bin_img(start_coeff_y1:start_coeff_y2,start_coeff_x1:start_coeff_x2) = 0;
bin_img(stop_coeff_y1:stop_coeff_y2,stop_coeff_x1:stop_coeff_x2) = 0;

%caclulating the scaling factor to perform the alg on the smaller img
scale_factor = size(bin_img,2)/200;

% reshape the image to make the alg faster
bin_img_small = logical(imresize(bin_img, floor(size(bin_img)/scale_factor)));
bin_robot_small = logical(imresize(bin_robot_shape, floor(size(bin_robot_shape)/scale_factor/2))); %dilute the image with the img 2ce smallr than the robot !!!

%calculate dilution with the robot size
im_obst_with_robot = imdilate(bin_img_small, bin_robot_small);

point_start = floor(point_start/scale_factor);
point_stop = floor(point_stop/scale_factor);

[r,c] = shpath(im_obst_with_robot, point_start(2),point_start(1),point_stop(2), point_stop(1));

path = [r,c]*scale_factor;
end

