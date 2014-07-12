function [x_ee, x_ei, y_ie] = get_excitation_and_inhibition(gx_padded, gy_padded, JW, interactions, config)
%GET_EXCITATION_AND_INHIBITION
    
    % TODO x_ei is scale before orientation, x_ee and y_ie are the opposite
    
    x_ei         = model.terms.get_x_ei(gy_padded, interactions, config);
    [x_ee, y_ie] = model.terms.get_x_ee_y_ie(gx_padded, JW, interactions, config);

end



