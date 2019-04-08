% Removing past variables and commands.
clear, clc, close all

% -------------------------------- %
% Part 2: Interest Point Detection %
% -------------------------------- %

% Read input images.
I_balloons = imread('photos/balloons19.png');
I_flowers = imread('photos/sunflowers19.png');

% Convert input images to double precision grayscale.
I_balloons = im2double(rgb2gray(I_balloons));

% Set initial parameters.
sigma = 2;
r = 2.5;
k = 0.05;
theta = 0.005;
s = 1.5;
N = 4;

% ---------------------------------------------------------- %
%       2.1: Edge Detection using HarrisStephens method      %
% ---------------------------------------------------------- %

f = figure;
points_balloons = HarrisStephens(I_balloons, sigma, r, k, theta);
% Visualize detected edges in 'balloons19.png'.
interest_points_visualization(I_balloons, double(points_balloons));
% Save figure in png format.
saveas(f,'photos/balloons_2_1.png')

f = figure;
points_flowers = HarrisStephens(I_flowers, sigma, r, k, theta);
% Visualize detected edges in 'sunflowers19.png'.
interest_points_visualization(I_flowers, double(points_flowers));
% Save figure in png format.
saveas(f,'photos/flowers_2_1.png')

% ------------------------------------ %
%    2.2: Multiscale Edge Detection    %
% ------------------------------------ %

f = figure;
points_balloons = HarrisLaplacian(I_balloons, sigma, r, s, N, k, theta);
% Visualize detected edges in 'balloons19.png'.
interest_points_visualization(I_balloons, double(points_balloons));
% Save figure in png format.
saveas(f,'photos/balloons_2_2.png')

f = figure;
points_flowers = HarrisLaplacian(I_flowers, sigma, r, s, N, k, theta);
% Visualize detected edges in 'sunflowers19.png'.
interest_points_visualization(I_flowers, double(points_flowers));
% Save figure in png format.
saveas(f,'photos/flowers_2_2.png')




% ------------------------------------ %
%       2.3: Blobs Detection           %
% ------------------------------------ %

f = figure;
points_balloons = BlobsDetector(I_balloons, sigma, theta);
% Visualize detected edges in 'balloons19.png'.
interest_points_visualization(I_balloons, double(points_balloons));
saveas(f,'photos/balloons_2_3.png')

f = figure;
points_flowers = BlobsDetector(I_flowers, sigma, theta);
% Visualize detected edges in 'sunflowers19.png'.
interest_points_visualization(I_flowers, double(points_flowers));
saveas(f,'photos/flowers_2_3.png')

% ------------------------------------ %
%   2.4: Multiscale Blobs Detection    %
% ------------------------------------ %

f = figure;
points_balloons = HessianLaplacian(I_balloons, sigma, s, N, theta);
% Visualize detected edges in 'balloons19.png'.
interest_points_visualization(I_balloons, double(points_balloons));
saveas(f,'photos/flowers_2_4.png')

f = figure;
points_flowers = HessianLaplacian(I_balloons, sigma, s, N, theta);
% Visualize detected edges in 'sunflowers19.png'.
interest_points_visualization(I_flowers, double(points_flowers));
saveas(f,'photos/balloons_2_4.png')


% --------------------------------------------------------- %
%   2.5: Speedup by using Box Filters and Integral Images   %
% --------------------------------------------------------- %

% Not ready yet! Only functions for Dxx, Dyy are ready.

%{
points_balloons = BoxFiltersDetector(I_balloons, sigma, theta);
% Visualize detected edges in 'balloons19.png'.
interest_points_visualization(I_balloons, double(points_balloons));

points_flowers = BoxFiltersDetector(I_flowers, sigma, theta)
% Visualize detected edges in 'sunflowers19.png'.
interest_points_visualization(I_flowers, double(points_flowers));
%}







