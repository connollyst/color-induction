function y_ie = apply_inhibition(y_ie, scale_interactions, config)
% Apply scale inhibition to the input signal.
% Note: Scale inhibition and excitation is the same model, just different
%       signal pathways.
    y_ie = model.terms.interactions.scales.apply(y_ie, scale_interactions, config);
end

