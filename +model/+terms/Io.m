function io = Io(I_norm, config)
%MODEL.TERMS.IO Spontaneous firing rate & neural noise.
%               p.209, Li 1999
    io = 0.85 + I_norm + model.terms.Inoise(config);
end

