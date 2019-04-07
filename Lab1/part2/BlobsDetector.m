function [points] = BlobsDetector (I, sigma, theta)
% BlobsDetector - Blobs Detector
% 
% Usage:
%         points = BlobsDetector(I, sigma, theta)
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

% Define Gaussian smoothing kernel.
n_sigma = ceil(3 * sigma) * 2 + 1;
Gs = fspecial('gaussian', [n_sigma, n_sigma], sigma);
Is = imfilter(I, Gs, 'symmetric');

% Compute Hessian matrix.
[Lx, Ly] = gradient(Is);
[Lxx, Lxy] = gradient(Lx);
[Lxy, Lyy] = gradient(Ly);

% Compute derivative of Hessian matrix for every pixex.
R = Lxx .* Lyy - Lxy.^2;

% Keep appropriate pixels based on cornerness criterion.
max_R = max(max(R));
B_sq = strel('disk',n_sigma);
Cond1 = (R == imdilate(R,B_sq));
Cond2 = (R > theta * max_R);
[i, j] = find(Cond1 & Cond2);

% Return the coordinates of the detected points along
% with the scale.
points = horzcat([j, i], sigma*ones(size(i)));

end