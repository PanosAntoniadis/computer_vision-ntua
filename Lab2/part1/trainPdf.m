function [mean_CbCr, cov_CbCr] = trainPdf(samples)
% trainPdf
% 
% Usage:
%         [mean_CbCr, cov_CbCr] = trainPdf(samples)
% 
% Description:
% Computes the mean value and the covariance
% matrix of a normal pdf based on the samples
% given, keeping only Cb and Cr channels.
% 
% In:
%   samples: skin samples
%
% Out:
%   mean_CbCr: mean value of Cb and Cr channel.
%   cov_CbCr: covariance matrix of the above channels.
%

% Convert skin values from RGB color space to YCbCr.
samplesYCbCr = rgb2ycbcr(samples);
% Flatten the samples.
samplesYCbCr = reshape(samplesYCbCr, [], 3);

% Keep only Cb and Cr channels.
samplesCbCr = samplesYCbCr(:, 2:end);

% Compute the mean value for Cb and Cr.
mean_CbCr = mean(samplesCbCr);

% Compute the covariance matrix.
cov_CbCr = cov(double(samplesCbCr));

end