function [ move_success, angle] = moveRobot( region_robot, cfg, pos_fin , motor_l, motor_r)
%MOVEROBOT Moves robot to a point pos_fin

% get the angle and position of the robot
pos_robot = ceil(region_robot.Centroid);
angle_robot = region_robot.Orientation;

% calculate the angle and length of the path
length = sqrt(sum((pos_robot-pos_fin).^2));
angle = cal_angle(pos_robot, pos_fin); 
rotation_angle = -(angle - angle_robot);

% Check if within an acceptable radius
% if length < cfg.max_dist_err
%     move_success = 1;
%     return;
% end

% turn the robot to degree difference is needed and go forward
if(abs(rotation_angle)> cfg.max_angle_err)
    %turn_deg( rotation_angle ,cfg, motor_l, motor_r)
else
    %go_forward_pixels(length, cfg, motor_l, motor_r );
    move_success = 1;
    return
end

move_success = 0;

end

