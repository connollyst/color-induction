function ic = Ic(config)
%MODEL.TERMS.IC Spontaneous firing rate & neural noise.
%               p.209, Li 1999
    ic = 1.0  + model.terms.noise(config);
end

