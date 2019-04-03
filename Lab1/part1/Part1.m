%%%                             Part1:
%%%            Theme: Edge Detection in grayscale Images
close all;
clear all;
%---------------------------   1.1 Create Input Images ---------------------%
%1.1.1 read file
I0 = imread('./cv19_lab1_parts1_2_material/edgetest_19.png');
I0=im2double(I0);
imshow(I0);

%1.1.2 Add_Noise(I,PSNR) gaussian distribution
J1=AddNoise(I0,10);
J2=AddNoise(I0,20);
%imshow(J2);

%----------   1.2 EdgeDetect(I,sigma,theta_edge,LaplacType)  ---------------------%
I=J1;
sigma=3;
theta_edge=0.2;
LaplacType=0;
D= EdgeDetect(I,sigma,theta_edge,LaplacType);
%imshow(D);
    
%------------  1.3 Results Evaluation   ---------------------%

%1.3.1 Detection of REAL edges

B=strel('diamond',1);
M = imdilate(I0,B) - imerode(I0,B);
T = M > theta_edge;
imshow(T);

%1.3.2 EdgeDetectionScore(noiseImage,clearImage)
noiseImage=D;
clearImage=T;
C=EdgeDetectionScore(noiseImage,clearImage);
