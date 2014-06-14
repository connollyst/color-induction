function Iitheta = normalize_input(Iitheta, config)
%NORMALIZE_INPUT Normalize the input signal.
%   Iitheta: the cell array of input signal data
%            each cell is a the signal at a membrane time step such that,
%            for example, Iitheta{1}(:,:,2,3) is the entire input signal at
%            the first time step, second scale, and third orientation.

    % Move the diagonal orientation to the middle orientation position
    % TODO move this up to the wavelet decomposition step!
    Iitheta([2,3],:,:) = Iitheta([3,2],:,:);
    
    [Iitheta,~,~] = model.curv_normalization(Iitheta, config);
end

