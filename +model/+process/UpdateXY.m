function [x_out, y_out] = UpdateXY(tIitheta, x, y, JW, norm_mask, interactions, config)
%UPDATEXY Update the excitatiory (x) and inhibitory (y) membrane potentials
%   tIitheta:       Cell array of new input stimulus.
%   x:              The current excitatory membrane potentials.
%   y:              The current inhibitory membrane potentials.
%   JW:             The excitation (J) and inhibition (W) connection masks.
%   norm_mask:      Normalized interaction mask. (TODO part of interactions?)
%   interactions:   Structure array defining the neuronal interactions.
%   config:         Structure array of general application configurations.
%
%   x_out:          The new excitatory membrane potentials.
%   y_out:          The new inhibitory membrane potentials.

    [gx_padded, gy_padded] = model.add_padding(x, y, interactions, config);
    [x_ee, x_ei, y_ie]     = model.get_excitation_and_inhibition(gx_padded, gy_padded, JW, interactions, config);
    I_norm                 = model.normalize_output(norm_mask, gx_padded, interactions, config);
    [x_out, y_out]         = model.calculate_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config);
    
    if config.display.plot
        figure(1);
        subplot(7,1,1); imagesc(gy(:,:));
        subplot(7,1,2); imagesc(x_ee(:,:));
        subplot(7,1,3); imagesc(x_ei(:,:));
        subplot(7,1,4); imagesc(y_ie(:,:));
        subplot(7,1,5); imagesc(I_norm(:,:));
        subplot(7,1,6); imagesc(x_out(:,:));
        subplot(7,1,7); imagesc(y_out(:,:));
        drawnow
        %waitforbuttonpress;
    end
end