clear; clc;
% simple example of calling anonymous functions for evaluation

% add path of detectors if necessary
addpath(genpath('../detectors'));
addpath(genpath('../descriptors'));

% example of anonymous function for a simple Harris detector with predefined
% parameters (only image I is variable)
detector_func = @(I) HarrisLaplacian(I, 2, 2.5, 1.5, 4, 0.05, 0.005);

% example of anonymous function for extracting the SURF features
descriptor_func = @(I,points) featuresSURF(I,points);

% get the requested errors, one value for each image in the dataset 
[scale_error,theta_error] = evaluation(detector_func,descriptor_func);