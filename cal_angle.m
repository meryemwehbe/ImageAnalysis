function [ angle ] = cal_angle( path )
%CAL_ANGLE Summary of this function goes here
%   Calculates angle from reference vector [0 1 0] - > z coordinate only
%   there for calculation purposes
u = [1 0 0];
v = [ (path(2,1)-path(1,1))  path(2,2)-path(1,2) 0];

angle = atan2d(norm(cross(u,v)),dot(u,v));

if (path(2,2)-path(1,2) < 0)
angle =360 -1*angle; 
end


end

