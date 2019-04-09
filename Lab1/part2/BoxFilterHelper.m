function [out] = BoxFilterHelper (I, height, width)
% BoxFilterHelper - Helper function for BoxFiltersDetector
% 
% Usage:
%         out = BoxFilterHelper (I, height, width)
% 
% Description:
% Returns the convolution of the image I
% with a unit filter with dimensions
% width * height.
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
I_padded = padarray(I, [2*y+1, 2*x+1], 'replicate', 'post');
I_padded = padarray(I_padded, [2*y+1, 2*x+1], 'pre');

% Compute necessary points of the integral image.
C = circshift(I_padded, [-y -x]);         
A = circshift(I_padded, [y+1 x+1]);
B = circshift(I_padded, [y+1 -x]);
D = circshift(I_padded, [-y x+1]);
out = A + C - B - D;
% Remove padding
out = out(y+2:end-y-1, x+2:end-x-1);

