function [ region_shape, region_robot ] = arena_seg( im_original, config  )
%ARENA_SEG Summary of this function goes here
%   Detailed explanation goes here


region_robot = robot_fit(im_original, config);
region_shape = shape_fit(im_original, config);


% 2. Display results for debug 
if config.diplay_res
    fig = figure();
else
    fig = figure('Visible','off');
end

imshow(im_original); hold on;

for i = 1:length(region_shape)
    % Plot centroid
    plot(region_shape(i).Centroid(1), region_shape(i).Centroid(2), '*g'); hold on;

    % Plot bounding box and homes
    if region_shape(i).Home
        rectangle('Position', region_shape(i).BoundingBox, ...
            'EdgeColor', 'c', 'LineWidth',3)
    else
        rectangle('Position', region_shape(i).BoundingBox, 'EdgeColor', 'r')
    end
    % Region infos
    text(region_shape(i).Centroid(1)+10, region_shape(i).Centroid(2), ...
        sprintf('C: %s\nS: %s', region_shape(i).Color, region_shape(i).Shape), ...
        'FontSize', 14, 'Color','g')
end

if ~isempty(region_robot)
    % Plot robot direction
    vec_point = [region_robot.Centroid(1), region_robot.Centroid(2); ...
             region_robot.Centroid(1) + 50*cos(deg2rad(region_robot.Orientation)), ...
             region_robot.Centroid(2) - 50*sin(deg2rad(region_robot.Orientation))];

    plot(vec_point(:,1), vec_point(:,2), 'r'); hold on;
    plot(vec_point(2,1), vec_point(2,2), 'or'); hold off;
end 

if config.save_res
    saveas(fig, config.save_filename)
end



end

