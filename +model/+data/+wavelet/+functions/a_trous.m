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
    
    I_cols     = size(image, 1);
    I_rows     = size(image, 2);
    I_channels = size(image, 3);
    
	wavelets   = zeros(I_cols, I_rows, I_channels, scales);
    residuals  = zeros(I_cols, I_rows, I_channels, scales);
    
    for s=1:scales
		inv_energy         = 1/sum(h(:));
		prod               = model.data.wavelet.functions.utils.symmetric_filtering(image, h) * inv_energy;  % blur
		wavelets(:,:,:,s)  = image - prod;
		residuals(:,:,:,s) = prod;
		image              = residuals(:,:,:,s);
		h                  = padarray(upsample(upsample(h,2)',2),[1 1],0,'pre')';                       % upsample filter
    end
end

