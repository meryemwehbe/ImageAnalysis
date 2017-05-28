clc; clear all; close all;

vid = videoinput('winvideo',1,'RGB24_640x480');
pic=getsnapshot(vid);
imshow(pic)

%%
clc; clear all; close all;
ev3 = legoev3('bt','001653495fad');

%%
motor_r = motor(ev3, 'A');
motor_l = motor(ev3, 'B');

%
motor_l.Speed = -50;
motor_r.Speed = -50;

% go straight
start(motor_l);start(motor_r);
pause(1)
stop(motor_l);stop(motor_r);

%% reverse 
%
motor_l.Speed = 50;
motor_r.Speed = 50;

% go straight
start(motor_l);start(motor_r);
pause(1)
stop(motor_l);stop(motor_r);


%% turn
motor_l.Speed=-50;
motor_r.Speed=50;
start(motor_l);start(motor_r);
pause(3)
stop(motor_l);stop(motor_r);

%% test

motor_l.Speed=-40;
motor_r.Speed=-40;
start(motor_l);start(motor_r);
pause(5)
stop(motor_l);stop(motor_r);

