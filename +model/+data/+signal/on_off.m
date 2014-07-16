function [on, off] = on_off(I, config)
%ON_OFF Summary of this function goes here
%   Detailed explanation goes here

    n_membr   = config.zli.n_membr;
    
    [on, off] = deal(cell(size(I)));
    
    for t=1:n_membr
        index_off        =  I{t} <= 0;
        index_on         =  I{t} >= 0;
        on{t}            =  I{t};
        off{t}           = -I{t};
        on{t}(index_off) = 0;
        off{t}(index_on) = 0;
    end

end

