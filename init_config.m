function [ config ] = init_config( )
%INIT_CONFG - Init mais config settings

% * Segmentation
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

config.n_homes = 2;                         % Number of homes
config.shape_str = ...
    {'Circle', 'Square', 'Triangle'};
config.size_min_thresh = 1e-3;              % Minimum size objects
config.size_max_thresh = 1e-1;              % Maximum size objects
config.compacity_thresh = 30;               % Compacity threshold, bad shape
config.cmp_arrow_thresh = 57;               % Wanted compacity
config.ecc_arrow_thresh = 0.77;               % Wanted compacity
config.cmp_arrow_max_dist = 10;             % Max distancearoud thresh
config.prop_shape_thresh = 0.5;             % Minimal probaility of shape
% 0.2 - Robot detection
config.black_v_thresh = 0.5;                % Value threshold
config.shape_avoid_rad = 2;                 % Radius center shape avoid
% 0.3 - Shape color detections
config.r_color_detect = 5;                  % Color median radius
config.color_str = ...
    {'Red', 'Yellow', 'Green', 'Brown', 'Blue', 'Pink', 'Grey'};
config.color_hue_thresh = ...
    [0.032, 0.13, 0.39, 0.072, 0.63, 0.94, inf];
config.color_saturation_thresh = 0.25;


% * Robot control
%
% | Fields                  | Value   | Description                                |
% |:----------------------- |:------- |:------------------------------------------ |
% | degreespersec           | scalar  | Estimation of rotation in deg/s            |
% | pixpersec               | scalar  | Estimation of distance in px/s             |
% | max_angle_err           | scalar  | Maximum angle error allowed                |
% | max_dist_err            | scalar  | Maximum distance error allowed             |

config.degreespersec = 90;          % Estimation of rotation in deg/s
config.pixpersec = 100;             % Estimation of distance in px/s 
config.max_angle_err = 2;           % Maximum angle error allowed
config.max_dist_err = 10;           % Maximum distance error allowed

end

