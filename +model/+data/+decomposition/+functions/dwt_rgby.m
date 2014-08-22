function [signals, residuals] = dwt_rgby(rgb, config)
% Implementation of Mallate Discrete Wavelet Transform, tailored for RGB
% input and RGBY output.
%
% Input
%   rgb:        input rgb to be decomposed
%   config:     the model configuration struct array
%
% Output
%   signals:    wavelet planes (input to the model)
%   residuals:  residual planes (for output reconstruction)

    rgb  = im2double(rgb);
    rgby = rgb2rgby(rgb);
    switch config.wave.n_orients
        case 1
            % Single opponent cells only:
            %  The wavelet decomposition residual planes are the cell
            %  signals we want. The detail in the wavelet planes,
            %  representing stimulus to double opponent cells, is kept as
            %  the residuals used to reconstruct the output image.
            [residuals, signals] = model.data.decomposition.functions.dwt(rgby, config);
            % TODO residuals should be consolidated into 1 orientation, no?
        case 3
            % Double opponent cells only:
            %  The wavelet signal serves as the double opponent cell input,
            %  the residuals are used to reconstruct the image afterwards.
            [signals, residuals] = model.data.decomposition.functions.dwt(rgby, config);
        case 4
            % Single & double opponent cells:
            %  To process both single and double opponent cells
            %  simultaneously, we combine the wavelet planes (representing
            %  double opponent cell responses) with the wavelet residual
            %  planes (representing single opponent cell responses).
            [do, so]  = model.data.decomposition.functions.dwt(rgby, config);
            signals   = cat(5, do, so);
            residuals = zeros(size(so));  % TODO maybe there are residuals?
        otherwise
            error(['Cannot decompose to ',num2str(n_orients),' DWT orientations.']);
    end
end

function RGBY = rgb2rgby(rgb)
    n_cols     = size(rgb, 1);
    n_rows     = size(rgb, 2);
    n_channels = 4;             % RGBY
    n_scales   = size(rgb, 4);
    n_orients  = size(rgb, 5);
    RGBY = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);

    r = rgb(:,:,1,:,:);
    g = rgb(:,:,2,:,:);
    b = rgb(:,:,3,:,:);
    
    % TODO if we had rgb at scales, we could construct center surrounds
    R = r - (g + b)/2;
    G = g - (r + b)/2;
    B = b - (r + g)/2;
    Y = (r + g)/2 - abs(r - g)/2 - b;

    RGBY(:,:,1,:,:) = R;
    RGBY(:,:,2,:,:) = G;
    RGBY(:,:,3,:,:) = B;
    RGBY(:,:,4,:,:) = Y;
end