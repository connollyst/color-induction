function final = recover(ON_OFF_in, ON_OFF_out, config)
    n_membr = config.zli.n_membr;
    final   = cell(n_membr, 1);
    for t=1:n_membr
        final{t} = ON_OFF_in{t} .* ON_OFF_out{t} * config.zli.normal_output;
    end
end

