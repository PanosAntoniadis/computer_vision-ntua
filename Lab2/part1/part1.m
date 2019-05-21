% Removing past variables and commands.
clear, clc, close all

% Read input image
I = imread('1.png');

% -------------------------------- %
%   1.1: Facial Skin Detection     %
% -------------------------------- %

% Load skin samples from skinSamplesRGB.mat
load("skinSamplesRGB.mat");

% Get mean value and covariance from the skin samples.
[mean_CbCr, cov_CbCr] = trainPdf(skinSamplesRGB);

% Compute bounding box.
boundingBox = findFace(I, mean_CbCr, cov_CbCr);

figure;
imshow(I);
hold on;
rectangle('Position',boundingBox, 'EdgeColor', 'g');



% -------------------------------- %
%   1.2: Lucas-Kanade algorithm    %
% -------------------------------- %










