function [d_x,d_y] = multi_lk(I1, I2,rho, epsilon, d_x0, d_y0,scales)
%{
	multi_lk - MultiScale Lucas-Kanade algorithm

 	Usage:
         [d_x,d_y] = lk(I1, I2, rho, epsilon, d_x0, d_y0,scales)
 
 	Description:
	Computes the optical flow between two images.
 
 	In:
  		I1, I2: input images
  		rho: standard deviation of Gaussian
  		epsilon: parameter 
  		d_x0, d_y0: initialization of vector field d
  		scales: the number of gaussian pyramid layers

 	Out:
   		d_x, d_y: vector field d
%}

	I1_curr{1}=I1;
	I2_curr{1}=I2;

	% Gaussian pyramid construction for I1 , I2 
	for i=2:scales
	    I1_curr{i} = impyramid(I1_curr{i-1},'reduce');
	    I2_curr{i} = impyramid(I2_curr{i-1},'reduce');
	end
	
	% initialization of optical flow d=[u,v]
	u=d_x0;
	v=d_y0;
	
	u=2*imresize(u,1/2^(scales));
	v=2*imresize(v,1/2^(scales));
	
	% compute lk in the highest level  
	[u,v]=lk(I1_curr{scales}, I2_curr{scales},rho, epsilon, u, v);

	for i=(scales-1):-1:1
    	u=2*imresize(u,2);
	    v=2*imresize(v,2);
	    [u,v]=lk(I1_curr{i},I2_curr{i},rho, epsilon, u, v);
	end

	d_x=u;
	d_y=v;

end
