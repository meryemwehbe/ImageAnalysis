function [ output_args ] = CalculateHome( Shape ,homes )
%CALCULATENEARESTHOME Summary of this function goes here
%   Detailed explanation goes here
output_args = 'none';
 for i = 1:length(homes)
    
    if(strcmp(Shape,homes(i).Shape))
        output_args = homes(i);
    end
 end
 

