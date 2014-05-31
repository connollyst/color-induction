function [radius_sc, scale_filter, border_weight, PsiDtheta, Delta_ext] = interaction_maps(Delta, config)
%INTERACTION_MAP Define the interaction maps used to define incluences
%   Detailed explanation goes here

    % orientations
    a         = pi/4;
    b         = pi/2;
    Dtheta    = [0 a b; a 0 a ; b a 0];
    PsiDtheta = model.terms.Psi(Dtheta);
    
    % scales (define the interraction between the scales)
    radius_sc       = 1;
    n_weight_scales = 1+2*radius_sc;
    weight_scales   = zeros(1, n_weight_scales);

    if config.zli.scale_interaction == 1
        e = 0.01;
        f = 1;
    else
        e = 0;
        f = 1;
    end

    weight_scales = [e f e];
    border_weight = model.get_border_weights(e, f);
    
    n_scales      = config.wave.n_scales;
    Delta_ext     = zeros(1, n_scales+radius_sc*2);
    Delta_ext(radius_sc+1:n_scales+radius_sc)            = Delta;
    Delta_ext(1:radius_sc)                               = Delta(1);
    Delta_ext(n_scales+radius_sc+1:n_scales+radius_sc*2) = Delta(n_scales);

    if radius_sc > 1
        disp('Warning: border_weights only handle radius_sc=1 and here radius_sc > 1!');
    end

    % define the filter
    scale_filter             = zeros(1, 1, 1+2*radius_sc, 1);
    scale_filter(1, 1, :, 1) = weight_scales;
end