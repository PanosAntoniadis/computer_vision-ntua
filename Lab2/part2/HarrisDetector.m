function [points, points_binary] = HarrisDetector(L, sigma, t, k, theta, si, ti)
% Harris Detector
% 
% Usage:
%         points = HarrisDetector(L, sigma, t, k, theta)
% 
% Description:
% Returns a N*4 matrix that corresponds to the
% points detected. The first two collumns are the 
% coordinates in the current frame, the third is the scale of the
% detection and the fourth is the frame. 
% 
% In:
%   L: input video
%   sigma: initial spatial scale
%   t: initial temporal scale
%   k: threshold
%   theta: parameter
%   si, ti
%
% Out:
%   points: a N*4 matrix containing the detected points in each frame.
%   points_binary: A binary sequence of frames where 1 represents an
%   interest point.
%

% Convert frames to double
L = im2double(L);

% Compute Gaussian kernel in space
n_sigma = ceil(3 * sigma) * 2 + 1;
Gs = fspecial('gaussian', [n_sigma, n_sigma], sigma);

% Compute Gaussian kernel in time
n_t = ceil(3 * t) * 2 + 1;
Gt(1, 1, 1:n_t) = fspecial('gaussian', [1 n_t], t);                      

% Compute partial derivatives of L in all axes.
Ix = imfilter(L, [-1 0 1], 'symmetric');
Iy = imfilter(L, [-1 0 1]', 'symmetric');
filter_time(1, 1, :) = [-1 0 1];
It = imfilter(L, filter_time, 'symmetric');

% Compute 3*3 matrix L.
Lxx = imfilter(imfilter((Ix .* Ix), Gs, 'symmetric'), Gt, 'symmetric');
Lyy = imfilter(imfilter((Iy .* Iy), Gs, 'symmetric'), Gt, 'symmetric');
Ltt = imfilter(imfilter((It .* It), Gs, 'symmetric'), Gt, 'symmetric');
Lxy = imfilter(imfilter((Ix .* Iy), Gs, 'symmetric'), Gt, 'symmetric');
Lxt = imfilter(imfilter((Ix .* It), Gs, 'symmetric'), Gt, 'symmetric');
Lyt = imfilter(imfilter((Iy .* It), Gs, 'symmetric'), Gt, 'symmetric');

n_s_sigma = ceil(3 * si) * 2 + 1;
Gs_sigma = fspecial('gaussian', [n_s_sigma, n_s_sigma], si);

n_s_t = ceil(3 * ti) * 2 + 1;
Gs_t(1, 1, 1:n_s_t) = fspecial('gaussian', [1 n_s_t], ti); 
% Compute 3*3 matrix Μ.
Lxx = imfilter(imfilter(Lxx, Gs_sigma, 'symmetric'), Gs_t, 'symmetric');
Lyy = imfilter(imfilter(Lyy, Gs_sigma, 'symmetric'), Gs_t, 'symmetric');
Ltt = imfilter(imfilter(Ltt, Gs_sigma, 'symmetric'), Gs_t, 'symmetric');
Lxy = imfilter(imfilter(Lxy, Gs_sigma, 'symmetric'), Gs_t, 'symmetric');
Lxt = imfilter(imfilter(Lxt, Gs_sigma, 'symmetric'), Gs_t, 'symmetric');
Lyt = imfilter(imfilter(Lyt, Gs_sigma, 'symmetric'), Gs_t, 'symmetric');


% Compute the trace of L
trace = Lxx + Lyy + Ltt;

% Compute the derivative of L
det = (Lxx.*Lyy.*Ltt - Lxx.*Lyt.^2) - (Ltt.*Lxy.^2 - Lxy.*Lxt.*Lyt) + (Lxy.*Lxt.*Lyt - Lyy.*Lxt.^2);

% Compute the 3d corner criterion
H = abs(det - k*trace.^3);

% Define locality for the local maximum detection.
[x,y,z] = ndgrid(-sigma:sigma);                                                                 
% Define a sphere and get local maximum in this sphere along with a
% threshold
B = strel(sqrt(x.^2 + y.^2 + z.^2) <= sigma);                                               
max_H = max(max(max(H)));
cond1 = (H == imdilate(H, B));                                                          
cond2 = cond1 & H > theta * max_H;                                                      
points_binary = cond2;

% Get only 1's and return them as indexes.
[y, x, z] = ind2sub(size(points_binary), find(points_binary));  
% Return interest points in desired format.
points = [x y si*ones(size(x)) z];   
