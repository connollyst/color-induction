function wave = get_wave()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% wavelets' parameters %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    wave.transform = 'DWD_and_a_trous'; % decomposition function (see model.wavelet.README)
    wave.n_scales  = 0;                 % number of scales (if 0: code calculates it automatically)
    wave.n_orients = 3;                 % number of orientations
    wave.mida_min  = 32;                % size of the last wavelet plane to process (Should be a power of 2 and >= 32)
                                        % (see zli.fin_scale_offset parameter in order to include or not residual plane)
end