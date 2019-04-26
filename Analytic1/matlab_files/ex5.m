% clear all.
clear all; close all; clc;

% Read input image and convert it to grayscale.
I = imread('photo.png');
I = rgb2gray(I);

% ------------------------ %
%       Question (a)       %
% ------------------------ %

% Set number of isoheight contours.
m = 8;
% Get uniform distributed levels.
v = randi(255 ,m , 1);
% Get m isoheight contours.
A = (I == v(1) | I == v(2) | I == v(3) | I == v(4) | I == v(5) | I == v(6) | I == v(7) | I == v(8));
% Plotting
f = figure;
imshow(A);
saveas(f, '5a.png');


% ------------------------ %
%       Question (b)       %
% ------------------------ %

% Set number of uniform distributed level sets.
m = 8;
% Compute reconstructed image
[f_hat, ~] = levelReconstruction(m, I);
% Plot reconstructed image
f = figure;
imshow(f_hat);
saveas(f, '5b.png');

% ------------------------ %
%       Question (c)       %
% ------------------------ %

% Set different number of levels.
number_of_levels = [4,8,16,32,64,128];
% Initialize peak SNRs
SNRs = zeros(length(number_of_levels), 1);
% For each number of levels compute peak SNR.
for m = 1:length(number_of_levels)
    [~, SNRs(m)] = levelReconstruction(number_of_levels(m), I);
end
% Plot peak SNRs.
f = figure;
plot(number_of_levels , SNRs);
saveas(f, '5c.png');






