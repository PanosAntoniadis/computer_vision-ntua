function D=EdgeDetect(I,sigma,theta_edge,LaplacType)
    % EdgeDetect - Edge Detect
% 
% Usage:    
%       D=EdgeDetect(I,sigma,theta_edge,LaplacType)
%
% Description:
% Returns a boolean matrix that represents 
% the edges of the input Image
% 
% In:
%   I    : input image
%   sigma: is the standard deviation of the distribution(Gaussian)
%   theta_edge: a threshold parameter
%   LaplacType: defines the model of filters that will be used in the
%               algorithm :     
%               
%               LaplacType = 0 (Linear method-Convolution with gaussian
%                               filter)
%               LaplacType = 1 (Non-Linear method-Convolution with
%                               morphological filter)
%
% Out:
%   D: a 2D boolean matrix containing the detected edges
%
%------------------------ 1.2.1 ------------------------------
% Create a gaussian filter H_Gaus and a Laplacian of Gaussian filter H_LoG
% with a n-cernel and sigma-the standrad deviation
    n=ceil((3*sigma))*2+1;
    hsize=[n n];
    H_LoG = fspecial('log',hsize,sigma);
    H_Gaus = fspecial('gaussian',hsize,sigma);
    
    %1.2.2 Define Linear and Not-Linear methods
    
    B=strel('diamond',1);
    Is =imfilter(I,H_Gaus,'conv');
    if LaplacType == 0 
        L = imfilter(I,H_LoG,'conv');
    elseif LaplacType == 1
        L=imdilate(Is,B) + imerode(Is,B) - 2*Is;
    end
    
    %1.2.3 approximation of Zerocrossings
    
    X = (L >= 0);
    Y = imdilate(X,B) - imerode(X,B);
    
    %1.2.4 Rejection of zerocrossings in smooth areas
    
    [Gx,Gy]=gradient(Is);
    norm_grad=abs(Gx)+abs(Gy);    
    max_grad=max(max(norm_grad));
    D = (Y==1 & norm_grad>theta_edge*(max_grad));
end