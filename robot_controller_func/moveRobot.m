function [  ] = moveRobot( vid, cfg, pos_fin , motor_l, motor_r)
%MOVEROBOT Moves robot to a point pos_fin
close all;

for i=1:10 % angle regulation loop - after 10 times we stop adjusting  angle and go forward
    % for debugging
    pic=getsnapshot(vid);
    %figure()
    imshow(pic)

    % get the angle and position of the robot
    region_rob = robot_fit( im2double(pic), cfg );
    pos_robot = ceil(region_rob.Centroid);
    angle_robot = region_rob.Orientation;

    % calculate the angle and length of the path
    length = sqrt(sum((pos_robot-pos_fin).^2));
    angle = cal_angle(pos_robot, pos_fin); 
    rotation_angle = -(angle - angle_robot);
    
    % Check if within an acceptable radiuss
    if length < cfg.max_dist_err
        display('Done')
        break
    end
        
    % turn the robot to degree difference is needed and go forward
    if(abs(rotation_angle)> cfg.max_angle_err)
        turn_deg( rotation_angle ,cfg, motor_l, motor_r)
    else
        go_forward_pixels(length, cfg, motor_l, motor_r );
    end
    
end

% go forward when the angle is adjusted


% for debugging
%pic=getsnapshot(vid);
%figure()
%imshow(pic)

end

