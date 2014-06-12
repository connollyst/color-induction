function [w, c] = DWD_orient_undecimated(image, scales)
% Implementation of Mallate Discrete Wavelet Transform.
%
% inputs:
%   image:  input image to be decomposed
%   scales: # of wavelet scales
%
% outputs:
%   w: cell array of wavelet planes in 3 orientations
%   c: cell array of residual planes

    % 1D Gabor-like filter:
    h = [1./16., 1./4., 3./8., 1./4., 1./16.];

    energy     = sum(h);
    inv_energy = 1/energy;
    h          = h*inv_energy;
    w          = cell(scales, 3);
    c          = cell(scales, 1);
    for s = 1:scales
        orig_image = image;
        inv_sum    = 1/sum(h);
        % Decimate image along horizontal direction
        prod       = wavelets.symmetric_filtering(image, h)  * inv_sum;	% blur
        HF         = prod;
        GF         = image - prod;                                      % horizontal frequency info
        % Decimate image along vertical direction   
        prod       = wavelets.symmetric_filtering(image, h') * inv_sum;	% blur
        GHF        = image - prod;                                      % vertical wavelet plane
        % Decimate GF along vertical direction
        HGF        = wavelets.symmetric_filtering(HF, h')    * inv_sum;	% blur
        % Save horizontal and vertical wavelet planes
        w{s,1}     = GF;
        w{s,2}     = GHF;
        % Create and save wavelet plane
        DF         = orig_image - (HGF + GF + GHF);
        w{s,3}     = DF;
        % Save residual
        C          = image - (w{s,1}(:,:,1)+w{s,1}(:,:,2)+w{s,1}(:,:,3));
        c{s,1}     = C;
        % Update image to be used at next scale
        image      = C;
        % Upsample filter
        h          = [0 upsample(h,2)];
    end
end

