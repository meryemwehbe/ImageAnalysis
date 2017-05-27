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
    path = [pos_robot;pos_fin];
    angle_robot = (region_rob.Orientation-90);

    % calculate the angle and length of the path
    p1 = [path(1,2); path(1,1)];
    p2 = [path((2),2); path((2),1)];
    diff = p2-p1;
    length = (sqrt(sum(diff.^2)));
    angle = cal_angle([p1';p2']); % TODO Meryem put your point-point angle calc  function here

    %TODO Meryem
    if(angle*angle_robot > 0 )
        if(angle > 0 && angle_robot < angle )
            THEANGLE = -1*abs(angle-angle_robot);
        elseif(angle > 0)
              THEANGLE = abs(angle-angle_robot);
        elseif(angle < 0 && abs(angle_robot) < abs(angle))  
            THEANGLE = abs(angle-angle_robot);
        else
            THEANGLE = -1*abs(angle-angle_robot);
        end
    else
       THEANGLE = -1*abs(angle_robot-angle);
    end
    
    
    THEANGLE
    % turn the robot to degree difference 
    if(abs(THEANGLE)> cfg.max_angle_err)
        turn_deg( THEANGLE ,cfg, motor_l, motor_r)
    else
        break;
    end
    
end

% go forward when the angle is adjusted
go_forward_pixels(length, cfg, motor_l, motor_r );

% for debugging
%pic=getsnapshot(vid);
%figure()
%imshow(pic)

end

