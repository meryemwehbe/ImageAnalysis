% PLAYING WITH path
img = (imread('WIN_20170511_16_46_11_Pro.jpg' ));
img = sum(img, 3);

bin_img = ones(size(img));
bin_img(img > 350) = 0;

bin_img = logical ( bin_img);

imshow((bin_img));

pos_start = [36;35];
pos_stop = [552;376];

% Testing the function to calculate the path
tic()
path = shortest_path(bin_img, ones(10,10),pos_start, pos_stop);
toc()

hold on;
plot(path(:,2),path(:,1), 'r');