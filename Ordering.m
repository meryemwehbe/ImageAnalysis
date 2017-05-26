function [homes, regular, homeless, ordered_dest] = Ordering( region, config )
% 1-Red, 2-Yellow, 3-Green, 4-Brown, 5-Blue, 6-Pink and 7-Gray
ordered_dest = [];
regular = [];
homeless = [];
homes = [];

for i =1:length(region)
    if(region(i).Home == 1)
        homes = [homes; region(i)];
    end
end

%change purple to pink
color_to_detect = config.color_str;

k =1 ;
count = 0;
while( (count ~= length(region) - length(homes)) && k <= length(color_to_detect))
      
      for i =1:length(region)
        if(strcmp(region(i).Color , color_to_detect{k}) && region(i).Home == 0)
            % Look if shape have a home or not
            home = CalculateHome(region(i).Shape, homes);
            if(~strcmp(home,'none'))    
                ordered_dest = [ordered_dest;region(i).Centroid];
                ordered_dest = [ordered_dest; home.Centroid];
                regular = [regular; region(i)];
            else
                homeless = [homeless; region(i)];
            end           
            count = count + 1;
        end
      end
      k=k+1;
end


end

