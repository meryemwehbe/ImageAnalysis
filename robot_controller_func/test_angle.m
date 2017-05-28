function [ THEANGLE ] = test_angle( p1, p2, angle_robot )

    diff = p2-p1;
    length = (sqrt(sum(diff.^2)));
    angle = cal_angle([p1';p2']); % TODO Meryem put your point-point angle calc  function here

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
end

