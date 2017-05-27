function [ ] = turn_deg( angle , motor_l, motor_r)
% turn the robot into some angle 

if(abs(angle) < 15) % if angle is small(<15deg), move slower fro smaller error
    motor_l.Speed=-15*sign(angle);
    motor_r.Speed=15*sign(angle);
    start(motor_l);start(motor_r);
    pause(abs(angle/20)) % the 20 constant is experimental but proven
    stop(motor_r);stop(motor_l);
elseif(abs(angle) < 90) % if angle is middle, move middle slow fro smaller error
    motor_l.Speed=-50*sign(angle);
    motor_r.Speed=50*sign(angle);
    start(motor_l);start(motor_r);
    pause(abs(angle/75)) % the 75 constant is experimental but proven
    stop(motor_r);stop(motor_l);
else  % if angle is big(>90), just turn fast 
    motor_l.Speed=-70*sign(angle);
    motor_r.Speed=70*sign(angle);
    start(motor_l);start(motor_r);
    pause(abs(angle/95)) % the 95 constant is experimental but proven
    stop(motor_r);stop(motor_l);
end
    
     
end

