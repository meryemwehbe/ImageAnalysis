function [ path ] = shortest_path( bin_img, bin_robot_shape,point_start, point_stop )
%shortest_path Calculates the path from A to B avoiding ostacles in the
%binary img

scale_factor = 5;

% reshape the image to make the lag faster

bin_img_small = logical(imresize(bin_img, floow(size(bin_img)/scale_factor)));
bin_robot_small = logical(imresize(bin_robot_shape, floor(size(bin_robot_shape)/scale_factor)));
im_obst_with_robot = imdilate(bin_img_small, bin_robot_small);

point_start = floor(point_start/scale_factor);
point_stop = floor(point_stop/scale_factor);

[r,c] = shpath(im_obst_with_robot, point_start(2),point_start(1),point_stop(2), point_stop(1));

path = [r,c];
end

