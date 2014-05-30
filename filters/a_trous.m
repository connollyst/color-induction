function [w c] = a_trous(image, wlev)
% Implementation of Mallate Discrete Wavelet Transform.
%
% outputs:
%   w: cell array of length wlev, containing wavelet planes in 3
%   orientations.
%   c: cell array of length c, containing residual planes.
%
% inputs:
%   image: input image to be decomposed.
%   wlev: # of wavelet levels.

% pad image so that dimensions are powers of 2:
%image = add_padding(image);

% Defined 1D Gabor-like filter:
% h = [1./16.,1./4.,3./8.,1./4.,1./16.];

	h = [1.0/256.0,1.0/64.0,3.0/128.0,1.0/64.0,1.0/256.0;
			1.0/64.0,1.0/16.0,3.0/32.0,1.0/16.0,1.0/64.0;
			3.0/128.0,3.0/32.0,9.0/64.0,3.0/32.0,3.0/128.0;
			1.0/64.0,1.0/16.0,3.0/32.0,1.0/16.0,1.0/64.0;
			1.0/256.0,1.0/64.0,3.0/128.0,1.0/64.0,1.0/256.0];


	energy = sum(h(:));
	inv_energy = 1/energy;
	h = h*inv_energy;
	w = cell(wlev,1);
	c = cell(wlev,1);

	for s = 1:wlev

		inv_energy = 1/sum(h(:));

		 prod = symmetric_filtering(image, h)*inv_energy;          % blur

		 DF = image - prod;                                % wavelet plane

		 w{s,1} = DF;


		 % save residual
		 c{s,1} = prod;
		 image=c{s,1};

		% Upsample filter
		
% 		h = [0 upsample(h,2)];
		h = padarray(upsample(upsample(h,2)',2),[1 1],0,'pre')';

	end

end

