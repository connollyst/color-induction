function y_ie = y_ie(gx, interactions, config)
%MODEL.TERMS.Y_IE Calculate the excitatory and inhibitory terms.
%   Input
%       gx_padded:      the gx input data, padded to avoid edge effects
%       JW:             the struct of J and W interaction data
%       interactions:   the struct of interaction parameters
%       config:         the struct of algorithm configuration parameters
%   Output
%       y_ie: excitatory-inhibitory term
    
    y_ie = model.terms.interactions.orients.apply_inhibition(gx, interactions, config);
    y_ie = model.terms.interactions.colors.apply_inhibition(y_ie, interactions.color, config);
    y_ie = model.terms.interactions.scales.apply_inhibition(y_ie, interactions.scale, config);
end