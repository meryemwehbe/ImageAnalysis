% PLAYING WITH path
clean all;
close all;
img = (imread('image_set/WIN_20170511_16_46_11_Pro.jpg' ));
img = sum(img, 3);


bin_img = ones(size(img));
bin_img(img > 350) = 0;

bin_img = logical ( bin_img);

imshow((bin_img));

pos_start = [123;382];
pos_stop = [1163;132];

% Testing the function to calculate the path
tic()
robot_radius = 180; % put here the maximum radius from the center of the robot in pixels
path = shortest_path(bin_img, robot_radius,pos_start, pos_stop);
% The function returns a nice path made of few POINTS, including tsarting
% and finishing point
toc()

hold on;
plot(path(:,2),path(:,1), '-*r');

N_points_in_path = size(path,1); % the number of point in the path inluding start and stop point

% transforming the array of points to the array of angles and lengths in
% pixels
[a, b] = transform_path_to_angle_length(path)

