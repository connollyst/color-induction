function [w, c] = a_trous(image, scales)
% Implementation of A Trous wavelet transform
%
% inputs:
%   image: input image to be decomposed.
%   scales: # of wavelet levels.
%
% outputs:
%   w: cell array of wavelet planes.
%   c: cell array of residual planes.

	h = [1.0/256.0, 1.0/64.0, 3.0/128.0, 1.0/64.0, 1.0/256.0;
         1.0/64.0,  1.0/16.0, 3.0/32.0,  1.0/16.0, 1.0/64.0;
		 3.0/128.0, 3.0/32.0, 9.0/64.0,  3.0/32.0, 3.0/128.0;
		 1.0/64.0,  1.0/16.0, 3.0/32.0,  1.0/16.0, 1.0/64.0;
		 1.0/256.0, 1.0/64.0, 3.0/128.0, 1.0/64.0, 1.0/256.0];

	energy     = sum(h(:));
	inv_energy = 1/energy;
	h          = h*inv_energy;
	w          = cell(scales, 1);
	c          = cell(scales, 1);
    
    for s=1:scales
		inv_energy = 1/sum(h(:));
		prod   = wavelets.symmetric_filtering(image, h)*inv_energy;     % blur
		DF     = image - prod;                                          % wavelet plane
		w{s,1} = DF;
		c{s,1} = prod;  % Residual
		image  = c{s,1};
		h      = padarray(upsample(upsample(h,2)',2),[1 1],0,'pre')';   % Upsample filter
    end
end

