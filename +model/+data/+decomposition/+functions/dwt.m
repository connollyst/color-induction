function [wavelets, residuals] = dwt(img, config)
    switch config.wave.n_orients
        case 1
            % Single opponent cells only:
            [wavelets, residuals] = single_opponent(img, config);
        case 3
            % Double opponent cells only:
            [wavelets, residuals] = double_opponent(img, config);
        case 4
            % Single & double opponent cells:
            [wavelets, residuals] = all_opponent(img, config);
        otherwise
            error(['Cannot decompose to ',num2str(n_orients),' DWT orientations.']);
    end
end

function [wavelets, residuals] = all_opponent(img, config)
% Implementation of Mallate Discrete Wavelet Transform.
%
% WHAT ARE THE WAVELET LAYERS?
% - DO 1 2 3
% - SO
%
% WHAT ARE THE RESIDUAL LAYERS?
% - Recovers the original image when the wavelets are added
% -- DO is removed every scale
% -- SO is not removed every scale
% -- THUS the last residual should have subtracted the SO of every scale 
%
% WHAT IS THE RECOVERY PROCESS?
% - Take the final residual
% - Add all SO and DO wavelet layers
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
    n_orients  = 4;     % horizontal, diagonal, vertical, & non-oriented
    
    wavelets   = zeros(I_cols, I_rows, I_channels, n_scales, n_orients);
    residuals  = zeros(I_cols, I_rows, I_channels, n_scales);
    
    % A running background to calculate the residual
    bg = zeros(I_cols, I_rows, I_channels);
    
    for s = 1:n_scales
        inv_sum = 1/sum(h);
        % Decimate image along horizontal direction
        prod    = filter(img, h)  * inv_sum;   % blur
        HF      = prod;
        GF      = img - prod;                  % horizontal frequency info
        % Decimate image along vertical direction   
        prod    = filter(img, h') * inv_sum;   % blur
        GHF     = img - prod;                  % vertical wavelet plane
        % Decimate GF along vertical direction
        HGF     = filter(HF, h')  * inv_sum;   % blur
        % Create and save wavelet plane
        DF      = img - (HGF + GF + GHF);
        % Save wavelet planes as double opponent signal
        DO      = GF + GHF + DF;
        % Save decomposition residual plane as single opponent signal
        SO      = img - DO;
        % The residual layer is the running background
        C       = bg;
        % Update image & background to be used at next scale
        img     = img - DO;    % remove the edge signal
        bg      = -SO + C;
        % Upsample filter
        h        = [0 upsample(h,2)];
    
        wavelets(:,:,:,s,1) = GF;
        wavelets(:,:,:,s,2) = DF;
        wavelets(:,:,:,s,3) = GHF;
        wavelets(:,:,:,s,4) = SO;
        residuals(:,:,:,s)  = C;
    end
end

function [wavelets, residuals] = single_opponent(img, config)
% Implementation of Mallate Discrete Wavelet Transform.
%
% WHAT ARE THE WAVELET LAYERS?
% - SO
%
% WHAT ARE THE RESIDUAL LAYERS?
% - Recovers the original image when the wavelets are added
% -- DO is removed every scale
% -- SO is not removed every scale
% -- THUS the last residual should have subtracted the SO of every scale
%         and __DO added back in__
%
% WHAT IS THE RECOVERY PROCESS?
% - Take the final residual
% - Add all SO wavelet layers
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
    
    wavelets   = zeros(I_cols, I_rows, I_channels, n_scales);
    residuals  = zeros(I_cols, I_rows, I_channels, n_scales);
    
    % A running background to calculate the residual
    bg = zeros(I_cols, I_rows, I_channels);
    
    for s = 1:n_scales
        inv_sum = 1/sum(h);
        % Decimate image along horizontal direction
        prod    = filter(img, h)  * inv_sum;   % blur
        HF      = prod;
        GF      = img - prod;                  % horizontal frequency info
        % Decimate image along vertical direction   
        prod    = filter(img, h') * inv_sum;   % blur
        GHF     = img - prod;                  % vertical wavelet plane
        % Decimate GF along vertical direction
        HGF     = filter(HF, h')  * inv_sum;   % blur
        % Create horizontal and vertical wavelet planes
        DF      = img - (HGF + GF + GHF);
        % Save wavelet planes as double opponent signal
        DO      = GF + GHF + DF;
        % Save residual plane as single opponent signal
        SO      = img - DO;
        % The real residual layers includes the background
        C       = bg + DO;
        % Update image & background to be used at next scale
        img     = img - DO; % remove the edge signal
        bg      = -SO + C;  % remove the wavelet and residual
        % Upsample filter
        h       = [0 upsample(h,2)];
        
        wavelets(:,:,:,s)  = SO;
        residuals(:,:,:,s) = C;
    end
end

function [wavelets, residuals] = double_opponent(img, config)
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
        inv_sum = 1/sum(h);
        % Decimate image along horizontal direction
        prod    = filter(img, h)  * inv_sum;   % blur
        HF      = prod;
        GF      = img - prod;                  % horizontal frequency info
        % Decimate image along vertical direction   
        prod    = filter(img, h') * inv_sum;   % blur
        GHF     = img - prod;                  % vertical wavelet plane
        % Decimate GF along vertical direction
        HGF     = filter(HF, h')  * inv_sum;   % blur
        % Create and save wavelet plane
        DF      = img - (HGF + GF + GHF);
        % Save residual
        C       = img - (GF + GHF + DF);
        % Update image to be used at next scale
        img     = C;
        % Upsample filter
        h       = [0 upsample(h,2)];
        
        wavelets(:,:,:,s,1) = GF;
        wavelets(:,:,:,s,2) = GHF;
        wavelets(:,:,:,s,3) = DF;
        residuals(:,:,:,s)  = C;
    end
    % TODO initialize the orientations in their correct positions
    wavelets(:,:,:,:,[2,3]) = wavelets(:,:,:,:,[3,2]);
end

function b = filter(a, h)
    b = model.data.decomposition.functions.utils.symmetric_filtering(a, h);
end