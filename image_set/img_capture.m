clc; clear all; close all;

% init
vid = videoinput('winvideo',1,'RGB24_640x480');
i = 0;
%%
i = i+1
pic=getsnapshot(vid);
imwrite(pic,sprintf('lum_test%i.png', i))
% imshow(pic)