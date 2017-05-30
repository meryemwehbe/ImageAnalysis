function [  ] = move_to_avoid_obstacles( vid, config, motor_l, motor_r, p1togo)
%move_to_avoid_obstacles This function goes to the point with obstacle avoidance
%(probably with multiple stops - intermediate points)

% use Christians function to generate binary image with  obstacles
pic=getsnapshot(vid);
[ homes, regular, homeless, ordered_dest, avoid_map ] = shape_fit( im2double(pic), config );
imshow(pic);
figure()

% we get out of the loop when the robot is within the final point area
while(1)
    % get the position of the robot
    pic=getsnapshot(vid);
    region_rob = robot_fit( im2double(pic), config );
    pos_robot = ceil(region_rob.Centroid);
    
    % if position of the robot is in the final point, return
    if(norm(pos_robot - p1togo) < config.point_point_accuracy)
       return; 
    end
    
    % get the shortest path
    [ path ] = shortest_path( avoid_map, config.robot_radius,pos_robot, p1togo )
    
    %plot the shortest path on the figure
    imshow(avoid_map)
    hold on;
    plot(path(:,2),path(:,1), '--*r', 'Linewidth', 3);
    hold off;
    
    % make the next step to the point of the path
    moveRobot( vid, config, [path(2,2) path(2,1)] , motor_l, motor_r);
end

end

