function interactions = get_interactions(Delta, config)
%INTERACTION_MAP Define the interaction maps used to define incluences
%   Detailed explanation goes here
    
    interactions = struct;
    
    % Orientation interaction limits
    a      = pi/4;
    b      = pi/2;
    Dtheta = [0 a b; a 0 a ; b a 0];
    interactions.PsiDtheta = Psi(Dtheta);
    
    % scale_distance: the distance of interractions between the scales
    scale_distance = 1;
    if scale_distance > 1
        disp('Warning: border_weights only handle scale_distance=1 and here scale_distance > 1!');
    end
    interactions.scale_distance = scale_distance;
    
    if config.zli.scale_interaction == 1
        e = 0.01;
        f = 1;
    else
        e = 0;
        f = 1;
    end
    interactions.border_weight = model.get_border_weights(e, f);
    
    n_scales      = config.wave.n_scales;
    Delta_ext     = zeros(1, n_scales+scale_distance*2);
    Delta_ext(scale_distance+1:n_scales+scale_distance)            = Delta;
    Delta_ext(1:scale_distance)                                    = Delta(1);
    Delta_ext(n_scales+scale_distance+1:n_scales+scale_distance*2) = Delta(n_scales);
    interactions.Delta_ext = Delta_ext;

    % Filter used to apply weights to scale interactions
    weight_scales = [e f e];
    interactions.scale_filter             = zeros(1, 1, 1, 1+2*scale_distance, 1);
    interactions.scale_filter(1, 1, 1, :, 1) = weight_scales;
    
    % TODO what is this??
    interactions.half_size_filter = get_half_size_filter(n_scales, scale_distance, Delta);
end

function psi = Psi(Dtheta)
    psi = cos(abs(Dtheta)).^6;
end

function half_size_filter = get_half_size_filter(n_scales, scale_distance, Delta)
    half_size_filter = cell(n_scales,1);
    for s=1:n_scales
        if scale_distance >0
            half_size_filter{s} = [Delta(s) Delta(s) 0];
        end
    end
end

