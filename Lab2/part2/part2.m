% Removing past variables and commands.
clear, clc, close all

% Add necessary paths
addpath('../cv19_lab2_material_part2/part2')
addpath('../part1')

% ---------------------------------- %
%  2.1: Time-Space interest points   %
% ---------------------------------- %

% Read input video

% name = 'samples/boxing/person16_boxing_d4_uncomp.avi';
% name = 'samples/running/person09_running_d1_uncomp.avi';
% name = 'samples/walking/person07_walking_d2_uncomp.avi';
% L = readVideo( name, 200, 0);

% Define parameters for Harris
sigma_h = 1;
t_h = 0.7;
k_h = 0.1;
theta_h = 0.1;

% Define parameters for Gabor
sigma_g = 1.6;
t_g = 1.5;
theta_g = 0.1;

% Define multiscale parameters
N = 4;
s = 1.5;

% Define Lucas Kanade parameters
rho = 0.5;
epsilon = 0.1;
d_x0 = 0.1;
d_y0 = 0.1;

% Define Hof parameters
nbins = 10;

% points = HarrisDetector(L, sigma_h, t_h, k_h, theta_h, s*sigma_h, s*t_h);
% points = MultiscaleHarrisDetector(L, sigma_h, t_h, s, N, k_h, theta_h);

% points = GaborDetector(L, sigma_g, t_g, theta_g);
% points = MultiscaleGaborDetector(L, sigma_g, t_g, s, N, theta_g);
% showDetection(L, points);


% ---------------------------------------- %
%  2.2: Time-Space histogram descriptors   %
% ---------------------------------------- %


hof_harris = cell(1, 9);
hog_harris = cell(1, 9);
both_harris = cell(1, 9);

hof_gabor = cell(1, 9);
hog_gabor = cell(1, 9);
both_gabor = cell(1, 9);

i = 1;
% Loop through all videos in /samples folder.
folders = dir('samples')';
folders = folders(~ismember({folders.name},{'.','..'}));
for folder = folders
    path = strcat('samples/', folder.name);
    files = dir(path)';
    files = files(~ismember({files.name},{'.','..'}));
    for file = files
        name = strcat(strcat(path, '/'), file.name);
        % Read video
        L = readVideo( name, 200, 0);
        
        points_harris = HarrisDetector(L, sigma_h, t_h, k_h, theta_h, s*sigma_h, s*t_h);
        points_harris_multi = MultiscaleHarrisDetector(L, sigma_h, t_h, s, N, k_h, theta_h);
        points_gabor = GaborDetector(L, sigma_g, t_g, theta_g);
        points_gabor_multi = MultiscaleGaborDetector(L, sigma_g, t_g, s, N, theta_g);

        % Compute image flow.
        dx = zeros(size(L, 1), size(L, 2), size(L, 3));
        dy = zeros(size(L, 1), size(L, 2), size(L, 3));
        for fr=1:size(L, 3)-1
            [dx(:, :,fr), dy(:, :, fr)] = lk(L(:, :, fr), L(:, :, fr+1), rho, epsilon, d_x0, d_y0);
        end  
        % Compute gradients.
        [Lx, Ly, ~] = gradient(im2double(L));
        width = size(L, 2);
        height = size(L, 1);
        
        % Compute descriptors for each interest point detector
        
        % Harris
        hof_harris{i} = calculateHof(points_harris, dx, dy, width, height, nbins);
        hog_harris{i} = calculateHoG(points_harris, Lx, Ly, width, height, nbins);
        both_harris{i} = [hof_harris{i}; hog_harris{i}];
        
        % Gabor
        hof_gabor{i} = calculateHof(points_gabor, dx, dy, width, height, nbins);
        hog_gabor{i} = calculateHoG(points_gabor, Lx, Ly, width, height, nbins);
        both_gabor{i} = [hof_gabor{i}; hog_gabor{i}];
        
        i = i + 1;
    end
end

BoW_hof_harris = OurBagOfWords(hof_harris);
BoW_hog_harris = OurBagOfWords(hog_harris);
BoW_both_harris = OurBagOfWords(both_harris);

BoW_hof_gabor = OurBagOfWords(hof_gabor);
BoW_hog_gabor = OurBagOfWords(hog_gabor);
BoW_both_gabor = OurBagOfWords(both_gabor);

save('BoW_hof_harris', 'BoW_hof_harris')
save('BoW_hog_harris', 'BoW_hog_harris')
save('BoW_both_harris', 'BoW_both_harris')

save('BoW_hof_gabor', 'BoW_hof_gabor')
save('BoW_hog_gabor', 'BoW_hog_gabor')
save('BoW_both_gabor', 'BoW_both_gabor')


% --------------------------- %
%  2.3: Dendrogram creation   %
% --------------------------- %

% Load .mat file
load('BoW_hof_gabor.mat');
data = BoW_hof_gabor;
link = linkage(data, 'average', 'distChiSq');
labels = ['Box_1'; 'Box_2'; 'Box_3'; 'Run_1'; 'Run_2'; 'Run_3'; 'Wlk_1'; 'Wlk_2'; 'Wlk_3'];
f = figure;
dendrogram(link, 'Labels', labels);
% Save dendrogram
% saveas(f, '../report/photos/part2/dendrograms/hof_gabor.png');

