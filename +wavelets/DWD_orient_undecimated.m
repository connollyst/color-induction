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
    w          = cell(3, scales);
    c          = cell(1, scales);
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
        w{1,s}     = GF;
        w{2,s}     = GHF;
        % Create and save wavelet plane
        DF         = orig_image - (HGF + GF + GHF);
        w{3,s}     = DF;
        % Save residual
        C          = image - (w{1,s} + w{2,s} + w{3,s});
        c{1,s}     = C;
        % Update image to be used at next scale
        image      = C;
        % Upsample filter
        h          = [0 upsample(h,2)];
    end
end

