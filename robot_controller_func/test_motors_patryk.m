clc; clear all; close all;

ev3 = legoev3('bt','001653495fad');
vid = videoinput('winvideo',1,'RGB24_640x480');

motor_r = motor(ev3, 'A');
motor_l = motor(ev3, 'B');
%% config
config.n_homes = 2;                         % Number of homes
config.shape_str = ...
    {'Circle', 'Square', 'Triangle'};
config.size_min_thresh = 1e-3;              % Minimum size objects
config.size_max_thresh = 1e-1;              % Maximum size objects
config.compacity_thresh = 30;               % Compacity threshold, bad shape
config.cmp_arrow_thresh = 57;               % Wanted compacity
config.ecc_arrow_thresh = 0.77;               % Wanted compacity
config.cmp_arrow_max_dist = 10;             % Max distancearoud thresh
config.prop_shape_thresh = 0.6;             % Minimal probaility of shape
% 0.2 - Robot detection
config.black_v_thresh = 0.5;                % Value threshold
% 0.3 - Shape color detections
config.r_color_detect = 5;                  % Color median radius
config.color_str = ...
    {'Red', 'Yellow', 'Green', 'Brown', 'Blue', 'Pink', 'Grey'};
config.color_hue_thresh = ...
    [0.032, 0.13, 0.39, 0.072, 0.63, 0.94, inf];
config.color_saturation_thresh = 0.25;
% 0.4 -Display options
config.diplay_res = 1;                      % Dispaly image with detected obj
config.debug = 1;                           % Do not remove attributes regions
config.save_res = 1;                        % Save results
config.save_filename = 'res/display.png';   % Save filename
config.shape_avoid_rad = 2;

% motor constants DO CALIBRATION BEFORE with conf = calibration() function 
config.degreespersec = 90; % default values
config.pixpersec = 100; % default values

% Robot controller options
config.max_angle_err = 2; %maximum turn angle after we go forward
config.max_dist_err = 10;
config.point_point_accuracy = 50; % maximum error between stop point and robot point after we consider them the same 
config.robot_radius = 100;

%% !!! calibration !!!!!!!!
%calibrate();

%% TESTING

moveRobot(vid,config,[179 165],motor_l,motor_r);

p1togo = [408 255];

p2togo = [232 401];

p3togo = [413 257];

%% this is my new function
move_to_avoid_obstacles(vid, config, motor_l, motor_r, p1togo);

%%
