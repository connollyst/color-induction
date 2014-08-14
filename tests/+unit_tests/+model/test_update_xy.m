function test_suite = test_update_xy
  initTestSuite;
end

function test_no_color_excitation_with_zero_weight
    % Given
    [Iitheta, config]      = get_input();
    configA = config;
    configA.zli.interaction.color.enabled           = false;
    configB = config;
    configB.zli.interaction.color.enabled           = true;
    configB.zli.interaction.color.weight.excitation = 0;
    configB.zli.interaction.color.weight.inhibition = 0;
    tIitheta = Iitheta{1};
    % When
    [xA, ~] = update_xy(tIitheta, configA);
    [xB, ~] = update_xy(tIitheta, configB);
    % Then
    assertEqualData(xA, xB);
end

function test_no_color_inhibition_with_zero_weight
    % Given
    [Iitheta, config]      = get_input();
    configA = config;
    configA.zli.interaction.color.enabled           = false;
    configB = config;
    configB.zli.interaction.color.enabled           = true;
    configB.zli.interaction.color.weight.excitation = 0;
    configB.zli.interaction.color.weight.inhibition = 0;
    tIitheta = Iitheta{1};
    % When
    [~, yA] = update_xy(tIitheta, configA);
    [~, yB] = update_xy(tIitheta, configB);
    % Then
    assertEqualData(yA, yB);
end

function [x_out, y_out] = update_xy(tIitheta, config)
    norm_masks     = model.data.normalization.get_masks(config);
    interactions   = model.terms.get_interactions(config);
    x              = tIitheta;
    y              = model.utils.zeros(config);
    [x_out, y_out] = model.update_xy(tIitheta, x, y, norm_masks, interactions, config);
end

function [Iitheta, config] = get_input()
    I_in                   = little_peppers();
    I_in                   = lab2double(applycform(I_in, makecform('srgb2lab')));
    I_in                   = I_in(:,:,[1,2]);
    config                 = configurations.default();
    config.display.logging = false;
    config.display.plot    = false;
    config.image.transform = 'rgb';
    config.wave.n_scales   = 2;
    [Iitheta, ~, config]   = model.data.prepare_input(I_in, config);
end