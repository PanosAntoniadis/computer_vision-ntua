function [points] = MultiscaleGaborDetector (L, sigma, t, s, N, theta)
% MultiscaleGaborDetector
% 
% Usage:
%         points = MultiscaleGaborDetector (L, sigma, t, s, N, theta)
% 
% Description:
% Returns a N*4 matrix that corresponds to the
% points detected.
% 
% In:
%   L: input video
%   sigma: spatial scale
%   t: temporal scale
%   s: step
%   N: number of steps
%   theta: parameter
%
% Out:
%   points: a N*4 matrix containing the detected points in each frame.
%   points_binary: A binary sequence of frames where 1 represents an
%   interest point.
%

% A binary matrix containing 1 in the points detected in every scale.
point_matrix = zeros(size(L, 1), size(L, 2), size(L, 3), size(L, 4));
% Contains the LoG in each scale.
logs = zeros(size(L, 1), size(L, 2), size(L, 3), N);
for i = 1:N
    % Compute current integral and differential scale.
    si = s.^(i-1) * sigma;
    ti = s.^(i-1) * t;
    % Get detected points in current scales.
    [~, point_matrix(:,:,:,i)] = GaborDetector(L, si, ti, theta);
    % Compute Laplacian of Gaussian for space and time.
    n_si =  ceil(3 * si) * 2 + 1; 
    log =  fspecial('log', n_si, si);
    n_ti = ceil(3*ti) * 2 + 1;
    log_time(1,1,1:n_ti) = fspecial('log', [1 n_ti], ti);                      
    % Keep it in logs array.
    logs(:,:,:,i) = (si^3) * abs(imfilter(imfilter(L,log, 'symmetric'), log_time, 'symmetric'));    
end

% Keep local maximum points between scales.
dilation = logs == imdilate(logs, ones(1,1,1,3)); 
local_max = point_matrix == dilation & (dilation == 1);

% Convert binary matrix in the desired output
points = [];
for i = 1:N
    si = s^(i-1)*sigma;                                                                        
    [y, x, z] = ind2sub(size(local_max(:,:,:,i)),find(local_max(:,:,:,i)));
    points = [points; x y si*ones(size(x)) z]; 
end