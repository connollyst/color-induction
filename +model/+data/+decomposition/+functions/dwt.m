function [wavelets, residuals] = dwt(img, config)
    switch config.wave.n_orients
        case 1
            % Single opponent cells only:
            %  The wavelet decomposition residual planes are the cell
            %  signals we want. The detail in the wavelet planes,
            %  representing stimulus to double opponent cells, is kept as
            %  the residuals used to reconstruct the output image.
            [activity, residuals] = decompose(img, config);
            [wavelets, residuals] = extract_so(residuals);
            do                    = sum(activity, 5);
            residuals             = residuals + do;
        case 3
            % Double opponent cells only:
            %  The wavelet signal serves as the double opponent cell input,
            %  the residuals are used to reconstruct the image afterwards.
            [wavelets, residuals] = decompose(img, config);
            [wavelets, residuals] = extract_do(wavelets, residuals);
        case 4
            % Single & double opponent cells:
            %  To process both single and double opponent cells
            %  simultaneously, we combine the wavelet planes (representing
            %  double opponent cell responses) with the wavelet residual
            %  planes (representing single opponent cell responses).
            [wavelets, residuals] = decompose(img, config);
            [so, residuals]       = extract_so(residuals);
            [do, residuals]       = extract_do(wavelets, residuals);
            wavelets              = cat(5, do, so);
        otherwise
            error(['Cannot decompose to ',num2str(n_orients),' DWT orientations.']);
    end
end

function [wavelets, residuals] = decompose(img, config)
% Implementation of Mallate Discrete Wavelet Transform.
%
% Input
%   image:      input image to be decomposed
%
% Output
%   wavelets:   wavelet planes in 3 orientations
%   residuals:  residual planes

    % 1D Gabor-like filter:
    h = [1./16., 1./4., 3./8., 1./4., 1./16.];

    energy     = sum(h);
    inv_energy = 1/energy;
    h          = h*inv_energy;
    
    I_cols     = size(img, 1);
    I_rows     = size(img, 2);
    I_channels = size(img, 3);
    n_scales   = config.wave.n_scales;
    n_orients  = 3;     % horizontal, diagonal, & vertical
    
    wavelets   = zeros(I_cols, I_rows, I_channels, n_scales, n_orients);
    residuals  = zeros(I_cols, I_rows, I_channels, n_scales);
    
    for s = 1:n_scales
        orig_image   = img;
        inv_sum      = 1/sum(h);
        % Decimate image along horizontal direction
        prod         = model.data.decomposition.functions.utils.symmetric_filtering(img, h)  * inv_sum; % blur
        HF           = prod;
        GF           = img - prod;                                                                % horizontal frequency info
        % Decimate image along vertical direction   
        prod         = model.data.decomposition.functions.utils.symmetric_filtering(img, h') * inv_sum; % blur
        GHF          = img - prod;                                                                % vertical wavelet plane
        % Decimate GF along vertical direction
        HGF          = model.data.decomposition.functions.utils.symmetric_filtering(HF, h')    * inv_sum; % blur
        % Save horizontal and vertical wavelet planes
        wavelets(:,:,:,s,1) = GF;
        wavelets(:,:,:,s,2) = GHF;
        % Create and save wavelet plane
        DF           = orig_image - (HGF + GF + GHF);
        wavelets(:,:,:,s,3) = DF;
        % Save residual
        C            = img - (wavelets(:,:,:,s,1) + wavelets(:,:,:,s,2) + wavelets(:,:,:,s,3));
        residuals(:,:,:,s)   = C;
        % Update image to be used at next scale
        img        = C;
        % Upsample filter
        h            = [0 upsample(h,2)];
    end
    % TODO initialize the orientations in their correct positions
    wavelets(:,:,:,:,[2,3]) = wavelets(:,:,:,:,[3,2]);
end

function [do, do_residuals] = extract_do(activity, residuals)
% The DWT includes both on and off activity for each channel. The double
% opponent (DO) signal is just the on component. The off component needs to
% be added back into the residuals.
    do           = model.data.utils.on(activity);
    activity_off = activity - do;
    do_residuals = residuals + sum(activity_off, 5);
end

function [so, so_residuals] = extract_so(do_residuals)
% The on component of the DWT residuals can be considered single opponent
% (SO) signal. As we take this signal we update the residuals to reflect
% the change.
    so           = model.data.utils.on(do_residuals);
    so_residuals = do_residuals - so;
end