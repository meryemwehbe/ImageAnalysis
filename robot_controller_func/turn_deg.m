function [ ] = turn_deg( angle , motor_l, motor_r)
motor_l.Speed=-50*sign(angle);
motor_r.Speed=50*sign(angle);
start(motor_l);start(motor_r);
pause(abs(angle/70)) % the 70 constant is experimental but proven
stop(motor_l);stop(motor_r);
end

