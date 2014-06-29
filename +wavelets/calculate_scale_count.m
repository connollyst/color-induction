function n_scales = calculate_scale_count(I, config)
    if config.zli.fin_scale_offset == 0
        % parameter to adjust the correct number of the last wavelet plane (obsolete)
        % TODO if this is obsolete, can it be removed?
        extra = 1;
    else
        extra = 2;
    end
    mida_min = config.wave.mida_min;
    % TODO scales should be calculated using all colors/frames
    n_scales = floor(log(max(size(I{1}(:,:,1))-1)/mida_min)/log(2)) + extra;
end