clear;
clc;
close all;

addpath('image_set')
addpath('shapes')
addpath('MinBoundSuite')

% Setting of detection
config.n_homes = 2;                         % Number of homes
config.bck_s_thresh = 0.2;                  % Threshold for background Saturation
config.bck_v_thresh = 0.5;                  % Threshold for background Value
config.hsv_h_thresh = 0.3;                  % Grey if Hue < thresh value
config.size_min_thresh = 1e-3;              % Minimum size objects
config.size_max_thresh = 1e-1;              % Maximum size objects
config.compacity_thresh = 30;               % Compacity threshold, bad shape
config.r_color_detect = 5;                  % Color median radius
config.color_ref = imread('palette.png');   % Source image color
config.diplay_res = 1;                      % Dispaly image with detected obj

%back = im2double(imread('debug.jpg'));
back = im2double(imread('img1.png'));
% back = im2double(imread('WIN_20170511_16_46_25_Pro.jpg'));
% back = im2double(imread('WIN_20170511_16_46_46_Pro.jpg'));

region = shape_fit(back, config);

%% Color region

listing = dir('image_set');

figure();
for i = 3:length(listing)
    
    back = im2double(imread(listing(i).name));
    region = shape_fit(back, config);
    for j = 1:length(region)
       plot(region(j).ColorHSV(1), region(j).ColorHSV(2), 'o', ...
           'MarkerSize', 5 + 5*region(j).ColorHSV(3), ...
           'MarkerEdgeColor', region(j).ColorRGB, ...
           'MarkerFaceColor', region(j).ColorRGB); hold on;
    end
end

grid on; xlabel('Hue'); ylabel('Saturation')

% homes = Ordering(region);
    