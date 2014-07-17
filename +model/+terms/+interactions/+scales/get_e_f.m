function [e, f] = get_e_f(scale_interaction)
    if scale_interaction > 1 || scale_interaction < 0
        error(['border_weights only handle scale_interaction of 1 or 0,' ...
               ' scale_interaction is %i'], scale_interaction);
    end
    if scale_interaction == 1
        e = 0.01;
        f = 1;
    end
    if scale_interaction == 0
        e = 0;
        f = 1;
    end
end