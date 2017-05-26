function [ output_args ] = CheckRobotHome( LocationRobot ,homes )
%CHECKROBOTHOME Summary of this function goes here
%   Detailed explanation goes here

output_args = 0 ;


for i =1:length(homes)
x = homes(i).BoundingBox(1);
y = homes(i).BoundingBox(2);
width = homes(i).BoundingBox(3);
height = homes(i).BoundingBox(4);
if (LocationRobot.x  > x &&  LocationRobot.x < x + width && LocationRobot.y  > y &&  LocationRobot.y < y + height)
    output_args = 1;
end

end

