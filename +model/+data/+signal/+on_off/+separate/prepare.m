function [ON, OFF] = prepare(I, config)
%MODEL.DATA.SIGNAL.ON_OFF.PREPARE
%   Prepare the input data for ON OFF signal processing.

    n_membr   = config.zli.n_membr;
    
    [ON, OFF] = deal(cell(size(I)));
    
    for t=1:n_membr
        index_OFF        =  I{t} <= 0;
        index_ON         =  I{t} >= 0;
        ON{t}            =  I{t};
        OFF{t}           = -I{t};
        ON{t}(index_OFF) = 0;
        OFF{t}(index_ON) = 0;
    end
end

