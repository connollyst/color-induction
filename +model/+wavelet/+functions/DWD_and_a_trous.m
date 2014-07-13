function [wavelets, residuals] = DWD_and_a_trous(image, scales)
%DWD_AND_A_TROUS Summary of this function goes here
%   Detailed explanation goes here
    [dwd_wavelets, dwd_residuals] = model.wavelet.functions.DWD_orient_undecimated(image, scales);
    [at_wavelets,  at_residuals]  = model.wavelet.functions.a_trous(image, scales);
    wavelets = {dwd_wavelets;  at_wavelets};
    residuals = {dwd_residuals; at_residuals};
end

