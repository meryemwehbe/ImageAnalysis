clear;
clc;
close all;


% ******************** 1 - Init ********************
% ** 1.1 - Init workspace and config

addpath('image_set/background')
addpath('image_set/motion')
addpath('segmentation')
addpath('drawing')
addpath('robot_controller_func')
addpath('path_A_To_B_obstacles')

display('Init config ...')
config = init_config();
fdist_rob = @(robot, point) norm(robot.Centroid-point);

% ** 1.2 - Init arena
display('Init area and shapes ...')
pic = im2double(imread(sprintf('img%i.png', 1)));
region_robot = robot_fit(pic, config);
[ homes, regular, homeless, ordered_dest, avoid_map ] ...
    = shape_fit(pic, config, region_robot);
r = init_arena_draw( pic, region_robot, homes, regular, homeless);

% ** 1.3 - Init robot communication
display('Init robot communication ...')
ev3 = legoev3('bt','001653495fad');
motor_r = motor(ev3, 'A');
motor_l = motor(ev3, 'B');

% ** 1.4 - Init video communication
display('Init camera ...')
vid = videoinput('winvideo',1,'RGB24_640x480');


% ******************** 2 - Controle gobal ********************

% Go to all shapes in deined order
for action_id = 1:size(ordered_dest, 1)
    
    display(sprintf('Progress game %i/%i', action_id, size(ordered_dest, 1)))
    % Starts go to object point
    endpt_reached = 0;
    p1togo = ordered_dest(action_id,:);
    while ~endpt_reached
        
        % ** 2.1 Compute shortest path to point next in line
        tic; path_cgt = shortest_path( avoid_map, region_robot, p1togo );
        path_cgt = [path_cgt(:,2), path_cgt(:,1)];
        display(sprintf( '\t Shortest path new in %f', wtime ));
        
        % Start going to subpoint in path
        temppt_reached = 0;
        temp_p1togo = path_cgt(2, :);
        
        while ~temppt_reached
            
            
            % ******************** 3 - Controle sub ********************
            
            % ** 3.1 - Get image of situation and fit robot (where to go next) ?
            % pic = im2double(imread(sprintf('img%i.png', i)));
            pic = im2double(getsnapshot(vid));
            region_robot = robot_fit(pic , config );
                   
            % ** 3.2 - Move robot 
            % [ move_success, ang_reach ] = moveRobot( region_robot, config, temp_p1togo , [], []);
            [ move_success, ang_reach ] = moveRobot( region_robot, ...
                config, temp_p1togo , motor_l, motor_r);
           
            % ** 3.3 - Check if movement is finished ?
            if move_success
                display('\t Reached temp point on path')
                temppt_reached = 1;
            else
                display(sprintf('\t Adjusting, %3.2f deg', ang_reach));
            end
            
            % ** 3.4 - Draw situation plot
            data_plot.ang_reach = ang_reach;
            data_plot.region_robot = region_robot;
            data_plot.path_cgt = path_cgt;
            r = draw_robot(r, pic, data_plot);
            pause()          
                        
        end
        
        % ** 2.2 If it is last point, double check precision otherwise
        % continue and recalculate shortest path
        if size(path_cgt, 1) == 2
            display('Check if close enought to final point');
            % Get new image and fit robot
            % pic = im2double(imread(sprintf('img%i.png', i)));
            pic = im2double(getsnapshot(vid));
            region_robot = robot_fit(pic , config );
            % Estimate distance
            dist_point_cgt = fdist_rob(region_robot, temp_p1togo);
            if dist_point_cgt < config.max_dist_err
                endpt_reached = 1;
                beep(ev3) % Beep to signal reaching point
                display('Reached beeping ...');
            else
                display(sprintf('\t Too far %3.3f', dist_point_cgt));
            end
            
        end
       
    end
    
end
    