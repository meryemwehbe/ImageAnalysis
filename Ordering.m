function [ output_args ] = Ordering( region )
% 1-Red, 2-Yellow,
% 3-Green, 4-Brown, 5-Blue, 6-Pink and 7-Gray
Ordered_shapes = [];
homes = [];
for i =1:length(region)
    if(region(i).Home == 1)
        homes = [homes;region(i)];

    end

end
%change purple to pink
color_to_detect = {'Red', 'Yellow', 'Green', 'Brown', 'Blue', 'Purple', 'Gray'};
k =1 ;
count = 0;
while( (count ~= length(region) - length(homes)) && k <= length(color_to_detect))
      
      for i =1:length(region)
        if(strcmp(region(i).Color , color_to_detect{k}) && region(i).Home == 0)
            Ordered_shapes = [Ordered_shapes;region(i).Centroid];
            home = CalculateNearestHome(region(i).Centroid, homes);
            Ordered_shapes = [Ordered_shapes; home.Centroid];
            count = count + 1;
        end
      end
      k=k+1;
end


output_args = Ordered_shapes;

