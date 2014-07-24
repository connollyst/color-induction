function x_ee = apply_excitation(x_ee, scale_interactions, config)
% Apply scale excitation to the input signal.
% Note: Scale excitation and inhibition is the same model, just different
%       signal pathways.
    % TODO add scale padding?
    x_ee = model.terms.interactions.scales.apply(x_ee, scale_interactions, config);
end