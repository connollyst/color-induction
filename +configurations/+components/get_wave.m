function wave = get_wave()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% wavelets' parameters %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    wave.transform    = '???';  % decomposition function
                                %  (corresponds to function in model.wavelet.functions)
                                
    wave.n_orients    = 4;      % number of orientations
                                %  (3 double opponent and 1 single opponent)
                                
    wave.n_scales     = 0;      % number of decompositon scales
                                %  (if 0: code calculates it automatically)
                                
    wave.mida_min     = 32;     % size of the last wavelet plane to process (Should be a power of 2 and >= 32)
                                %  (see zli.fin_scale_offset parameter in order to include or not residual plane)
end