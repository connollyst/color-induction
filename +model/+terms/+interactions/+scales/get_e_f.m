function [e, f] = get_e_f(scale_interaction_distance)
    if scale_interaction_distance > 1 || scale_interaction_distance < 0
        error(['border_weights only handle scale_interaction of 1 or 0,' ...
               ' scale_interaction is %i'], scale_interaction_distance);
    end
    if scale_interaction_distance == 1
        e = 0.01;
        f = 1;
    end
    if scale_interaction_distance == 0
        e = 0;
        f = 1;
    end
end