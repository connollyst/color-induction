function [wavelets, residuals] = dwt(image, config)
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
    
    I_cols     = size(image, 1);
    I_rows     = size(image, 2);
    I_channels = size(image, 3);
    n_scales   = config.wave.n_scales;
    n_orients  = 3;     % horizontal, diagonal, & vertical
    
    wavelets   = zeros(I_cols, I_rows, I_channels, n_scales, n_orients);
    residuals  = zeros(I_cols, I_rows, I_channels, n_scales);
    
    for s = 1:n_scales
        orig_image   = image;
        inv_sum      = 1/sum(h);
        % Decimate image along horizontal direction
        prod         = model.data.decomposition.functions.utils.symmetric_filtering(image, h)  * inv_sum; % blur
        HF           = prod;
        GF           = image - prod;                                                                % horizontal frequency info
        % Decimate image along vertical direction   
        prod         = model.data.decomposition.functions.utils.symmetric_filtering(image, h') * inv_sum; % blur
        GHF          = image - prod;                                                                % vertical wavelet plane
        % Decimate GF along vertical direction
        HGF          = model.data.decomposition.functions.utils.symmetric_filtering(HF, h')    * inv_sum; % blur
        % Save horizontal and vertical wavelet planes
        wavelets(:,:,:,s,1) = GF;
        wavelets(:,:,:,s,2) = GHF;
        % Create and save wavelet plane
        DF           = orig_image - (HGF + GF + GHF);
        wavelets(:,:,:,s,3) = DF;
        % Save residual
        C            = image - (wavelets(:,:,:,s,1) + wavelets(:,:,:,s,2) + wavelets(:,:,:,s,3));
        residuals(:,:,:,s)   = C;
        % Update image to be used at next scale
        image        = C;
        % Upsample filter
        h            = [0 upsample(h,2)];
    end
    % TODO initialize the orientations in their correct positions
    wavelets(:,:,:,:,[2,3]) = wavelets(:,:,:,:,[3,2]);
end

