%%%                             Part1:
%%%            Theme: Edge Detection in grayscale Images
close all;
clear all;
%---------------------------   1.1 Create Input Images ---------------------%
%1.1.1 read file
I0 = imread('../cv19_lab1_parts1_2_material/edgetest_19.png');
I0=im2double(I0);
%imshow(I0);

%1.1.2 Add_Noise(I,PSNR) gaussian distribution
J1=AddNoise(I0,20);
J2=AddNoise(I0,10);
%imshow(J2);

%----------   1.2 EdgeDetect(I,sigma,theta_edge,LaplacType)  ---------------------%
I=J1;
sigma=4;
theta_edge=0.1;
LaplacType=1;
D= EdgeDetect(I,sigma,theta_edge,LaplacType);
%imshow(Is);
    
%------------  1.3 Results Evaluation   ---------------------%

%1.3.1 Detection of REAL edges

B=strel('diamond',1);
M = imdilate(I0,B) - imerode(I0,B);
T = M > theta_edge;
%imshow(T);

%1.3.2 EdgeDetectionScore(noiseImage,clearImage)
noiseImage=D;
clearImage=T;
C=EdgeDetectionScore(noiseImage,clearImage);

%%-------C(sigma,theta_edge)  -------------------
%{
% Description : We examine for cases
%  
% 1. *_0_J1  means 0:Linear Method - J1: J1 image(PSNR=20dB)
% 2. *_0_J2  means 0:Linear Method - J2: J2 image(PSNR=10dB)
% 3. *_1_J1  means 0:Morphological filters - J1: J1 image(PSNR=20dB)
% 4. *_1_J2  means 0:Morphological filters - J2: J2 image(PSNR=10dB)

sigma_Axis=0.1:0.1:4;
theta_edge_Axis=0.02:0.02:0.8;

for i=1:40
    for j=1:40
        D_axis_0_J1=EdgeDetect(J1,sigma_Axis(i),theta_edge_Axis(j),0);
        D_axis_0_J2=EdgeDetect(J2,sigma_Axis(i),theta_edge_Axis(j),0);
        D_axis_1_J1=EdgeDetect(J1,sigma_Axis(i),theta_edge_Axis(j),1);
        D_axis_1_J2=EdgeDetect(J2,sigma_Axis(i),theta_edge_Axis(j),1);

        C_Axis_0_J1(i,j)=EdgeDetectionScore(D_axis_0_J1,clearImage);
        C_Axis_0_J2(i,j)=EdgeDetectionScore(D_axis_0_J2,clearImage); 
        C_Axis_1_J1(i,j)=EdgeDetectionScore(D_axis_1_J1,clearImage);
        C_Axis_1_J2(i,j)=EdgeDetectionScore(D_axis_1_J2,clearImage); 
    end
end
%------ Max values in each function -------------
MAX_C(1)=max(max(C_Axis_0_J1));
MAX_C(2)=max(max(C_Axis_0_J2));
MAX_C(3)=max(max(C_Axis_1_J1));
MAX_C(4)=max(max(C_Axis_1_J2));

%------ Max values' possition in matrix ---------

[i1,j1]=find(C_Axis_0_J1==MAX_C(1));
[i2,j2]=find(C_Axis_0_J2==MAX_C(2));
[i3,j3]=find(C_Axis_1_J1==MAX_C(3));
[i4,j4]=find(C_Axis_1_J2==MAX_C(4));

%---------------- plots -------------------------

subplot(2,2,1); surf(theta_edge_Axis,sigma_Axis,C_Axis_0_J1); title('PSNR=20dB ,Linear Method');
subplot(2,2,2); surf(theta_edge_Axis,sigma_Axis,C_Axis_0_J2); title('PSNR=10dB ,Linear Method');
subplot(2,2,3); surf(theta_edge_Axis,sigma_Axis,C_Axis_1_J1); title('PSNR=20dB ,Morphological Filters');
subplot(2,2,4); surf(theta_edge_Axis,sigma_Axis,C_Axis_1_J2); title('PSNR=10dB ,Morphological Filters');

print -deps2 C_function.eps

%------ 4x3 Matrix with   Max , sigma , theta_edge as columns and
%------ 4 rows for each case C_Axis_0_J1 ,C_Axis_0_J2 ,C_Axis_1_J1 ,C_Axis_1_J2

Stats=[MAX_C(1) sigma_Axis(i1) theta_edge_Axis(j1); MAX_C(2) sigma_Axis(i2) theta_edge_Axis(j2);MAX_C(3) sigma_Axis(i3) theta_edge_Axis(j3); MAX_C(4) sigma_Axis(i4) theta_edge_Axis(j4) ];

%}
