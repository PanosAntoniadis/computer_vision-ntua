% Removing past variables and commands.
clear, clc, close all

% Read input image
I = imread('1.png');

% -------------------------------- %
%   1.1: Facial Skin Detection     %
% -------------------------------- %

% Load skin samples from skinSamplesRGB.mat
load("skinSamplesRGB.mat");

% Get mean value and covariance from the skin samples.
[mean_CbCr, cov_CbCr] = trainPdf(skinSamplesRGB);

% Compute bounding box.
boundingBox = findFace(I, mean_CbCr, cov_CbCr);

% figure;
% imshow(I);
% hold on;
% rectangle('Position', boundingBox, 'EdgeColor', 'g');



% -------------------------------- %
%   1.2: Lucas-Kanade algorithm    %
% -------------------------------- %

% Define parameters
rho = 3;
epsilon = 0.05;
d_x0 = 0;
d_y0 = 0;

% Read two input images
I1 = imread('./GSLframes/69.png');
I2 = imread('./GSLframes/70.png');

% Compute their bounding boxes
boundingBox1 = findFace(I1, mean_CbCr, cov_CbCr);
x1 = boundingBox1(1);
y1 = boundingBox1(2);
w1 = boundingBox1(3);
h1 = boundingBox1(4);

%boundingBox2 = findFace(I2, mean_CbCr, cov_CbCr);
%x2 = boundingBox2(1);
%y2 = boundingBox2(2);

% Keep height and width of the first image
width = w1;
height = h1;

% Compute images in the bounding box and
% call Lucas Kanade function
I1_face = I1(ceil(y1: y1+height), ceil(x1: x1+width));
I2_face = I2(ceil(y1: y1+height), ceil(x1: x1+width));
[d_x, d_y] = lk(I1_face, I2_face, rho, epsilon, d_x0, d_y0);

% Plot d as a vector field
d_x_r = imresize(d_x, 0.3);
d_y_r = imresize(d_y, 0.3);
%quiver(-d_x_r, -d_y_r);


% ----------------------------------- %
%   1.4: Compute global face shift    %
% ----------------------------------- %

% Define threshold
threshold = 1;

% Compute global face shift
[displ_x, displ_y] = displ(d_x, d_y, threshold);

I = imread('./GSLframes/1.png');
boundingBox = findFace(I, mean_CbCr, cov_CbCr);
x = boundingBox(1);
y = boundingBox(2);
w = boundingBox(3);
h = boundingBox(4);
figure;
imshow(I);
hold on;
rectangle('Position',boundingBox, 'EdgeColor', 'g');
hold off

for k = 1:70
    I_prev = imread(strcat('./GSLframes/', strcat(num2str(k), '.png')));
    I_curr = imread(strcat('./GSLframes/', strcat(num2str(k+1), '.png')));
    I_prev_face = I_prev(ceil(y: y+height), ceil(x: x+width));
    I_curr_face = I_curr(ceil(y: y+height), ceil(x: x+width));
    [d_x, d_y] = lk(I_prev_face, I_curr_face, rho, epsilon, d_x0, d_y0);
    [displ_x, displ_y] = displ(-d_x, -d_y, threshold);
    x = x + displ_x;
    y = y + displ_y;

    pause(0.000005);
    imshow(I_curr);
    hold on;
    rectangle('Position', [x, y, w, h], 'EdgeColor', 'g');
    hold off
end



