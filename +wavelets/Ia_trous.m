function rec = Ia_trous(w, c)
    wlev = length(c);
    rec  = c{wlev,1};
    for s = wlev:-1:1
        rec = rec + w{s,1}(:,:);
    end
end
