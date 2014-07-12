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
        do_plot(gx_padded, gy_padded, x_ee, x_ei, y_ie, I_norm, x_out, y_out);
    end
end

function do_plot(gx_padded, gy_padded, x_ee, x_ei, y_ie, I_norm, x_out, y_out)
    figure(1);
    subplot(8,1,1); imagesc(gx_padded{2}(:,:));
    title('gx padded');
    subplot(8,1,2); imagesc(gy_padded{2}(:,:));
    title('gy padded');
    subplot(8,1,3); imagesc(x_ee(:,:));
    title('x ee');
    subplot(8,1,4); imagesc(x_ei(:,:));
    title('x ei');
    subplot(8,1,5); imagesc(y_ie(:,:));
    title('y ie');
    subplot(8,1,6); imagesc(I_norm(:,:));
    title('I norm');
    subplot(8,1,7); imagesc(x_out(:,:));
    title('x out');
    subplot(8,1,8); imagesc(y_out(:,:));
    title('y out');
    drawnow
    %waitforbuttonpress;
end