function [  ] = moveRobot( vid, cfg, pos_fin , motor_l, motor_r)
%MOVEROBOT Moves robot to a point pos_fin
close all;

% for debugging
pic=getsnapshot(vid);
figure()
imshow(pic)

% get the angle and position of the robot
region_rob = robot_fit( pic, cfg );
pos_robot = ceil(region_rob.Centroid);
path = [pos_robot;pos_fin];
angle_robot = region_rob.Orientation;

% calculate the angle and length of the path
p1 = [path(1,2); path(1,1)];
p2 = [path((2),2); path((2),1)];
diff = p1-p2;
length = (sqrt(sum(diff.^2)));
angle = rad2deg(atan(diff(2)/diff(1))); % TODO Meryem put your point-point angle calc  function here

% turn the robot to degree difference 
% @TODO make a new image acqusition to correct it few times before we start
% moving forward
turn_deg( angle_robot - angle , motor_l, motor_r)

% got forward
go_forward_pixels(length, motor_l, motor_r );

% for debugging
pic=getsnapshot(vid);
figure()
imshow(pic)

end

