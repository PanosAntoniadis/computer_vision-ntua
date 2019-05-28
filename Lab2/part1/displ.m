function [displ_x, displ_y] = displ(d_x, d_y, threshold)

% Compute energy of speed vector
d = d_x.^2 + d_y.^2;

% Apply threshold to speed vector
index = (d >= threshold);
d_x(~index) = 0;
d_y(~index) = 0;


displ_x = sum(sum(d_x)) ./ sum(sum(index));
displ_y = sum(sum(d_y)) ./ sum(sum(index));






end