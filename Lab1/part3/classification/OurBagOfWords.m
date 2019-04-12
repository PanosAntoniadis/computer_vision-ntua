function [BOF_tr,BOF_ts] = OurBagOfWords(data_train, data_test)
% OurBagOfWords - Visual Bag Of Words representation
% 
% Usage:
%         [BOF_tr, BOF_ts] = OurBagOfWords(data_train, data_test)
% 
% Description:
% Computer the Visual Bag of Words representation of the 
% training and test set.
% 
% In:
%   data_train : A cell array that in each cell contains 
%               the features for each photo in the training set.
%   data_test : A cell array that contains in each cell
%               the features for each photo in the test set.
%
% Out:
%   BOF_tr : A matrix that contains the BoVW representation
%           of each photo in the training set.
%   BOF_ts : A matrix that contains the BoVW representation
%           of each photo in the test set.

% Define useful variables
num_centroids = 500;
subset_percent = 0.5;

% ------------------------------- %
% Creation of the visual lexicon  %
% ------------------------------- %

% Concatenation of all descriptors from the training set.
% Each cell in data_train contains the descriptors for a single
% photo. So, we just put all cells in a single matrix.
data_descriptors = cell2mat(data_train');

% Get a random subset of data_descriptors.
subset_len = ceil(size(data_descriptors, 1) * subset_percent);
sample = datasample(data_descriptors,subset_len);

% Perform k-means clustering to the subset.
[idx, centroids] = kmeans(sample, num_centroids);

% ------------------------------- %
%   Creation of the histograms    %
% ------------------------------- %

% We want to compute the histogram for each image.
% So, we use 'cellfun' to apply the function image_histogram()
% to each cell, which represents a single image. The function
% image_histogram() returns the BoVW representation of a single 
% image (array not scalar), so UniformOutput is set to false.
BOF_tr = cellfun(@(image) image_histogram(image, centroids), data_train, 'UniformOutput', false);

% Convert the cell array to matrix and get the transpose in 
% order to match the label vectors.
BOF_tr = cell2mat(BOF_tr)';

% Continue the same procedure with the test set,
BOF_ts = cellfun(@(image) image_histogram(image, centroids), data_test, 'UniformOutput', false);
BOF_ts = cell2mat(BOF_ts)';

end