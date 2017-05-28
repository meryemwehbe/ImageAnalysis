function [  ] = go_forward_pixels( pixels, config,  motor_l, motor_r )

% goes forward a number of pixels
motor_l.Speed=-50;
motor_r.Speed=-50;
start(motor_l);start(motor_r);
pause(abs(pixels/config.pixpersec)) % the config.pixpersec constant from calibration
stop(motor_l);stop(motor_r);
end

