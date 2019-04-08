%1.1.2 Add_Noise(I,PSNR)

function J=AddNoise(I,PSNR)
% AddNoise - Add Noise
% 
% Usage:
%         J=AddNoise(I,PSNR)
% 
% Description:
% Returns a matrix that represents the input_Image
% in which it is added noise with PSNR that is defined 
% in parameters
% 
% In:
%   I    : input image
%   PSNR : Peak-to-peak Signal to Noise Ratio 
%
% Out:
%   J: a 2D matrix containing The input image with noise 
%
Imax=max(max(I));
Imin=min(min(I));
sn=(Imax-Imin)/(10^(PSNR/20));
J=imnoise(I,'gaussian',0,sn^2);
end
