function [wavelets, residuals] = DWD_orient_undecimated(image, scales)
% Implementation of Mallate Discrete Wavelet Transform.
%
% inputs:
%   image:  input image to be decomposed
%   scales: # of wavelet scales
%
% outputs:
%   wavelets: cell array of wavelet planes in 3 orientations
%   residuals: cell array of residual planes

    % 1D Gabor-like filter:
    h = [1./16., 1./4., 3./8., 1./4., 1./16.];

    energy     = sum(h);
    inv_energy = 1/energy;
    I_cols     = size(image, 1);
    I_rows     = size(image, 2);
    I_channels = size(image, 3);
    h          = h*inv_energy;
    wavelets   = zeros(I_cols, I_rows, I_channels, scales, 3);
    residuals  = zeros(I_cols, I_rows, I_channels, scales);
    for s = 1:scales
        orig_image   = image;
        inv_sum      = 1/sum(h);
        % Decimate image along horizontal direction
        prod         = model.wavelet.functions.utils.symmetric_filtering(image, h)  * inv_sum;	% blur
        HF           = prod;
        GF           = image - prod;                                                            % horizontal frequency info
        % Decimate image along vertical direction   
        prod         = model.wavelet.functions.utils.symmetric_filtering(image, h') * inv_sum;  % blur
        GHF          = image - prod;                                                            % vertical wavelet plane
        % Decimate GF along vertical direction
        HGF          = model.wavelet.functions.utils.symmetric_filtering(HF, h')    * inv_sum;  % blur
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

