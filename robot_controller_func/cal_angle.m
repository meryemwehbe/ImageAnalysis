function [ angle ] = cal_angle( pos_robot, pos_fin )
%CAL_ANGLE Summary of this function goes here
%   Calculates angle from reference vector [0 1 0] - > z coordinate only
%   there for calculation purposes
u = [1, 0, 0];
v = [ pos_fin(1)-pos_robot(1),  -(pos_fin(2)-pos_robot(2)), 0];

% angle = atan2d(norm(cross(u,v)),dot(u,v));
angle = atan2d(norm(cross(u,v)),dot(u,v));

if (v(2) < 0)
    angle = - angle; 
end


end


