function [ config ] = calibrate( config, vid, motor_l, motor_r )
%calibrate This function calibrates the motor constants is config          
% (degreespersec and pixpersec\)
pic=getsnapshot(vid);

% get the angle and position of the robot
region_rob = robot_fit( im2double(pic), config );
pos_robot1 = ceil(region_rob.Centroid);

motor_l.Speed=-50;
motor_r.Speed=-50;
start(motor_l);start(motor_r);
pause(2) 
stop(motor_l);stop(motor_r);

pic=getsnapshot(vid);

% get the angle and position of the robot
region_rob = robot_fit( im2double(pic), config );
pos_robot2 = ceil(region_rob.Centroid);
angle_robot2 = region_rob.Orientation;

config.pixpersec = norm(pos_robot1-pos_robot2)/2;

motor_l.Speed=-50;
motor_r.Speed=50;
start(motor_l);start(motor_r);
pause(1) 
stop(motor_l);stop(motor_r);

pic=getsnapshot(vid);

% get the angle and position of the robot
region_rob = robot_fit( im2double(pic), config );
angle_robot3 = region_rob.Orientation;

config.degreespersec = abs(angle_robot2 - angle_robot3);

end

