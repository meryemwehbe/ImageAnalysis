function [ p ] = shape_classifier( region )
%SHAPE_CLASSIFIER Summary of this function goes here
%   Detailed explanation goes here


image = region.Image;
area_gt = region.FilledArea;

% 1. Take bounding box fit for first comparison
% Take only contour, no need to feed with internal points
% BW = edge(image,'Sobel');
% Look for coordinates of contour

ids = find(image == 1);
[X,Y] = ind2sub(size(image), ids);

% 1. Fit circle
[~, radius] = minboundcircle(X,Y);
r_circle_est = pi*radius.^2; % Get Area
% 2. Fit triangle
[trix, triy] = minboundtri(X,Y);
r_tri_est = [trix(1:2)-trix(2:3), triy(1:2)-triy(2:3)];
u = [r_tri_est(1,:), 0]; v = [r_tri_est(2,:), 0]; % Extract sides
sin_t = norm(cross(u,v))/(norm(u)*norm(v)); % Extract sin(x)
r_tri_est = 0.5*sin_t*prod(sqrt(sum(abs(r_tri_est).^2,2))); % Get Area
% 3. Fit squre ! Take care of ratio
[rectx, recty, ~, ~] = minboundrect(X, Y, 'a');
r_squ_est = [rectx(1:2)-rectx(2:3), recty(1:2)-recty(2:3)]; % Extract sides
r_squ_edge = sqrt(sum(abs(r_squ_est).^2,2));
r_squ_est = prod(sqrt(sum(abs(r_squ_est).^2,2))) *  max(r_squ_edge)/min(r_squ_edge); % Get Area
% Get Area
% Check if square of deformed
if min(r_squ_edge)/max(r_squ_edge) < 0.7
    r_squ_est = inf;
end
 
% Return ratio with original size
p_bb = area_gt*1./([r_circle_est, r_squ_est, r_tri_est]);
p = p_bb;

end

