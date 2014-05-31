function Iitheta = normalize_input(Iitheta, config)
%NORMALIZE_INPUT Normalize the input signal.
    for i=1:config.zli.n_membr;
        Iitheta_2 = Iitheta{i}(:,:,:,2);
        Iitheta{i}(:,:,:,2) = Iitheta{i}(:,:,:,3);
        Iitheta{i}(:,:,:,3) = Iitheta_2;
    end
    [Iitheta,~,~] = model.curv_normalization(Iitheta, config);
end

