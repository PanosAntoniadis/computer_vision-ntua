function [desc] = calculateHoG(points, Ix, Iy, width, height, nbins)
% calculateHoG
% 
% Usage:
%         desc = calculateHoG(points, Ix, Iy, width, height, nbins)
% 
% Description
% Returns the HoG descriptor for each point.
% 
% In:
%   points: interest points
%   Ix: image gradient in x axis
%   Iy: image gradient in y axis
%   width
%   height
%   nbins: number of bins used by the histogram
%
% Out:
%   A matrix that contains in each collumn j the hoG descriptor
%   of the interest point j.
%

desc = cell(size(points, 1), 1);

for i=1:size(points, 1)
   point = points(i, 1:2);
   x = point(1);
   y = point(2);
   scale = points(i, 3);
   frame = points(i, 4);
   % Compute a square of size 4*scale respecting the image bounds.

   if x - 2*scale > 0
       x1 = x - 2*scale;
   else
       x1 = 1;
   end
   
   if x + 2*scale <= width
       x2 = x + 2*scale;
   else
       x2 = width;
   end
   
   if y - 2*scale > 0
       y1 = y - 2*scale;
   else
       y1 = 1;
   end
   
   if y + 2*scale <= height
       y2 = y + 2*scale;
   else
       y2 = height;
   end
   
   Ix_i = Ix(y1:y2, x1:x2, frame);
   Iy_i = Iy(y1:y2, x1:x2, frame);
 
   desc{i} = OrientationHistogram(Ix_i, Iy_i, nbins, [4*scale 4*scale]);
end

desc = cell2mat(desc);
