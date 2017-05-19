function [ region ] = shape_fit( im_original, config )
%SHAPE_FIT Summary of this function goes here
%   Detailed explanation goes here

% Main variables
size_image = size(im_original, 1)*size(im_original, 2);
COLOR_LABEL = {'Red', 'Yellow', 'Green', 'Brown', 'Blue', ...
    'Purple', 'Grey'};
SHAPE_LABEL = {'Circle', 'Square', 'Triangle'};

% 1. Split forground / background
im_hsv = rgb2hsv(im_original);
% Get ride of 'white' component, i.e. table
% Carefull, stauration migth remove grey level used in detection, therefore 
% restore grey levels with v component 
detections = im_hsv(:,:,2) > config.bck_s_thresh ...
    | im_hsv(:,:,3) < config.bck_v_thresh;

% 1.1 Smooth the shapes to get better shape compacity apprximations
detections = bwmorph(detections, 'open', 5);

% 2. Remove fake results (robot, table, small shapes, ... etc)
region = regionprops(detections, 'BoundingBox', 'Area', 'Perimeter', ...
    'Centroid', 'Image');
homes_sz = [];

for i = length(region):-1:1
    % Check if area and ratio in correct range
    if region(i).Area/size_image < config.size_min_thresh ...
            || region(i).Area/size_image > config.size_max_thresh
        region(i) = [];
        continue
    end
    % Check compacity limit
    if region(i).Perimeter^2/region(i).Area > config.compacity_thresh
        region(i) = [];
        continue
    end
    region(i).ShapeProb = shape_classifier(region(i));
    region(i).Home = 0;
    homes_sz = [region(i).Area, homes_sz];
end

% 3. Set homes regions (based on top K sizes)
[~, I] = sort(homes_sz);
for i = I(end-(config.n_homes-1):end)
    region(i).Home = 1;
end

% 4. Detection of colors (HSV)
N_color = length(COLOR_LABEL)-1; % Get number of color in palette
N_region = config.r_color_detect; % Fix radius to look around to get color
im_pal = config.color_ref; % Get image of palette
ids = (1:2:2*(N_color+1))*size(im_pal,1)/(2*(N_color+1)); % Get color on palette
colors = rgb2hsv(double(reshape(im_pal(ids, 75, :), N_color+1, 3))/256); % Convert to HSV
colors = colors(1:end-1, :);

% Look for color of every region
for i = 1:length(region)
    % Get color matrix (not only central point)
    sub_color = im_original(floor(region(i).Centroid(2))+(-N_region:1:N_region), ...
        floor(region(i).Centroid(1))+(-N_region:1:N_region), :);
    % Get median approximation of color of shape
    sub_color = median(reshape(sub_color, [], 3), 1);
    % Convert RGB value to HSV
    region(i).ColorRGB = sub_color;
    region(i).ColorHSV = rgb2hsv(sub_color);
    sub_color = ones(N_color, 1)*rgb2hsv(sub_color);
    % Check if black value
    if sub_color(1,2) < config.hsv_h_thresh % Saturation too low -> gray scale
        region(i).Color = COLOR_LABEL{end};
    else
        % Get minimal distance (only Hue and Saturation)
        [~, I] = min(sqrt(sum(abs(colors(:,1:2) - sub_color(:,1:2)).^2, 2)));
        region(i).Color = COLOR_LABEL{I};
    end
end

% 5. Detection of shape (based on compacity)
for i = 1:length(region)
    [~, id_shape] = max(region(i).ShapeProb);
    region(i).Shape = SHAPE_LABEL{id_shape};
end

% 6. Display results for debug 
if config.diplay_res
    figure()
    imshow(im_original); hold on;
    for i = 1:length(region)
        % Plot centroid
        plot(region(i).Centroid(1), region(i).Centroid(2), '*g'); hold on;

        % Plot bounding box and homes
        if region(i).Home
            rectangle('Position', region(i).BoundingBox, ...
                'EdgeColor', 'c', 'LineWidth',3)
        else
            rectangle('Position', region(i).BoundingBox, 'EdgeColor', 'r')
        end
        % Region infos
        text(region(i).Centroid(1)+10, region(i).Centroid(2), ...
            sprintf('C: %s\nS: %s', region(i).Color, region(i).Shape), ...
            'FontSize', 14, 'Color','g')
    end

end

region = rmfield(region, {'Perimeter', 'Area', 'Image'});


end

