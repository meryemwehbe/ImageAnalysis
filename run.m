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

% 0.1 - Shape discard non matching shapes
config.shape_str = ...
    {'Circle', 'Square', 'Triangle'};
config.size_min_thresh = 1e-3;              % Minimum size objects
config.size_max_thresh = 1e-1;              % Maximum size objects
config.compacity_thresh = 50;               % Compacity threshold, bad shape
config.prop_shape_thresh = 0.75;            % Minimal probaility of shape
% 0.2 - Robot detection
config.black_v_thresh = 0.4;                % Value threshold
% 0.3 - Shape color detections
config.r_color_detect = 5;                  % Color median radius
config.color_str = ...
    {'Red', 'Yellow', 'Green', 'Brown', 'Blue', 'Pink', 'Grey'};
config.color_hue_thresh = ...
    [0.032, 0.13, 0.39, 0.072, 0.63, 0.94, inf];
config.color_saturation_thresh = 0.25;
% 0.4 -Display options
config.diplay_res = 1;                      % Dispaly image with detected obj
config.save_res = 1;                        % Save results
config.save_filename = 'res/display.png';        % Save filename



% back = im2double(imread('debug.jpg'));
back = im2double(imread('img1.png'));
% back = im2double(imread('WIN_20170511_16_47_29_Pro.jpg'));
% back = im2double(imread('WIN_20170511_16_46_46_Pro.jpg'));

arena_seg(back, config);

%% Test all

listing = dir('image_set');

for i = 3:length(listing)
    display(sprintf('%i/%i', i, length(listing)))
    config.save_filename = sprintf('res/detection_%s.png', listing(i).name);        
    back = im2double(imread(listing(i).name));
    arena_seg(back, config);  
end

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
    