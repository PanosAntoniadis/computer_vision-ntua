% Removing past variables and commands.
clear, clc, close all

% ---------------------------------- %
%  2.1: Time-Space interest points   %
% ---------------------------------- %

% Read input video
L = readVideo( 'test.avi', 200, 0);



% Define parameters for Harris
sigma = 2;
t = 0.7;
k = 0.05;
N = 4;
s = 1.5;
theta = 0.005;

%points = HarrisDetector(L, sigma, t, k, theta);
%points = MultiscaleHarrisDetector(L, sigma, t, s, N, k, theta);

% Define parameters for Gabor
sigma = 1;
t = 1.5;
N = 4;
s = 1.5;
theta = 0.5;

%points = GaborDetector(L, sigma, t, theta);
points = MultiscaleGaborDetector(L, sigma, t, s, N, theta);
showDetection(L, points);
