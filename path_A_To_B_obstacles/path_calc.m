% PLAYING WITH path
clean all;
close all;
img = (imread('WIN_20170511_16_46_11_Pro.jpg' ));
img = sum(img, 3);

bin_img = ones(size(img));
bin_img(img > 350) = 0;

bin_img = logical ( bin_img);

imshow((bin_img));

pos_start = [115;380];
pos_stop = [1163;132];

% Testing the function to calculate the path
tic()
robot_radius = 180; % put here the maximum radius from the center of the robot in pixels
path = shortest_path(bin_img, robot_radius,pos_start, pos_stop);
toc()

hold on;
plot(path(:,2),path(:,1), 'r');