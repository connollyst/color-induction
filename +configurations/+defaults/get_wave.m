function wave = get_wave()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% wavelets' parameters %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    wave.multires  = 'DWD_orient_undecimated';  % decomposition choice
    wave.n_orients = 3;     % number of orientations
    wave.n_scales  = 0;     % number of scales (if 0: code calculates it automatically)
    wave.mida_min  = 32;    % size of the last wavelet plane to process (Should be a power of 2 and >= 32)
                            % (see below zli.fin_scale_offset parameter in order to include or not residual plane)
end