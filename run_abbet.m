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

disp('Init config ...')
config = init_config();
fdist_rob = @(robot, point) norm(robot.Centroid-point);

% ** 1.2 - Init robot communication
disp('Init robot communication ...')
ev3 = legoev3('bt','001653495fad');
motor_r = motor(ev3, 'A');
motor_l = motor(ev3, 'B');

% ** 1.3 - Init video communication
disp('Init camera ...');
vid = videoinput('winvideo',1,'RGB24_640x480');
set(vid, 'FramesPerTrigger', 1);
set(vid, 'TriggerRepeat', Inf);
triggerconfig(vid, 'manual');
start(vid);

% ** 1.4 - Calibration robot
disp('Calibrate robot ...');
config = calibrate(config, vid, motor_l, motor_r);

%% 
clc;
% ** 1.5 - Init arena
disp('Init area and shapes ...')
% pic = im2double(imread(sprintf('img%i.png', 1)));
% pic = im2double(getsnapshot(vid));
trigger(vid); pic = im2double(getdata(vid));
region_robot = robot_fit(pic, config);
[ homes, regular, homeless, ordered_dest, avoid_map ] ...
    = shape_fit(pic, config, region_robot);
r = init_arena_draw( pic, region_robot, homes, regular, homeless);

% ******************** 2 - Controle gobal ********************

% Go to all shapes in deined order
for action_id = 1:size(ordered_dest, 1)
    
    fprintf('Progress game %i/%i\n', action_id, size(ordered_dest, 1))
    % Starts go to object point
    endpt_reached = 0;
    p1togo = ordered_dest(action_id,:);
    while ~endpt_reached
        
        % ** 2.1 Compute shortest path to point next in line
        tic; [path_cgt, map_avoid] = shortest_path( avoid_map, region_robot, p1togo, config );
        wtime = toc; fprintf( '\t Shortest path new in %f\n', wtime );
        
        % Start going to subpoint in path
        temppt_reached = 0;
        temp_p1togo = path_cgt(2, :);
        is_last = (size(path_cgt, 1) == 2);
        panic_break = 0;
        
        while ~temppt_reached 
            
            panic_break = panic_break + 1;
            % ******************** 3 - Controle sub ********************
            
            % ** 3.1 - Get image of situation and fit robot (where to go next) ?
            % pic = im2double(imread(sprintf('img%i.png', i)));
            % pic = im2double(getsnapshot(vid));
            trigger(vid); pic = im2double(getdata(vid));

            region_robot = robot_fit(pic , config );
                   
            % ** 3.2 - Move robot 
            % [ move_success, ang_reach ] = moveRobot( region_robot, config, temp_p1togo , [], []);
            [ move_success, ang_reach ] = moveRobot( region_robot, ...
                config, temp_p1togo , motor_l, motor_r, is_last);
           
            % ** 3.3 - Check if movement is finished ?
            if move_success
                fprintf('\t Reached temp point on path\n')
                temppt_reached = 1;
            else
                fprintf('\t Adjusting, %3.2f deg\n', ang_reach);
            end
            
            % ** 3.4 - Draw situation plot
            data_plot.map_avoid = map_avoid;
            data_plot.ang_reach = ang_reach;
            data_plot.region_robot = region_robot;
            data_plot.path_cgt = path_cgt;
            r = draw_robot(r, pic, data_plot);
            % pause()          
                        
        end
        
        % ** 2.2 If it is last point, double check precision otherwise
        % continue and recalculate shortest path
        if size(path_cgt, 1) == 2
            disp('Check if close enought to final point');
            % Get new image and fit robot
            % pic = im2double(imread(sprintf('img%i.png', i)));
            % pic = im2double(getsnapshot(vid));
            trigger(vid); pic = im2double(getdata(vid));
            
            region_robot = robot_fit(pic , config );
            % Estimate distance
            dist_point_cgt = fdist_rob(region_robot, temp_p1togo);
            if dist_point_cgt < config.max_dist_err
                endpt_reached = 1;
                % Wait and beep for homes of shapes
                if mod(action_id,2)
                    pause(1)
                else
                    pause(3)
                end
                beep(ev3) % Beep to signal reaching point
                disp('Reached beeping ...');
            else
                fprintf('\t Too far %3.3f\n', dist_point_cgt);
            end
            
        end
       
    end
    
end

%%
stop(vid);
clear vid;
    