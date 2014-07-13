function compute = get_compute()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% computational setting %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Use MATLAB workers (0:no, 1:yes)
    % compute.parallel          = 0;     % concurrent for every image
    % compute.parallel_channel  = 0;     % concurrent for every color channel
    % compute.parallel_scale    = 0;     % concurrent for every wavelet plane
    % compute.parallel_orient   = 0;     % concurrent for every wavelet orientation  
    % compute.parallel_ON_OFF   = 0;     % concurrent for ON & OFF processing
    % compute.multiparameters   = 0;     % 0 for the first parameter of the list/ 1 for all the parameters
    compute.use_fft             = 1;     % use fft for speed
    compute.avoid_circshift_fft = 1;    % avoid circshift for speed
    % compute.output_type       = 'image';
end