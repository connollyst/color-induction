function [x_out, y_out] = update_xy(tIitheta, x, y, JW, norm_mask, interactions, config)
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

    [gx_padded, gy_padded] = model.utils.padding.add(x, y, interactions, config);
    [x_ee, x_ei, y_ie]     = model.utils.get_excitation_and_inhibition(gx_padded, gy_padded, JW, interactions, config);
    I_norm                 = model.utils.normalize_output(norm_mask, gx_padded, interactions, config);
    [x_out, y_out]         = model.terms.get_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config);
    
    if config.display.plot
        do_plot(x, y, gx_padded, gy_padded, x_ee, x_ei, y_ie, I_norm, x_out, y_out);
    end
end

function do_plot(x_in, y_in, gx_padded, gy_padded, x_ee, x_ei, y_ie, I_norm, x_out, y_out)
    figure(1);
    subplot(10,1,1); imagesc(x_in(:,:));
    title(get_title('x in',x_in));
    subplot(10,1,2); imagesc(y_in(:,:));
    title(get_title('y in',y_in));
    subplot(10,1,3); imagesc(gx_padded{2}(:,:));
    title(get_title('gx padded #2',gx_padded{2}));
    subplot(10,1,4); imagesc(gy_padded{2}(:,:));
    title(get_title('gy padded #2',gy_padded{2}));
    subplot(10,1,5); imagesc(x_ee(:,:));
    title(get_title('x ee',x_ee));
    subplot(10,1,6); imagesc(x_ei(:,:));
    title(get_title('x ei',x_ei));
    subplot(10,1,7); imagesc(y_ie(:,:));
    title(get_title('y ie',y_ie));
    subplot(10,1,8); imagesc(I_norm(:,:));
    title(get_title('I norm',I_norm));
    subplot(10,1,9); imagesc(x_out(:,:));
    title(get_title('x out',x_out));
    subplot(10,1,10); imagesc(y_out(:,:));
    title(get_title('y out',y_out));
    %drawnow
    waitforbuttonpress;
end

function t = get_title(name, data)
    t = [name,' (range: [',num2str(min(data(:))),',',num2str(max(data(:))),'])'];
end