function [ st_arena ] = init_arena_draw( im_original, region_robot, ...
    homes, regular, homeless, avoid_map )
%INIT_ARENA_DRAW Summary of this function goes here
%   Detailed explanation goes here

st_arena.f = [];
st_arena.background = [];
st_arena.rob_vec = [];
st_arena.rob_dir = [];
st_arena.rob_vec_cgt = [];
st_arena.rob_dir_cgt = [];
st_arena.path_cgt = [];
st_arena.path_cgt_avoid = [];

st_arena.f = figure('Name', 'Arena');

% Draw colored image
subplot(1,2,1)
st_arena.background = imshow(im_original); hold on;

% Draw obstacle path
subplot(1,2,2)
st_arena.map_avoid = imshow(avoid_map); hold on;

%% Draw homeless shapes
for i = 1:length(homeless)
    for j = 1:2
        subplot(1,2,j)
        % Plot centroid
        plot(homeless(i).Centroid(1), homeless(i).Centroid(2), '*g'); hold on;

        % Plot bounding box and homes
        rectangle('Position', homeless(i).BoundingBox, 'EdgeColor', 'r')
    end
end

%% Draw homes
for i = 1:length(homes)
    for j = 1:2
        subplot(1,2,j)
        % Plot centroid
        plot(homes(i).Centroid(1), homes(i).Centroid(2), '*g'); hold on;

        % Plot bounding box and homes
        rectangle('Position', homes(i).BoundingBox, ...
            'EdgeColor', 'c', 'LineWidth',3)
        % Region infos
        if j == 1
            text(homes(i).Centroid(1)+10, homes(i).Centroid(2), ...
            sprintf('%s', homes(i).Shape(1)), ...
            'FontSize', 14, 'Color','k')
        end
        
    end
end

%% Draw shapes to find
for i = 1:length(regular)
    
    for j = 1:2
        subplot(1,2,j)
        % Plot centroid
        plot(regular(i).Centroid(1), regular(i).Centroid(2), '*g'); hold on;

        % Plot bounding box and homes
        rectangle('Position', regular(i).BoundingBox, 'EdgeColor', 'g')
        % Region infos
        if j == 1
            text(regular(i).Centroid(1)+10, regular(i).Centroid(2), ...
            sprintf('%s/%s', regular(i).Shape(1), regular(i).Color), ...
            'FontSize', 14, 'Color','k')
        end

    end

end

%% Draw robot position
data_plot.region_robot = region_robot;
st_arena = draw_robot(st_arena, im_original, data_plot);


end

