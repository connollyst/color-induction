function x_ee = x_ee(gx, interactions, config)
%MODEL.TERMS.X_EE Calculate the excitatory and inhibitory terms.
%   Input
%       gx_padded:      the gx input data, padded to avoid edge effects
%       JW:             the struct of J and W interaction data
%       interactions:   the struct of interaction parameters
%       config:         the struct of algorithm configuration parameters
%   Output
%       x_ee: excitatory-excitatory term
    
    x_ee = model.terms.interactions.orients.apply_excitation(gx, interactions, config);
    x_ee = model.terms.interactions.colors.apply_excitation(x_ee, interactions.color, config);
    x_ee = model.terms.interactions.scales.apply_excitation(x_ee, interactions.scale, config);
end