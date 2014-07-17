function [x_ee, x_ei, y_ie] = get_excitation_and_inhibition(gx_padded, gy_padded, interactions, config)
%GET_EXCITATION_AND_INHIBITION
    
    % TODO x_ei is scale before orientation, x_ee and y_ie are the opposite
    
    x_ei         = model.terms.get_x_ei(gy_padded, interactions.scale, config);
    [x_ee, y_ie] = model.terms.get_x_ee_y_ie(gx_padded, interactions, config);

end



