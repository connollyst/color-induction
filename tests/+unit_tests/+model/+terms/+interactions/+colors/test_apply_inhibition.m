function test_suite = test_apply_inhibition
  initTestSuite;
end

%% TEST NO COLOR INTERACTIONS

function test_no_color_inhibition_when_disabled
    % Given
    I_in   = little_pepperman();
    config = get_config(I_in);
    config.zli.interaction.color.enabled = false;
    color_interactions.inhibition_filter = model.terms.interactions.colors.inhibition_filter(config);
    % When
    I_out = model.terms.interactions.colors.apply_inhibition(I_in, color_interactions, config);
    % Then
    assertEqual(I_out, I_in);
end

function test_no_color_inhibition_with_zero_weight
    % Given
    I_in         = little_pepperman();
    config       = get_config(I_in);
    config.zli.interaction.color.weight.inhibition = 0;
    interactions = model.terms.get_interactions(config);
    % When
    I_out = model.terms.interactions.colors.apply_inhibition(I_in, interactions.color, config);
    % Then
    assertEqual(I_out, I_in);
end

%% TEST DEFAULT COLOR INHIBITION

function test_default_color_inhibition_simple
% Apply opponent color inhibition to a 2D image.
% Assert that the two color channels inhibit each other as expected.
    % Given
    I_in         = little_pepperman();
    I_in         = I_in(:,:,[1,2]);     % Reduce to a 2D image
    config       = get_config(I_in);
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.model             = 'default';
    config.zli.interaction.color.weight.excitation = 0.0;
    config.zli.interaction.color.weight.inhibition = 0.1;
    interactions = model.terms.get_interactions(config);
    % When
    I_out = model.terms.interactions.colors.apply_inhibition(I_in, interactions.color, config);
    % Then
    filter = interactions.color.inhibition_filter;
    I_expected   = convn(I_in, filter, 'same');
    assertEqual(I_out, I_expected);
end

function test_default_color_inhibition_advanced
% Apply opponent color inhibition to a 4D image.
% Assert that the two pairs of channels (1 & 2, and 3 & 4) inhibit
% themselves, but that there is no inhibition between the pairs.
    % Given
    I_in         = little_pepperman();
    config       = get_config(I_in);
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.model             = 'default';
    config.zli.interaction.color.weight.excitation = 0.0;
    config.zli.interaction.color.weight.inhibition = 0.1;
    interactions = model.terms.get_interactions(config);
    % When
    I_out = model.terms.interactions.colors.apply_inhibition(I_in, interactions.color, config);
    % Then
    filter = interactions.color.inhibition_filter;
    I_expected   = zeros(config.image.width, config.image.height, 4);
    I_expected(:,:,[1,2]) = model.data.convolutions.optimal(I_in(:,:,[1,2]), filter);
    I_expected(:,:,[3,4]) = model.data.convolutions.optimal(I_in(:,:,[3,4]), filter);
    assertEqual(I_out, I_expected);
end

%% TEST OPPONENT COLOR INHIBITION

function test_opponent_inhibition_from_channel_1
    % Given
    I_in         = zeros(64,64,4);
    I_in(:,:,1)  = 1;
    config       = get_config(I_in);
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.model             = 'opponent';
    config.zli.interaction.color.weight.excitation = 0.0;
    config.zli.interaction.color.weight.inhibition = 0.1;
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_inhibition(I_in, interactions.color, config);
    % Then channel 1 should have inhibited channel 2
    I_out_mean_1 = mean(mean(I_out(:,:,1)));
    I_out_mean_2 = mean(mean(I_out(:,:,2)));
    I_out_mean_3 = mean(mean(I_out(:,:,3)));
    I_out_mean_4 = mean(mean(I_out(:,:,4)));
    inhibition_weight = config.zli.interaction.color.weight.inhibition;
    assertElementsAlmostEqual(I_out_mean_1, 1);
    assertElementsAlmostEqual(I_out_mean_2, inhibition_weight);
    assertElementsAlmostEqual(I_out_mean_3, 0);
    assertElementsAlmostEqual(I_out_mean_4, 0);
end

function test_opponent_inhibition_from_channel_2
    % Given
    I_in         = zeros(64,64,4);
    I_in(:,:,2)  = 1;
    config       = get_config(I_in);
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.model             = 'opponent';
    config.zli.interaction.color.weight.excitation = 0.0;
    config.zli.interaction.color.weight.inhibition = 0.1;
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_inhibition(I_in, interactions.color, config);
    % Then channel 2 should have inhibited channel 1
    I_out_mean_1 = mean(mean(I_out(:,:,1)));
    I_out_mean_2 = mean(mean(I_out(:,:,2)));
    I_out_mean_3 = mean(mean(I_out(:,:,3)));
    I_out_mean_4 = mean(mean(I_out(:,:,4)));
    inhibition_weight = config.zli.interaction.color.weight.inhibition;
    assertElementsAlmostEqual(I_out_mean_1, inhibition_weight);
    assertElementsAlmostEqual(I_out_mean_2, 1);
    assertElementsAlmostEqual(I_out_mean_3, 0);
    assertElementsAlmostEqual(I_out_mean_4, 0);
end

function test_opponent_inhibition_from_channel_3
    % Given
    I_in         = zeros(64,64,4);
    I_in(:,:,3)  = 1;
    config       = get_config(I_in);
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.model             = 'opponent';
    config.zli.interaction.color.weight.excitation = 0.0;
    config.zli.interaction.color.weight.inhibition = 0.1;
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_inhibition(I_in, interactions.color, config);
    % Then channel 3 should have inhibited channel 4
    I_out_mean_1 = mean(mean(I_out(:,:,1)));
    I_out_mean_2 = mean(mean(I_out(:,:,2)));
    I_out_mean_3 = mean(mean(I_out(:,:,3)));
    I_out_mean_4 = mean(mean(I_out(:,:,4)));
    inhibition_weight = config.zli.interaction.color.weight.inhibition;
    assertElementsAlmostEqual(I_out_mean_1, 0);
    assertElementsAlmostEqual(I_out_mean_2, 0);
    assertElementsAlmostEqual(I_out_mean_3, 1);
    assertElementsAlmostEqual(I_out_mean_4, inhibition_weight);
end

function test_opponent_inhibition_from_channel_4
    % Given
    I_in         = zeros(64,64,4);
    I_in(:,:,4)  = 1;
    config       = get_config(I_in);
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.model             = 'opponent';
    config.zli.interaction.color.weight.excitation = 0.0;
    config.zli.interaction.color.weight.inhibition = 0.1;
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_inhibition(I_in, interactions.color, config);
    % Then channel 4 should have inhibited channel 3
    I_out_mean_1 = mean(mean(I_out(:,:,1)));
    I_out_mean_2 = mean(mean(I_out(:,:,2)));
    I_out_mean_3 = mean(mean(I_out(:,:,3)));
    I_out_mean_4 = mean(mean(I_out(:,:,4)));
    inhibition_weight = config.zli.interaction.color.weight.inhibition;
    assertElementsAlmostEqual(I_out_mean_1, 0);
    assertElementsAlmostEqual(I_out_mean_2, 0);
    assertElementsAlmostEqual(I_out_mean_3, inhibition_weight);
    assertElementsAlmostEqual(I_out_mean_4, 1);
end

%% UTILITIES

function config = get_config(I)
    config = configurations.default();
    config.image.width                             = size(I, 1);
    config.image.height                            = size(I, 2);
    config.image.n_channels                        = size(I, 3);
    config.wave.n_scales                           = 1;
    config.wave.n_orients                          = 1;
    config.display.plot                            = false;
    config.display.logging                         = false;
    config.zli.interaction.orient.enabled          = false;
    config.zli.interaction.scale.enabled           = false;
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.weight.excitation = 0.2;
    config.zli.interaction.color.weight.inhibition = 0.1;
end