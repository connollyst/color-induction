function Iitheta = normalize_input(Iitheta, config)
%NORMALIZE_INPUT Normalize the input signal.
%   Iitheta: the cell array of input signal data
%            each cell is a the signal at a membrane time step such that,
%            for example, Iitheta{1}(:,:,2,3) is the entire input signal at
%            the first time step, second scale, and third orientation.

    if size(Iitheta{1}, 4) > 1
        % Normalize by orientations
        for i=1:config.zli.n_membr;
            Iitheta_2 = Iitheta{i}(:,:,:,2);
            Iitheta{i}(:,:,:,2) = Iitheta{i}(:,:,:,3);
            Iitheta{i}(:,:,:,3) = Iitheta_2;
        end
    end
    
    [Iitheta,~,~] = model.curv_normalization(Iitheta, config);
end

