
function [d_x,d_y] = lk(I1,I2,rho,epsilon,d_x0,d_y0)

I1=double(I1);
I2=double(I2);
k=10; %Define the times d is re-computed
thr=0.5

%Create the gaussian with standard deviation rho
n=(ceil(3*rho)*2)+1;
G_r=fspecial('gaussian',[n n],rho);

[x_0,y_0]=meshgrid(1:size(I1,2),1:size(I1,1));
[A1_0,A2_0]=gradient(I1);

dx=d_x0;
dy=d_y0;


for i=1:k
	I_prev=interp2(I1,x_0+dx,y_0+dy, 'linear', 0);
	A1=interp2(A1_0, x_0+dx, y_0+dy,'linear',0);
	A2=interp2(A2_0,x_0+dx, y_0+dy,'linear',0);
	E=I2-I_prev;
% U = (B.^-1)*C
	b11=imfilter(A1.^2,G_r,'symmetric')+epsilon;
	b12=imfilter(A1.*A2,G_r,'symmetric');
	b22=imfilter(A2.^2,G_r,'symmetric')+epsilon;
	B=[b11 b12; b12 b22];

	c1=imfilter(A1.*E,G_r,'symmetric');
	c2=imfilter(A2.*E,G_r,'symmetric');
	C=[c1 c2];

	U=(B.^-1).*C;
	ux=U(1);
	uy=U(2);

	dx=dx+ux;
	dy=dy+uy;
	
	%if (norm(ux)<thr && norm(uy)<thr)
	%   break;
	%end
end

d_x=dx;
d_y=dy;

end

