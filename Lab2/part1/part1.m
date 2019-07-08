% Removing past variables and commands.
clear, clc, close all

% Define parameters of the model
rho = 3;
epsilon = 0.05;
d_x0 = 0;
d_y0 = 0;
threshold = 0.01;
multiscale=1;
scales=4;

% Load skin samples from skinSamplesRGB.mat
load("skinSamplesRGB.mat");
% Get mean value and covariance from the skin samples.
[mean_CbCr, cov_CbCr] = trainPdf(skinSamplesRGB);

% Read first image and compute its bounding box.
I_curr = imread('./GSLframes/1.png');
boundingBox = findFace(I_curr, mean_CbCr, cov_CbCr);
x = boundingBox(1);
y = boundingBox(2);
width = boundingBox(3);
height = boundingBox(4);

% Plot first  image.
figure;
imshow(I_curr);
hold on;
rectangle('Position', boundingBox, 'EdgeColor', 'g');
hold off

for k = 1:70
    I_prev = I_curr;
    % Read next image
    I_curr = imread(strcat('./GSLframes/', strcat(num2str(k+1), '.png')));
    % Compute the bounding box of each image.
    I_prev_face = I_prev(ceil(y: y+height+3), ceil(x: x+width+7));
    I_curr_face = I_curr(ceil(y: y+height+3), ceil(x: x+width+7));
    % Compute the global shift
    if(multiscale==0)
        %Lucas-Kanade
        [d_x, d_y] = lk(I_prev_face, I_curr_face, rho, epsilon, d_x0, d_y0);
    else
        %Multiscale Lucas-Kanade
        [d_x, d_y] = multi_lk(I_prev_face, I_curr_face, rho, epsilon, d_x0, d_y0,scales);
    end

    [displ_x, displ_y] = displ(-d_x, -d_y, threshold);
    % Update values
    x = x + displ_x;
    y = y + displ_y;

    % Plot current frame
    
    pause(0.05);
    
    subplot(1,2,1);
    d_x_r = imresize(d_x, 0.2);
    d_y_r = imresize(d_y, 0.2);
    quiver(-d_x_r,-d_y_r)
    subplot(1,2,2);
    
    imshow(I_curr);
    hold on;
    rectangle('Position', [x, y, width, height], 'EdgeColor', 'g');
    
    hold off
    
end
