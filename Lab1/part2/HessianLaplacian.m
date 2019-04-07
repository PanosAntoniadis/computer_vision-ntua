function [points] = HessianLaplacian (I, sigma, s, N, theta)
% HessianLaplacian - Multiscale Blobs Detector
% 
% Usage:
%         points = HessianLaplacian(I, sigma, s, N, theta)
% 
% Description:
% Returns a N*3 matrix that corresponds to the
% blobs detected. The first two collumns are the 
% coordinates and the third is the scale of the
% detection.
% 
% In:
%   I: input image
%   sigma: differential scale
%   s: scaling factor
%   N: number of scales
%   theta: a threshold
%
% Out:
%   points: a N*3 matrix containing the detected points.
%

% A cell containing the blobs detected in every scale.
all_points = cell(1,N);
% Contains the LoG in each scale.
logs = zeros(size(I, 1), size(I, 2), N);
for i = 1:N
    % Compute current integral and differential scale.
    si = s.^(i-1) * sigma;
    % Get detected points in current scales.
    all_points{i} = BlobsDetector(I, si, theta);
    % Compute Laplacian of Gaussian.
    filt_size =  ceil(3 * si) * 2 + 1; 
    log =  fspecial('log', filt_size, si);
    % Keep it in logs array.
    logs(:,:,i) = (si^2) * abs(imfilter(I,log, 'symmetric'));    
end

% For each point check if it is a local maximum.
points = [];
for i=1:N
    interestPts = all_points{i};
    for p=1:size(interestPts,1)
        point = logs(interestPts(p, 1), interestPts(p, 2), i);
        if (i < N && i > 1)
            if (point >= logs(interestPts(p, 1), interestPts(p, 2), i+1) && point >= logs(interestPts(p, 1), interestPts(p, 2), i-1))
                points = [points; interestPts(p, 1), interestPts(p, 2), interestPts(p, 3)];
                continue;
            end
        end       
        if ( i == N && point >= logs(interestPts(p, 1), interestPts(p, 2), i-1))
            points = [points; interestPts(p, 1), interestPts(p, 2), interestPts(p, 3)];
            continue;
        end
        
        if ( i == 1 && point >= logs(interestPts(p, 1), interestPts(p, 2), i+1))
            points = [points; interestPts(p, 1), interestPts(p, 2), interestPts(p, 3)];
            continue;
        end
    end
end

