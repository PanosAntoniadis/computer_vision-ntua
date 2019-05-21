function boundingBox = findFace(I, mean_CbCr, cov_CbCr)
% boundingBox
% 
% Usage:
%         boundingBox = findFace(I, mean_CbCr, cov_CbCr)
% 
% Description:
% Computes bounding box of the face detected
% in the image.
% 
% In:
%   I: input RGB image
%   mean_CbCr: mean values of the Gaussian.
%   cov_CbCr: covariance matrix of the Gaussian.
%
% Out:
%   boundingBox: a box containg the face detected.
%

% Convert image from RGB color space to YCbCr.
image_YCbCr = rgb2ycbcr(I);
% Flatten the image.
image_flattened = reshape(image_YCbCr, [], 3);

% Compute multivariate normal probability density function
% using the computed mean and covariance.
prop = mvnpdf(double(image_flattened(:, 2:end)), mean_CbCr, cov_CbCr);

% Apply threshold in propabilities.
threshold = 0.001;
skin_indices = find(prop > threshold);
skin = zeros(size(I, 1), size(I, 2));
% Set to 1 skin pixels.
skin(skin_indices) = 1;

% Apply opening with a small structural object.
se1 = strel('disk',3);
skin = imopen(skin,se1);
% Apply closing with a big structural object.
se2 = strel('disk',10);
skin = imclose(skin, se2);

% Compute regions and stats of each region detected.
[L,~] = bwlabel(skin);
stats = regionprops(L,'basic');

% Compute region with max area.
[~,indice] = max([stats.Area]);

boundingBox = stats(indice).BoundingBox;



end

