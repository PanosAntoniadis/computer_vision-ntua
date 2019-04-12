clear; clc;
addpath(genpath('libsvm-3.17'));



%% Feature Extraction
% Αdd here your detector/descriptor functions i.e.
% We will use only multiscale detectors
MultiscaleHarrisDetector = @(I) HarrisLaplacian(I, 2, 2.5, 1.5, 4, 0.05, 0.005);
MultiscaleBlobsDetector = @(I) HessianLaplacian(I, 2, 1.5, 4, 0.005);
MultiscaleBoxDetector = @(I) MultiscaleBoxFiltersDetector(I, 2, 1.5, 4, 0.005);

% Anonymous function for extracting the SURF features
surfDescriptor = @(I,points) featuresSURF(I,points);
% Anonymous function for extracting the HOG features
hogDescriptor = @(I,points) featuresHOG(I,points);

% Extract features for a certain pair of detector-descriptor;
features = FeatureExtraction(MultiscaleBoxDetector, surfDescriptor);


%% Image Classification
for k=1:5
    %% Split train and test set
    [data_train,label_train,data_test,label_test]=createTrainTest(features,k);
    %% Bag of Words
    [BOF_tr,BOF_ts] = OurBagOfWords(data_train,data_test);
    %% SVM classification
    [percent(k),KMea] = svm(BOF_tr,label_train,BOF_ts,label_test);
    fprintf('Classification Accuracy: %f %%\n',percent(k)*100);
end
fprintf('Average Classification Accuracy: %f %%\n',mean(percent)*100);

