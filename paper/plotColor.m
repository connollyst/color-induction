function plotColor
    I = im2double(imresize(imread('peppers.png'),0.2));
    % CONFIGURATION
    config = configurations.default;
    config.rf.so.enabled  = true;
    config.rf.do.enabled  = false;
    config.wave.n_orients = 1;
    config.wave.n_scales  = 3;
    % DECOMPOSE
    [wavelets, ~] = model.data.decomposition.functions.opponent(I, config);
    % PLOT
    figure(i);
    subplot(2,1,1), imagesc(wavelets(:,:,1,1,4));
    subplot(2,1,2), imagesc(wavelets(:,:,2,1,4));
end