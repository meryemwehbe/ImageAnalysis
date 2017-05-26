clc; clear all; close all;

%%
clc; clear all; close all;
ev3 = legoev3('bt','001653495fad');
vid = videoinput('winvideo',1,'RGB24_640x480');

%%
motor_r = motor(ev3, 'A');
motor_l = motor(ev3, 'B');

%
motor_l.Speed = 50;
motor_r.Speed = 50;


%%
time = 2
i = i +1
pic=getsnapshot(vid);
imwrite(pic,sprintf('straight_bfr_r50_%1.1f_%i.png', time, i))

% go straight
start(motor_l);start(motor_r);
pause(time)
stop(motor_l);stop(motor_r);

pic=getsnapshot(vid);
imwrite(pic,sprintf('straight_aft_r50_%1.1f_%i.png', time, i))


%% turn -> go right
motor_l.Speed=-50;
motor_r.Speed=50;

%%
time = 0.2
k = k +1

pic=getsnapshot(vid);
imwrite(pic,sprintf('rot_bfr_50_%1.1f_%i.png', time, k))

start(motor_l);start(motor_r);
pause(time)
stop(motor_l);stop(motor_r);

pic=getsnapshot(vid);
imwrite(pic,sprintf('rot_aft_50_%1.1f_%i.png', time, k))

%% test

motor_l.Speed=-40;
motor_r.Speed=-40;
start(motor_l);start(motor_r);
pause(5)
stop(motor_l);stop(motor_r);

