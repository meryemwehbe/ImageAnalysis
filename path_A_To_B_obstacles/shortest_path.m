function [ path_real ] = shortest_path( bin_img, region_robot, point_stop )
%shortest_path Calculates the path from A to B avoiding ostacles in the
%binary img

robot_radius = ceil(max(region_robot.BoundingBox(3:4))/2);
point_start = ceil(region_robot.Centroid);
bin_robot_shape = strel('disk',robot_radius,0).Neighborhood;
% size_r = floor(size(bin_robot_shape,1)/4);
% 
% 
% % Replacing the start and stop points as accessible (remove obstacles)
% 
% %%Checking if we're not out of bounds
% start_coeff_y1=max(point_start(2)-size_r,1);
% start_coeff_y2=min(point_start(2)+size_r,size(bin_img, 1));
% start_coeff_x1=max(point_start(1)-size_r,1);
% start_coeff_x2=min(point_start(1)+size_r,size(bin_img, 2));
% 
% stop_coeff_y1=max(point_stop(2)-size_r,1);
% stop_coeff_y2=min(point_stop(2)+size_r,size(bin_img, 1));
% stop_coeff_x1=max(point_stop(1)-size_r,1);
% stop_coeff_x2=min(point_stop(1)+size_r,size(bin_img, 2));

% Replacing the start and stop points as accessible (remove obstacles)
% bin_img(start_coeff_y1:start_coeff_y2,start_coeff_x1:start_coeff_x2) = 0;
% bin_img(stop_coeff_y1:stop_coeff_y2,stop_coeff_x1:stop_coeff_x2) = 0;

%caclulating the scaling factor to perform the alg on the smaller img
scale_factor = size(bin_img,2)/50;

% reshape the image to make the alg faster
bin_img_small = logical(imresize(bin_img, floor(size(bin_img)/scale_factor)));
bin_robot_small = logical(imresize(bin_robot_shape, floor(size(bin_robot_shape)/scale_factor/2))); %dilute the image with the img 2ce smallr than the robot !!!


%calculate dilution with the robot size
im_obst_with_robot = imdilate(bin_img_small, bin_robot_small);

point_start_fl = floor(point_start/scale_factor);
point_stop_fl = floor(point_stop/scale_factor);

try
    [r,c] = shpath(im_obst_with_robot, point_start_fl(2),point_start_fl(1),point_stop_fl(2), point_stop_fl(1));
    path = [r,c]*scale_factor;

    Nb_path_points = (size(path,1));
    angle_diff = zeros(1,ceil(Nb_path_points));
    angle_last = 0;
    
%     ids_start = find( sqrt(sum((ones(length(path),1)*point_start ... 
%         - [path(:, 2), path(:,1)]).^2, 2)) > config.max_dist_err);
%     if isempty(ids_start)
%         ids_start = 1;
%     else
%         ids_start = ids_start(1);
%     end
    % calculating the angle difference after each point
    for i = ids_start:(size(path,1))-1
        p1 = [path(i,2); path(i,1)];
        p2 = [path((i+1),2); path((i+1),1)];
        diff = p1-p2;
        angle = rad2deg(atan(diff(2)/diff(1)));
        angle_diff(i) = abs(angle - angle_last);
        angle_last = angle;
    end

    % filtering the result
    Nb_filt_points = ceil(Nb_path_points/7)+1;
    step_gauss = 6/Nb_filt_points;
    mean=0;
    sigma=1;
    x = -3 : step_gauss : 3;
    % generating gaussian filter
    h=1/sqrt(2*pi)/sigma*exp(-(x-mean).^2/2/sigma/sigma);

    % finding peak angle change locations
    angle_diff_filtered = filter(h,1,angle_diff);
    [ peaks locs ] = findpeaks(angle_diff_filtered, 1:size(angle_diff_filtered), 'MinPeakHeight', 3.0);

    location_real = locs(2:end) -floor(Nb_filt_points/2);
    path_real = ceil(path(location_real,:));
catch
    path_real = [];
end


path_real = [[point_start(2), point_start(1)]; path_real; [point_stop(2), point_stop(1)]];
end
