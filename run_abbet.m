clear;
clc;
close all;

% **** 0 - Init workspace and config

addpath('image_set/background')
addpath('image_set/motion')
addpath('segmentation')
addpath('drawing')
addpath('robot_controller_func')
addpath('path_A_To_B_obstacles')

config = init_config();

% **** 1 - Init arena
tic;
pic = im2double(imread(sprintf('img%i.png', 1)));
region_robot = robot_fit(pic, config);
[ homes, regular, homeless, ordered_dest, avoid_map ] ...
    = shape_fit(pic, config, region_robot);
r = init_arena_draw( pic, region_robot, homes, regular, homeless);
wtime = toc; display(sprintf( 'Init time %f', wtime ));


i = 0;
% **** 2 - game_logic

% Go to all shapes in deined order
for action_id = 1:size(ordered_dest, 1)
    i = i +1;
    
    % ** 2.1 - Get image of situation and fit robot (where to go next) ?
    % pic=im2double(getsnapshot(vid));
    pic = im2double(imread(sprintf('img%i.png', i)));
    tic; region_robot = robot_fit(pic , config );
    wtime = toc; display(sprintf( 'Robot fit time %f', wtime ));
    
    % ** 2.2 Compute shortest path to point next in line
    p1togo = ordered_dest(action_id,:);
    tic; path_cgt = shortest_path( avoid_map, region_robot, p1togo );
    path_cgt = [path_cgt(:,2), path_cgt(:,1)];
    wtime = toc; display(sprintf( 'Shortest time %f', wtime ));
    
    % ** 2.3 - Move robot to point wanted
    tic;
    % moveRobot( pic, cfg, pos_fin , motor_l, motor_r)
    [ move_success, ang_reach ] = moveRobot( region_robot, config, path_cgt(2, :) , [], []);
    wtime = toc; display(sprintf( 'Robot move calculs %f', wtime ));
    
    % ** 2.4 - Draw situation plot
    data_plot.region_robot = region_robot;
    data_plot.path_cgt = path_cgt;
    data_plot.ang_reach = ang_reach;
    
    r = draw_robot(r, pic, data_plot);
    pause()
end
    