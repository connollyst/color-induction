function [x_out, y_out] = update_xy(tIitheta, x, y, norm_mask, interactions, config, varargin)
%MODEL.UPDATE_XY Update the excitatiory (x) and inhibitory (y) membrane potentials
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

    gx             = model.terms.gx(x);
    gy             = model.terms.gy(y);
    gx_padded      = model.data.padding.add(gx, interactions, config);
    gy_padded      = model.data.padding.add(gy, interactions, config);
    x_ei           = model.terms.x_ei(gy_padded, interactions, config);
    x_ee           = model.terms.x_ee(gx_padded, interactions, config);
    y_ie           = model.terms.y_ie(gx_padded, interactions, config);
    I_norm         = model.terms.Inormalization(norm_mask, gx_padded, interactions.scale, config);
    [x_out, y_out] = model.terms.xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config);
    
    if config.display.plot
        if nargin > 6
            title = varargin{1};
        else
            title = 'update xy';
        end
        do_plot(title, x, y, x_ee, x_ei, y_ie, I_norm, x_out, y_out, config);
    end
end

function do_plot(title, x_in, y_in, x_ee, x_ei, y_ie, I_norm, x_out, y_out, config)
    h = figure(1);
    set(h, 'Name', title);
    set(h, 'Color', [1 1 1]);
    set(h, 'NumberTitle', 'off');
    subplot(8,1,1); imagesc(x_in(:,:));   subplot_title('x in',   x_in);
    subplot(8,1,2); imagesc(y_in(:,:));   subplot_title('y in',   y_in);
    subplot(8,1,3); imagesc(x_ei(:,:));   subplot_title('x ei',   x_ei);
    subplot(8,1,4); imagesc(x_ee(:,:));   subplot_title('x ee',   x_ee);
    subplot(8,1,5); imagesc(y_ie(:,:));   subplot_title('y ie',   y_ie);
    subplot(8,1,6); imagesc(I_norm(:,:)); subplot_title('I norm', I_norm);
    subplot(8,1,7); imagesc(x_out(:,:));  subplot_title('x out',  x_out);
    subplot(8,1,8); imagesc(y_out(:,:));  subplot_title('y out',  y_out);
    if config.display.play
        drawnow
    else
        waitforbuttonpress;
    end
end

function subplot_title(name, data)
    title([name,' (range: [',num2str(min(data(:))),',',num2str(max(data(:))),'])']);
end