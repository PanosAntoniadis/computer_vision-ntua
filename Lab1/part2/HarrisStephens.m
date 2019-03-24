function [points] = HarrisStephens (input_I, sigma, r, k, theta)
% HarrisStephens - Edge Detector
% 
% Usage:
%         points = HarrisStephens(input_I, sigma, r, k , theta)
% 
% Description:
% Returns a N*3 matrix that corresponds to the
% points detected. The first two collumns are the 
% coordinates and the third is the scale of the
% detection.
% 
% In:
%   input_I: input image
%   sigma: differential scale
%   r: integral scale
%   k: corneness criterion parameter
%   theta: a threshold
%
% Out:
%   points: a N*3 matrix containing the detected points.
%

% Convert image from int to double precision
I = im2double(input_I);

% Define Gaussian smoothing kernels.
n_sigma = ceil(3 * sigma) * 2 + 1;
n_r = ceil(3*r) * 2 + 1;
Gs = fspecial('gaussian', [n_sigma, n_sigma], sigma);
Gp = fspecial('gaussian', [n_r, n_r], r);

% Compute structure tensor J.
Is = imfilter(I, Gs, 'symmetric');
[Fx, Fy] = gradient(Is);
J1 = imfilter((Fx .* Fx), Gp, 'symmetric');
J2 = imfilter((Fx .* Fy), Gp, 'symmetric');
J3 = imfilter((Fy .* Fy), Gp, 'symmetric');

% Compute eigenvalues l+, l- of structure tensor J.
l_plus = 1/2 * (J1 + J3 + sqrt((J1 - J3).^2 + 4*J2.^2));
l_minus = 1/2 * (J1 + J3 - sqrt((J1 - J3).^2 + 4*J2.^2));

% Compute cornerness criterion
R = l_minus .* l_plus - k*(l_minus + l_plus).^2;

% Keep appropriate pixels based on cornerness criterion.
B_sq = strel('disk',n_sigma);
Cond1 = (R == imdilate(R,B_sq));
Cond2 = (R > theta * max(max(R)));
[i, j] = find(Cond1 & Cond2);

% Return the coordinates of the detected points along
% with the scale.
points = horzcat([j, i], sigma*ones(size(i)));
end



