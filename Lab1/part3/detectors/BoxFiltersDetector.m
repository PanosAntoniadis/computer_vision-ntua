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
n = 2 * ceil(3*sigma) + 1;
Dxx_height = 4 * floor(n/6) + 1;
Dxx_width = 2 * floor(n/6) + 1;
Dyy_height = 2 * floor(n/6) + 1;
Dyy_width = 4 * floor(n/6) + 1;
Dxy_height = 2 * floor(n/6) + 1;
Dxy_width = 2 * floor(n/6) + 1;

% Compute integral image.
I_integral = cumsum(cumsum(I, 1),2);

% -------------------------- %
%      Computation of Lxx    %
% -------------------------- %
% Compute useful distances (half of height and width).
Dxx_x = (Dxx_width + 1)/2 - 1;
Dxx_y = (Dxx_height + 1)/2 - 1;
% Compute convolution with unit filter.
Lxx = BoxFilterHelper(I_integral, Dxx_height, Dxx_width);
% Necessary padding to avoid conflicts.
Lxx = padarray(Lxx, [0, Dxx_width]);
% Compute final output as the linear combination.
Lxx = circshift(Lxx , [0, -Dxx_width]) +  circshift(Lxx , [0, Dxx_width]) -2 *  Lxx;
% Remove padding
Lxx = Lxx(Dxx_y+1 : end-Dxx_y, Dxx_width+Dxx_x+1 : end-Dxx_width-Dxx_x);

% -------------------------- %
%      Computation of Lyy    %
% -------------------------- %
% Compute useful distances (half of height and width).
Dyy_x = (Dyy_width + 1)/2 - 1;
Dyy_y = (Dyy_height + 1)/2 - 1;
% Compute convolution with unit filter.
Lyy = BoxFilterHelper(I_integral, Dyy_height, Dyy_width);
% Necessary padding to avoid conflicts.
Lyy = padarray(Lyy, [Dyy_height, 0]);
% Compute final output as the linear combination.
Lyy = circshift(Lyy , [-Dyy_height, 0]) +  circshift(Lyy , [Dyy_height, 0]) -2 *  Lyy;
% Remove padding
Lyy = Lyy(Dyy_height+Dyy_y+1 : end-Dyy_height-Dyy_y, Dyy_x+1 : end-Dyy_x);

% -------------------------- %
%      Computation of Lxy    %
% -------------------------- %
% Compute useful distances (half of height and width).
Dxy_x = (Dxy_width + 1)/2 - 1;
Dxy_y = (Dxy_height + 1)/2 - 1;
% Compute convolution with unit filter.
Lxy = BoxFilterHelper(I_integral, Dxy_height, Dxy_width);
% Necessary padding to avoid conflicts.
Lxy = padarray(Lxy, [Dxy_y+1, Dxy_x+1]);
% Compute final output as the linear combination.
Lxy = circshift(Lxy , [-Dxy_y-1, -Dxy_x-1]) +  circshift(Lxy , [Dxy_y+1, Dxy_x+1]) - circshift(Lxy, [-Dxy_y - 1, Dxy_x+1]) - circshift(Lxy, [Dxy_y+1, -Dxy_x-1]);
% Remove padding
Lxy = Lxy(2*Dxy_y+2 : end-2*Dxy_y-1, 2*Dxy_x+2 : end-2*Dxy_x-1);

% Compute cornerness criterion.
R = Lxx .* Lyy - (0.9*Lxy).^2;

% Keep appropriate pixels based on cornerness criterion.
max_R = max(max(R));
B_sq = strel('disk',n);
Cond1 = (R == imdilate(R,B_sq));
Cond2 = (R > theta * max_R);
[i, j] = find(Cond1 & Cond2);

% Return the coordinates of the detected points along
% with the scale.
points = horzcat([j, i], sigma*ones(size(i)));


