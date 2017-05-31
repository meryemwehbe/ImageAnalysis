clear;
clc;
close all;


% ******************** 1 - Init ********************
% ** 1.1 - Init workspace and config
addpath('..')
addpath('../image_set/background')
addpath('../image_set/motion')
addpath('../segmentation')
addpath('../drawing')
addpath('../robot_controller_func')
addpath('../path_A_To_B_obstacles')

config = init_config();

pic = im2double(imread(sprintf('img%i.png', 1)));
region_robot = robot_fit(pic, config);
[ homes, regular, homeless, ordered_dest, avoid_map ] ...
    = shape_fit(pic, config, region_robot);
r = init_arena_draw( pic, region_robot, homes, regular, homeless, avoid_map);


p1togo = [280, 66];
% p1togo = [473, 425];
region_robot.Centroid = [393, 165];

% ** 2.1 Compute shortest path to point next in line
tic; [path_cgt, map_avoid] = shortest_path( avoid_map, region_robot, p1togo, config );
wtime = toc; fprintf( '\t Shortest path new in %3.2f\n', wtime );

% ** 3.4 - Draw situation plot
data_plot.region_robot = region_robot;
data_plot.path_cgt = path_cgt;
data_plot.map_avoid = map_avoid;
r = draw_robot(r, pic, data_plot);
% pause()    

