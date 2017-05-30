function draw_arena(  im_original, region_robot, homes, regular, ...
    homeless, config )
%DRAW_ARENA Summary of this function goes here
%   Detailed explanation goes here

% Check if output needed
if ~config.diplay_res && ~config.save_res
   return 
end

% Display results ?
if config.diplay_res
    fig = figure();
else
    fig = figure('Visible','off');
end

imshow(im_original); hold on;

for i = 1:length(homeless)
    % Plot centroid
    plot(homeless(i).Centroid(1), homeless(i).Centroid(2), '*g'); hold on;

    % Plot bounding box and homes
    rectangle('Position', homeless(i).BoundingBox, 'EdgeColor', 'r')
end

for i = 1:length(homes)
    % Plot centroid
    plot(homes(i).Centroid(1), homes(i).Centroid(2), '*g'); hold on;

    % Plot bounding box and homes
    rectangle('Position', homes(i).BoundingBox, ...
        'EdgeColor', 'c', 'LineWidth',3)
    % Region infos
    text(homes(i).Centroid(1)+10, homes(i).Centroid(2), ...
        sprintf('%s', homes(i).Shape(1)), ...
        'FontSize', 14, 'Color','k')
end

for i = 1:length(regular)
    % Plot centroid
    plot(regular(i).Centroid(1), regular(i).Centroid(2), '*g'); hold on;

    % Plot bounding box and homes
    rectangle('Position', regular(i).BoundingBox, 'EdgeColor', 'g')
    % Region infos
    text(regular(i).Centroid(1)+10, regular(i).Centroid(2), ...
        sprintf('%s/%s', regular(i).Shape(1), regular(i).Color), ...
        'FontSize', 14, 'Color','k')
end

if ~isempty(region_robot)
    % Plot robot direction
    vec_point = [region_robot.Centroid(1), region_robot.Centroid(2); ...
             region_robot.Centroid(1) + 50*cos(deg2rad(region_robot.Orientation)), ...
             region_robot.Centroid(2) - 50*sin(deg2rad(region_robot.Orientation))];

    plot(vec_point(:,1), vec_point(:,2), 'r'); hold on;
    plot(vec_point(2,1), vec_point(2,2), 'or'); hold off;
end 

% Save results ?
if config.save_res
    saveas(fig, config.save_filename)
end


end

