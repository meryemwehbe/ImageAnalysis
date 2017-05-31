function [  ] = go_forward_pixels( pixels, config,  motor_l, motor_r )

% goes forward a number of pixels
if(pixels < 50)
    motor_l.Speed=-35;
    motor_r.Speed=-35;
    start(motor_l);start(motor_r);
    pause(abs(pixels/((50/35)*config.pixpersec))) % the config.pixpersec constant from calibration
    stop(motor_l);stop(motor_r);
else
        motor_l.Speed=-50;
    motor_r.Speed=-50;
    start(motor_l);start(motor_r);
    pause(abs(pixels/(1.2*config.pixpersec))) % the config.pixpersec constant from calibration
    stop(motor_l);stop(motor_r);
end
    

end

