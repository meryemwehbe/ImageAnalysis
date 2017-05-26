clear;
clc;
close all;

addpath('image_set/background')
addpath('image_set/motion')
addpath('shapes')
addpath('MinBoundSuite')

% Will segement original image and look for shapes and robot. Config array can be parametrized if needed
% * config
%
% | Fields                  | Value         | Description                                                           |
% |:----------------------- |:------------- |:--------------------------------------------------------------------- |
% | n_homes                 | scalar        | Number of homes to look for                                           |
% | shape_str               | Strings cell  | Name of the shapes                                                    |
% | size_min_thresh         | scalar        | Smaller shape to detect (ratio according to full image)               |
% | size_max_thresh         | scalar        | Bigger shape to detect (ratio according to full image)                |
% | compacity_thresh        | scalar        | Maximum compacity value before descarding detection                   |
% | prop_shape_thresh       | scalar        | Minimal probability before discarding detection                       |
% | black_v_thresh          | scalar        | Threshold value for detection of black arrow                          |
% | r_color_detect          | scalar        | Radius to consider around centroid when looking for color of shape    |
% | color_str               | Strings cell  | Name of colors                                                        |
% | color_hue_thresh        | scalar        | Values of exprected Hue colors, i.e. mean value (see HSV color space) |
% | color_saturation_thresh | scalar        | Maximal saturation value for grey zone                                |
% | diplay_res              | logical       | Selection displaying results (1) or not (0)                           |
% | save_res                | logical       | Selection saving results (1) or not (0)                               |
% | save_filename           | String        | Name of the saved file                                                |
% 
% 
% * region_shape
%
% | Fields       | Value         | Description                                                  |
% |:------------ |:------------- |:------------------------------------------------------------ |
% | Centroid     | [x,y]         | Centroid of the shape                                        |
% | BoundingBox  | [x, y, w, h]  | Bounding box expressed as (x,y) corner and w=width, h=heigth |
% | Home         | logical       | Assert if home (1) or not (0)                                |
% | Color        | String        | String value of the detected color                           |
% | Shape        | String        | String value of the detected shape                           |
% 
%
% * region_robot
%
% | Fields      | Value      | Description                         |
% |:----------- |:---------- |:----------------------------------- |
% | Centroid    | [x,y]      | Centroid of the arrow head          |
% | Orientation | scalar     | Angle in degree according to x-axis |


% 0.1 - Shape discard non matching shapes
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

%
back = im2double(imread('bg1.png'));
[ region_shape, region_robot ] = arena_seg(back, config);

%% Test all

listing = dir('image_set/background');
config.diplay_res = 0;

for i = 3:length(listing)
    config.save_filename = sprintf('res/detection_%s', listing(i).name); 
    display(sprintf('%i/%i, %s', i, length(listing), listing(i).name))
    back = im2double(imread(listing(i).name));
    [region_shape, region_robot ] = arena_seg(back, config); 
%     if ~isempty(region_robot)
%         region_robot(1).Prob
%     end
end


%% Color region

listing = dir('image_set/background');

figure();
for i = 3:length(listing)
    display(sprintf('%i/%i, %s', i, length(listing), listing(i).name))
    back = im2double(imread(listing(i).name));
    region = shape_fit(back, config);
    for j = 1:length(region)
       plot(region(j).ColorHSV(1), region(j).ColorHSV(2), 'o', ...
           'MarkerSize', 5 + 5*region(j).ColorHSV(3), ...
           'MarkerEdgeColor', hsv2rgb(region(j).ColorHSV), ...
           'MarkerFaceColor', hsv2rgb(region(j).ColorHSV)); hold on;
    end
end

grid on; xlabel('Hue'); ylabel('Saturation')

% homes = Ordering(region);
    