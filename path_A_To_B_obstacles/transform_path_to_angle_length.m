function [ angles, lengths ] = transform_path_to_angle_length( path )
%UNTITLED3 Transforms the N array of X-Y path points to N-1 arrays of
%length in pixels and directions in angle
%   Detailed explanation goes here
angles = zeros(1,size(path,1)-1);
lengths = zeros(1,size(path,1)-1);

for i = 1:(size(path,1))-1
    p1 = [path(i,2); path(i,1)];
    p2 = [path((i+1),2); path((i+1),1)];
    diff = p1-p2;
    lengths(i) = ceil(sqrt(sum(diff.^2)));
    angles(i) = rad2deg(atan(diff(2)/diff(1)));
end

end

