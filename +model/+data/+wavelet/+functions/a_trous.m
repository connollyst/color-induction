function [wavelets, residuals] = a_trous(image, scales)
% Implementation of A Trous wavelet transform
%
% inputs:
%   image:  input image to be decomposed.
%   scales: # of wavelet levels.
%
% outputs:
%   wavelets:  cell array of wavelet planes.
%   residuals: cell array of residual planes.

	h = [1.0/256.0, 1.0/64.0, 3.0/128.0, 1.0/64.0, 1.0/256.0;
         1.0/64.0,  1.0/16.0, 3.0/32.0,  1.0/16.0, 1.0/64.0;
		 3.0/128.0, 3.0/32.0, 9.0/64.0,  3.0/32.0, 3.0/128.0;
		 1.0/64.0,  1.0/16.0, 3.0/32.0,  1.0/16.0, 1.0/64.0;
		 1.0/256.0, 1.0/64.0, 3.0/128.0, 1.0/64.0, 1.0/256.0];

	energy     = sum(h(:));
	inv_energy = 1/energy;
	h          = h*inv_energy;
	wavelets   = cell(scales, 1);
	residuals  = cell(scales, 1);
    
    for s=1:scales
		inv_energy     = 1/sum(h(:));
		prod           = model.data.wavelet.functions.utils.symmetric_filtering(image, h) * inv_energy;  % blur
		wavelets{s,1}  = image - prod;
		residuals{s,1} = prod;
		image          = residuals{s,1};
		h              = padarray(upsample(upsample(h,2)',2),[1 1],0,'pre')';                       % upsample filter
    end
end

