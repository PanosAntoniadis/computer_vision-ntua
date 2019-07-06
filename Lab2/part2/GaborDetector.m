function [points, points_binary] = GaborDetector (L, sigma, t, theta)
% Gabor Detector
% 
% Usage:
%         points = GaborDetector (L, sigma, t, theta)
% 
% Description:
% Returns a N*4 matrix that corresponds to the
% points detected. The first two collumns are the 
% coordinates in the current frame, the third is the scale of the
% detection and the fourth is the frame.
% 
% In:
%   L: input video
%   sigma: spatial scale
%   t: temporal scale
%   theta: threshold
%
% Out:
%   points: a N*4 matrix containing the detected points in each frame.
%   points_binary: A binary sequence of frames where 1 represents an
%   interest point.
%

% Define 2D Gaussian kernel
n_sigma = ceil(3 * sigma) * 2 + 1;
Gs = fspecial('gaussian', [n_sigma, n_sigma], sigma);

% Convolve in space with above Gaussian..
I_s = imfilter(L, Gs, 'symmetric');

% Define gabor filters
tim = -2*t:2*t;
w = 4/t;
h_ev = -cos(2*pi*tim*w).*exp((-tim.^2)/(2*t.^2));
h_ev = h_ev / norm(h_ev, 1);
h_od = -sin(2*pi*tim*w).*exp((-tim.^2)/(2*t.^2));
h_od = h_od / norm(h_od, 1);

% Set gabor filter in time domain and compute H
t_hev(1,1,:) = h_ev;
t_hod(1,1,:) = h_od;
H =  imfilter(I_s, t_hev, 'symmetric').^2 +  imfilter(I_s, t_hod, 'symmetric').^2;


% Get local maximum inside a sphere
[x,y,z] = ndgrid(-sigma:sigma);                                                                 
B = strel(sqrt(x.^2 + y.^2 + z.^2) <= sigma);                                               
max_H = max(max(max(H)));
cond1 = (H == imdilate(H, B));                                                          
cond2 = cond1 & H > theta * max_H;                                                      
points_binary = cond2;

[y, x, z] = ind2sub(size(points_binary),find(points_binary));                              
points = [x y sigma*ones(size(x)) z];   
