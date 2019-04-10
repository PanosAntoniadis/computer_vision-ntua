clear; clc;


% Add path of detectors if necessary
addpath(genpath('../detectors'));
addpath(genpath('../descriptors'));

% Anonymous functions for all detectors with predefined
% parameters (only image I is variable).
HarrisDetector = @(I) HarrisStephens(I, 2, 2.5, 0.05, 0.005);
MultiscaleHarrisDetector = @(I) HarrisLaplacian(I, 2, 2.5, 1.5, 4, 0.05, 0.005);
BlobsDetector = @(I) BlobsDetector(I, 2, 0.005);
MultiscaleBlobsDetector = @(I) HessianLaplacian(I, 2, 1.5, 4, 0.005);
MultiscaleBoxDetector = @(I) MultiscaleBoxFiltersDetector(I, 2, 1.5, 4, 0.005);


% Anonymous function for extracting the SURF features
surfDescriptor = @(I,points) featuresSURF(I,points);
% Anonymous function for extracting the HOG features
hogDescriptor = @(I,points) featuresHOG(I,points);


% Get the requested errors, one value for each image in the dataset.

disp("Harris Detector with SURF");
[scale_error,theta_error] = evaluation(HarrisDetector, surfDescriptor)

disp("Multiscale Harris Detector with SURF");
[scale_error,theta_error] = evaluation(MultiscaleHarrisDetector, surfDescriptor)

disp("Blobs Detector with SURF");
[scale_error,theta_error] = evaluation(BlobsDetector, surfDescriptor)

disp("Multiscale Blobs Detector with SURF");
[scale_error,theta_error] = evaluation(MultiscaleBlobsDetector, surfDescriptor)

disp("Multiscale Box Filter Detector with SURF");
[scale_error,theta_error] = evaluation(MultiscaleBoxDetector, surfDescriptor)

disp("Harris Detector with HOG");
[scale_error,theta_error] = evaluation(HarrisDetector, hogDescriptor)

disp("Multiscale Harris Detector with HOG");
[scale_error,theta_error] = evaluation(MultiscaleHarrisDetector, hogDescriptor)

disp("Blobs Detector with HOG");
[scale_error,theta_error] = evaluation(BlobsDetector, hogDescriptor)

disp("Multiscale Blobs Detector with HOG");
[scale_error,theta_error] = evaluation(MultiscaleBlobsDetector, hogDescriptor)

disp("Multiscale Box Filter Detector with HOG");
[scale_error,theta_error] = evaluation(MultiscaleBoxDetector, hogDescriptor)





