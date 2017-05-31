function [ ] = turn_deg( angle , config, motor_l, motor_r)
% turn the robot into some angle 

if(abs(angle) < 15) % if angle is small(<15deg), move slower for smaller error
    motor_l.Speed=-15*sign(angle);
    motor_r.Speed=15*sign(angle);
    start(motor_l);start(motor_r);
    pause(abs(angle/(config.degreespersec*0.1))) % the constant from calibration
    stop(motor_r);stop(motor_l);
elseif(abs(angle) < 90) % if angle is middle, move middle slow for smaller error
    motor_l.Speed=-50*sign(angle);
    motor_r.Speed=50*sign(angle);
    start(motor_l);start(motor_r);
    pause(abs(angle/(config.degreespersec*0.3)))% the constant from calibration
    stop(motor_r);stop(motor_l);
else  % if angle is big(>90), just turn fast 
    motor_l.Speed=-70*sign(angle);
    motor_r.Speed=70*sign(angle);
    start(motor_l);start(motor_r);
    pause(abs(angle/(config.degreespersec*0.4)))% the constant from calibration
    stop(motor_r);stop(motor_l);
end
    
     
end

