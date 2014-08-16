function wave = get_wave()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% wavelets' parameters %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    wave.transform    = 'opponent'; % decomposition function
                                    %  (corresponds to function in model.wavelet.functions)
                                    
    wave.n_orients    = 3;          % number of orientations
                                    %  (only applies to double opponent decompositions)
                                    
    wave.n_components = 4;          % number of decompositon components
                                    %  (eg: 1 single & 3 orientations = 4 components)
                                    
    wave.n_scales     = 0;          % number of decompositon scales
                                    % (if 0: code calculates it automatically)
                                    
    wave.mida_min     = 32;         % size of the last wavelet plane to process (Should be a power of 2 and >= 32)
                                    %  (see zli.fin_scale_offset parameter in order to include or not residual plane)
end