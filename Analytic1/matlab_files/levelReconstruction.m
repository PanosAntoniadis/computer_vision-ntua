function [f_hat, snr] = levelReconstruction(m, f)
% Reconstruction of an image based on the level sets.
% 
% Usage:    
%       [f_hat, snr] = levelReconstruction(m, I)
%
% Description:
% Returns the reconstructed image and the
% Peak SNR of the reconstruction.
% 
% In:
%   f : input image
%   m : number of level sets.
%
% Out:
%   f_hat : reconstructed image
%   snr : peak SNR of the reconstruction


% Get m uniform distributed level sets in range [0, 255].
v = randi(255 ,m , 1);

% For each level set compute the indicator function.
f_hat = zeros(size(f, 1), size(f, 2));

for level = 1:m
    level_set = (f >= v(level));
    f_hat = max(f_hat, v(level)*level_set);
end

snr = 20 * log10(255 ./ norm(double(f) - f_hat));

end


