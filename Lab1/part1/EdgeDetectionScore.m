function Score=EdgeDetectionScore(noiseImage,clearImage)
%  EdgeDetectionScore - Edge Detection Score
% 
% Usage:
%         Score = EdgeDetectionScore(noiseImage,clearImage)
% 
% Description:
%   Returns the percentage of edges that detected correctly
%  in the image with noise.
% 
% In:
%   noiseImage    : the boolean matrix of the Image with noise after the
%                   EdgeDetect algorithm
%   
%   clearImage    : the boolean matrix of the Image without noise after the
%                   edge detection
% Out:
%   Score: The percentage of the edges that detected correctly
%
T=clearImage;
D=noiseImage;
D_T = (D & T) ;
T_D= (T & D);
Pr_D_T=sum(D_T(:))/sum(T(:));
Pr_T_D=sum(T_D(:))/sum(D(:));
Score=(Pr_D_T + Pr_T_D)/2;
end