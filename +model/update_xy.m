function [x_out, y_out] = update_xy(tIitheta, x, y, norm_mask, interactions, config)
%PROCESS_UPDATE_XY Update the excitatiory (x) and inhibitory (y) membrane potentials
%   tIitheta:       Cell array of new input stimulus.
%   x:              The current excitatory membrane potentials.
%   y:              The current inhibitory membrane potentials.
%   JW:             The excitation (J) and inhibition (W) connection masks.
%   norm_mask:      Normalized interaction mask.
%   interactions:   Structure array defining the neuronal interactions.
%   config:         Structure array of general application configurations.
%
%   x_out:          The new excitatory membrane potentials.
%   y_out:          The new inhibitory membrane potentials.

    gx = model.terms.gx(x);
    gy = model.terms.gy(y);
    [gx_padded, gy_padded] = model.data.padding.add(gx, gy, interactions, config);
    [x_ee, x_ei, y_ie]     = model.terms.get_excitation_and_inhibition(gx_padded, gy_padded, interactions, config);
    I_norm                 = model.terms.normalization(norm_mask, gx_padded, interactions.scale, config);
    [x_out, y_out]         = model.terms.get_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config);
    
    if config.display.plot
        do_plot(x, y, x_ee, x_ei, y_ie, I_norm, x_out, y_out);
    end
end

function do_plot(x_in, y_in, x_ee, x_ei, y_ie, I_norm, x_out, y_out)
    figure(1);
    subplot(8,1,1); imagesc(x_in(:,:));   subplot_title('x in',   x_in);
    subplot(8,1,2); imagesc(y_in(:,:));   subplot_title('y in',   y_in);
    subplot(8,1,3); imagesc(x_ee(:,:));   subplot_title('x ee',   x_ee);
    subplot(8,1,4); imagesc(x_ei(:,:));   subplot_title('x ei',   x_ei);
    subplot(8,1,5); imagesc(y_ie(:,:));   subplot_title('y ie',   y_ie);
    subplot(8,1,6); imagesc(I_norm(:,:)); subplot_title('I norm', I_norm);
    subplot(8,1,7); imagesc(x_out(:,:));  subplot_title('x out',  x_out);
    subplot(8,1,8); imagesc(y_out(:,:));  subplot_title('y out',  y_out);
    drawnow
    %waitforbuttonpress;
end

function subplot_title(name, data)
    title([name,' (range: [',num2str(min(data(:))),',',num2str(max(data(:))),'])']);
end