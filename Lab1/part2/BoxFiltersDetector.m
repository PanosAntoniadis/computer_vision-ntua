function [points] = BoxFiltersDetector (I, sigma, theta)
% BoxFiltersDetector - Interest Point Detector using Box Filters
% 
% Usage:
%         points = BoxFiltersDetector (I, sigma, theta)
% 
% Description:
% Returns a N*3 matrix that corresponds to the
% points detected. The first two collumns are the 
% coordinates and the third is the scale of the
% detection.
% 
% In:
%   I: input image
%   sigma: differential scale
%   theta: a threshold
%
% Out:
%   points: a N*3 matrix containing the detected points.
%

% Define useful lengths for box filters
n = 2 * ceil(3*sigma) + 1
Dxx_height = 4 * floor(n/6) + 1
Dxx_width = 2 * floor(n/6) + 1
Dyy_height = 2 * floor(n/6) + 1;
Dyy_width = 4 * floor(n/6) + 1;
Dxy_height = 2 * floor(n/6) + 1;
Dxy_width = 2 * floor(n/6) + 1;

% Compute integral image.
I_integral = cumsum(cumsum(I, 1),2);

% Compute second order derivatives using box filters and integral image.
Lxx = BoxFilterHelper(I_integral, Dxx_height, 3 * Dxx_width) - 3 * BoxFilterHelper(I_integral, Dxx_height, Dxx_width)
%Lyy = BoxFilterHelper(I_integral, Dyy_height, 3 * Dyy_width) - 3 * BoxFilterHelper(I_integral, Dyy_height, Dyy_width);

%{
Lxy = 
R = Lxx .* Lyy - (0.9*Lxy)^2;
n = 6
height = 4 * floor(n/6) + 1
width = 2 * floor(n/6) + 1
BoxFilterHelperDxy(I, sigma, width)
%}

% Not ready yet!
points = []





