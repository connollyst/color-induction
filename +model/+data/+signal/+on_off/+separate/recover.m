function final = recover(ON_in, OFF_in, ON_out, OFF_out, config)
    n_membr   = config.zli.n_membr;
    ON_final  = cell(n_membr, 1);
    OFF_final = cell(n_membr, 1);
    final     = cell(n_membr, 1);
    iFactor = ON_out;
    for t=1:n_membr
        ON_final{t}  =  ON_in{t}   .* ON_out{t}  * config.zli.normal_output;
        OFF_final{t} = -OFF_in{t}  .* OFF_out{t} * config.zli.normal_output;
        iFactor{t}   =  ON_out{t}   + OFF_out{t};
        final{t}     =  ON_final{t} + OFF_final{t};
    end
end