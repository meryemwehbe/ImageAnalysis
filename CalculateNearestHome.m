function [ output_args ] = CalculateNearestHome( Centroid ,homes )
%CALCULATENEARESTHOME Summary of this function goes here
%   Detailed explanation goes here
min_distance = Inf;
home_number = 0;
 for i = 1:length(homes)
    distance = pdist2( Centroid ,homes(i).Centroid);
    if(distance < min_distance)
        home_number = i;
        min_distance = distance;
    end
 end
 
 output_args = homes(home_number);

