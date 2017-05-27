function [  ] = go_forward_pixels( pixels , motor_l, motor_r )
% goes forward a number of pixels
motor_l.Speed=-50;
motor_r.Speed=-50;
start(motor_l);start(motor_r);
pause(abs(pixels/65)) % the 60 constant is experimental but proved
stop(motor_l);stop(motor_r);
end

