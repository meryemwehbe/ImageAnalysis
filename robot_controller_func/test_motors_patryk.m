clc; clear all; close all;

%%
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
config.prop_shape_thresh = 0.8;             % Minimal probaility of shape
% 0.2 - Robot detection
config.black_v_thresh = 0.6;                % Value threshold
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

%% go with the robot to sample point [400, 300] 
moveRobot( vid, config, [400, 300] , motor_l, motor_r);

%TODO test the fiunction with different robot and endpoint positions !!!
% just test if its going always there !! 

