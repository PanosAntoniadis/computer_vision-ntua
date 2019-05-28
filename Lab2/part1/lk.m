function [d_x,d_y] = lk(I1, I2, rho, epsilon, d_x0, d_y0)
% lk - Lucas-Kanade algorithm
% 
% Usage:
%         [d_x,d_y] = lk(I1, I2, rho, epsilon, d_x0, d_y0)
% 
% Description:
% Computes the optical flow between two images.
% 
% In:
%  I1, I2: input images
%  rho: standard deviation of Gaussian
%  epsilon: parameter 
%  d_x0, d_y0: initialization of vector field d
%
% Out:
%   d_x, d_y: vector field d
%

% Convert iamges to range [0, 1]
I1 = mat2gray(I1);
I2 = mat2gray(I2);

%Define the times d is re-computed
k=50;

% Create the gaussian with standard deviation rho
n = (ceil(3*rho)*2) + 1;
G_r = fspecial('gaussian', [n n], rho);

% Define a meshgrid
[x_0,y_0] = meshgrid(1:size(I1,2), 1:size(I1,1));
[A1_0, A2_0] = gradient(I1);

% Initialization of vector d
d_x = d_x0;
d_y = d_y0;

for i=1:k
    
    I_prev = interp2(I1, x_0 + d_x, y_0 + d_y, 'linear', 0);
    % Compute A
    A1 = interp2(A1_0, x_0 + d_x, y_0 + d_y, 'linear', 0);
    A2 = interp2(A2_0, x_0 + d_x, y_0 + d_y, 'linear', 0);
    E = I2 - I_prev;
    
    % Compute b
    b11 = imfilter(A1.^2, G_r, 'symmetric') + epsilon;
    b12 = imfilter(A1.*A2, G_r, 'symmetric');
    b22 = imfilter(A2.^2, G_r, 'symmetric') + epsilon;
    
    % Compute c
    c1 = imfilter(A1.*E, G_r, 'symmetric');
    c2 = imfilter(A2.*E, G_r, 'symmetric');

    % Compute u
    det = b11 .* b22 - b12.^2;
    u_x = (b22.*c1 - b12.*c2)./det;
    u_y = (-b12.*c1 + b22.*c2)./det;

    % Update d
    d_x = d_x + u_x;
    d_y = d_y + u_y;

    %if (norm(ux)<thr && norm(uy)<thr)
    %   break;
    %end
end


end

