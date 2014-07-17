function [ON, OFF] = prepare(I, config)
%MODEL.DATA.ON_OFF.SEPARATE.PREPARE
%   Prepare the input data for separate ON OFF signal processing.
    [ON, OFF] = deal(cell(size(I)));
    for t=1:config.zli.n_membr
        index_OFF        =  I{t} <= 0;
        index_ON         =  I{t} >= 0;
        ON{t}            =  I{t};
        OFF{t}           = -I{t};
        ON{t}(index_OFF) = 0;
        OFF{t}(index_ON) = 0;
    end
end

