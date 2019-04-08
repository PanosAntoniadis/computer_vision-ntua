function [out] = BoxFilterHelper (I, height, width)
% BoxFilterHelper - Blobs Detector
% 
% Usage:
%         out = BoxFilterHelper (I, sigma, height, width)
% 
% Description:
% Returns the convolution of the image I
% with a unit filter width*height.s
% 
% In:
%   I : integral input image
%   height: height of the filter
%   width : width of the filter
%
% Out:
%   out : The result of the convolution between the image and the unit
%   filter
%

% Compute the center of the filter 
x = (width + 1)/2 - 1;
y = (height + 1)/2 - 1;    

% Pad array in order to avoid conflicts.
I_padded = padarray(I, [x+1, y+1], 'replicate', 'post');
I_padded = padarray(I_padded, [x+1, y+1], 'pre');

% Compute necessary points of the integral image.
C = circshift(I_padded, [-x -y]);          
A = circshift(I_padded, [x+1 y+1]);
B = circshift(I_padded, [x+1 -y]);
D = circshift(I_padded, [-x y+1]);
out = A + C - B - D;
% Remove padding
out = out(x+2:end-x-1, y+2:end-y-1);

