function [wavelets, residuals] = DWD_and_a_trous(image, scales)
%DWD_AND_A_TROUS Combined DWD_orient_undecimated and a_trous tranforms.
    [dwd_wavelets, dwd_residuals] = model.data.wavelet.functions.DWD_orient_undecimated(image, scales);
    [at_wavelets,  at_residuals]  = model.data.wavelet.functions.a_trous(image, scales);
    wavelets  = {dwd_wavelets;  at_wavelets};
    residuals = {dwd_residuals; at_residuals};
end

