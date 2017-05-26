function [ angle ] = cal_angle( path )
%CAL_ANGLE Summary of this function goes here
%   Calculates angle from reference vector [0 1 0] - > z coordinate only
%   there for calculation purposes
u = [0 1 0];
v = [ (path(1,1)-path(2,1))  path(1,2)-path(2,2) 0];

angle = atan2d(norm(cross(u,v)),dot(u,v));

if (path(1,1)-path(2,1) < 0)
angle = angle * -1;
end

end

