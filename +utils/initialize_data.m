function data = initialize_data(config)
%INITIALIZE_DATA Initialize an instance of the data structure we use.

    n_orients  = config.wave.n_orients;
    n_scales   = config.wave.n_scales;
    n_membr    = config.zli.n_membr;
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;
    
    data = cell(n_membr, 1);
    for t=1:n_membr
        data{t} = zeros(n_cols, n_rows, n_channels, n_scales, n_orients); 
    end
    
end