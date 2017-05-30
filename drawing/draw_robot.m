function [st_arena] = draw_robot( st_arena, back, data_plot) 
%DRAW_ROBOT Summary of this function goes here
%   Detailed explanation goes here

figure(st_arena.f);

% Supress old center
if ~isempty(st_arena.background)
    st_arena.background.CData = back;
end


if isfield(data_plot, 'region_robot') && ~isempty(data_plot.region_robot)
    % Plot robot direction
    region_robot = data_plot.region_robot;
    vec_point = [region_robot.Centroid(1), region_robot.Centroid(2); ...
             region_robot.Centroid(1) + 50*cos(deg2rad(region_robot.Orientation)), ...
             region_robot.Centroid(2) - 50*sin(deg2rad(region_robot.Orientation))];

    % Supress old center
    if ~isempty(st_arena.rob_dir)
        delete(st_arena.rob_dir);
    end
    % Supress old direction
    if ~isempty(st_arena.rob_vec)
        delete(st_arena.rob_vec);
    end
    
    st_arena.rob_dir = plot(vec_point(2,1), vec_point(2,2), 'or'); hold on;
    st_arena.rob_vec = plot(vec_point(:,1), vec_point(:,2), 'r'); hold on;
    
    if isfield(data_plot, 'ang_reach') && ~isempty(data_plot.ang_reach)
        % Supress old center
        if ~isempty(st_arena.rob_dir_cgt)
            delete(st_arena.rob_dir_cgt);
        end
        % Supress old direction
        if ~isempty(st_arena.rob_vec_cgt)
            delete(st_arena.rob_vec_cgt);
        end
        ang_reach = data_plot.ang_reach;
        vec_point = [region_robot.Centroid(1), region_robot.Centroid(2); ...
             region_robot.Centroid(1) + 50*cos(deg2rad(ang_reach)), ...
             region_robot.Centroid(2) - 50*sin(deg2rad(ang_reach))];
        st_arena.rob_dir_cgt = plot(vec_point(2,1), vec_point(2,2), 'og'); hold on;
        st_arena.rob_vec_cgt = plot(vec_point(:,1), vec_point(:,2), 'g'); hold on;
    end
end 

if isfield(data_plot, 'path_cgt') && ~isempty(data_plot.path_cgt)
    path_cgt = data_plot.path_cgt;
    if ~isempty(st_arena.path_cgt)
        delete(st_arena.path_cgt);
    end
    st_arena.path_cgt = plot(path_cgt(:,1), path_cgt(:,2), '--*r', 'LineWidth', 2); hold on;
end

end

