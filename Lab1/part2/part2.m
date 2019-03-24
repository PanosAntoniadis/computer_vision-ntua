% Removing past variables and commands.
clear, clc, close all

% -------------------------------- %
% Part 2: Interest Point Detection %
% -------------------------------- %

% Read input images.
I_balloons = imread('balloons19.png');
I_flowers = imread('sunflowers19.png');

% Set parameters.
sigma = 2;
r = 2.5;
k = 0.05;
theta = 0.005;
s = 1.5;
N = 4;

% ---------------------------------------------------------- %
%       2.1: Edge Detection using HarrisStephens method      %
% ---------------------------------------------------------- %

points_balloons = HarrisStephens(I_balloons, sigma, r, k, theta);
% Visualize detected edges in 'balloons19.png'.
%interest_points_visualization(I_balloons, double(points_balloons));

points_flowers = HarrisStephens(I_flowers, sigma, r, k, theta);
% Visualize detected edges in 'sunflowers19.png'.
interest_points_visualization(I_flowers, double(points_flowers));

% ------------------------------------ %
%    2.2: Multiscale Edge Detection    %
% ------------------------------------ %



% ------------------------------------ %
%       2.3: Blobs Detection           %
% ------------------------------------ %

points_balloons = BlobsDetector(I_balloons, sigma, theta);
% Visualize detected edges in 'balloons19.png'.
interest_points_visualization(I_balloons, double(points_balloons));

points_flowers = BlobsDetector(I_flowers, sigma, theta);
% Visualize detected edges in 'sunflowers19.png'.
interest_points_visualization(I_flowers, double(points_flowers));




% ------------------------------------ %
%   2.4: Multiscale Blobs Detection    %
% ------------------------------------ %






% --------------------------------------------------------- %
%   2.5: Speedup by using Box Filters and Integral Images   %
% --------------------------------------------------------- %















