function [hist] = image_histogram(image, centroids)
% image_histogram - Histogram of an image
% 
% Usage:
%         hist = image_histogram(image, centroids)
% 
% Description:
% Computes the histogram of the input image
% based on the centroids given.
% 
% In:
%   image : A matrix that contains the descriptors of
%           each interesting point of an image.
%   centroid : A matrix that contains the centers from
%           the k-means algorithm.
%
% Out:
%   hist : An array that represents the histogram.

% Compute euclidean distance between the descriptors of
% the image and the centroids
dist = pdist2(image, centroids, 'euclidean');

% Each row contains the distance of a certain descriptor
% with each centroid. So, min of each row is the minumum
% distance of each descriptor with the centroids.
[value, idx] = min(dist,[],2);

% Get the histogram of the image, i. e.
% for each centroid the number of descriptors
% that are close to it.
hist = histc(idx, 1:size(centroids, 1));

% Normalize the histogram by its L2 norm.
hist  = hist / norm(hist);

end
