function test_suite = test_apply_excitation
  initTestSuite;
end

%% TEST NO COLOR INTERACTIONS

function test_no_color_excitation_when_disabled
    % Given
    I_in   = little_pepperman();
    config = opponent_config(I_in);
    config.zli.interaction.color.enabled = false;
    color_interactions.excitation_filter = model.terms.interactions.colors.excitation_filter(config);
    % When
    I_out  = model.terms.interactions.colors.apply_excitation(I_in, color_interactions, config);
    % Then
    assertEqual(I_out, I_in);
end

function test_no_color_excitation_with_zero_weight
    % Given
    I_in         = little_pepperman();
    config       = opponent_config(I_in);
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.weight.excitation = 0;
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_excitation(I_in, interactions.color, config);
    % Then
    assertEqual(I_out, I_in);
end

%% TEST OPPONENT COLOR INTERACTIONS

function test_opponent_excitation_from_channel_1
    % Given
    I_in         = zeros(64,64,4);
    I_in(:,:,1)  = 1;
    config       = opponent_config(I_in);
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_excitation(I_in, interactions.color, config);
    % Then
    I_out_mean_1 = mean(mean(I_out(:,:,1)));
    I_out_mean_2 = mean(mean(I_out(:,:,2)));
    I_out_mean_3 = mean(mean(I_out(:,:,3)));
    I_out_mean_4 = mean(mean(I_out(:,:,4)));
    % Channel 1 should still be the most active
    assertTrue(I_out_mean_1 > I_out_mean_2);
    assertTrue(I_out_mean_1 > I_out_mean_3);
    assertTrue(I_out_mean_1 > I_out_mean_4);
    % Channel 2, it's oppenent, should be the least active
    assertTrue(I_out_mean_2 < I_out_mean_3);
    assertTrue(I_out_mean_2 < I_out_mean_4);
    % Channel 1 should have given some excitation to channels 3 & 4
    excitation_weight = config.zli.interaction.color.weight.excitation;
    assertElementsAlmostEqual(I_out_mean_1, (1 - (excitation_weight * 2)));
    assertElementsAlmostEqual(I_out_mean_2, 0);
    assertElementsAlmostEqual(I_out_mean_3, excitation_weight);
    assertElementsAlmostEqual(I_out_mean_4, excitation_weight);
end

function test_opponent_excitation_from_channel_2
    % Given
    I_in         = zeros(64,64,4);
    I_in(:,:,2)  = 1;
    config       = opponent_config(I_in);
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_excitation(I_in, interactions.color, config);
    % Then
    I_out_mean_1 = mean(mean(I_out(:,:,1)));
    I_out_mean_2 = mean(mean(I_out(:,:,2)));
    I_out_mean_3 = mean(mean(I_out(:,:,3)));
    I_out_mean_4 = mean(mean(I_out(:,:,4)));
    % Channel 1 should still be the most active
    assertTrue(I_out_mean_2 > I_out_mean_1);
    assertTrue(I_out_mean_2 > I_out_mean_3);
    assertTrue(I_out_mean_2 > I_out_mean_4);
    % Channel 2, it's oppenent, should be the least active
    assertTrue(I_out_mean_1 < I_out_mean_3);
    assertTrue(I_out_mean_1 < I_out_mean_4);
    % Channel 1 should have given some excitation to channels 3 & 4
    excitation_weight = config.zli.interaction.color.weight.excitation;
    assertElementsAlmostEqual(I_out_mean_1, 0);
    assertElementsAlmostEqual(I_out_mean_2, (1 - (excitation_weight * 2)));
    assertElementsAlmostEqual(I_out_mean_3, excitation_weight);
    assertElementsAlmostEqual(I_out_mean_4, excitation_weight);
end

function test_opponent_excitation_from_channel_3
    % Given
    I_in         = zeros(64,64,4);
    I_in(:,:,3)  = 1;
    config       = opponent_config(I_in);
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_excitation(I_in, interactions.color, config);
    % Then
    I_out_mean_1 = mean(mean(I_out(:,:,1)));
    I_out_mean_2 = mean(mean(I_out(:,:,2)));
    I_out_mean_3 = mean(mean(I_out(:,:,3)));
    I_out_mean_4 = mean(mean(I_out(:,:,4)));
    % Channel 1 should still be the most active
    assertTrue(I_out_mean_3 > I_out_mean_1);
    assertTrue(I_out_mean_3 > I_out_mean_2);
    assertTrue(I_out_mean_3 > I_out_mean_4);
    % Channel 2, it's oppenent, should be the least active
    assertTrue(I_out_mean_4 < I_out_mean_1);
    assertTrue(I_out_mean_4 < I_out_mean_2);
    % Channel 1 should have given some excitation to channels 3 & 4
    excitation_weight = config.zli.interaction.color.weight.excitation;
    assertElementsAlmostEqual(I_out_mean_1, excitation_weight);
    assertElementsAlmostEqual(I_out_mean_2, excitation_weight);
    assertElementsAlmostEqual(I_out_mean_3, (1 - (excitation_weight * 2)));
    assertElementsAlmostEqual(I_out_mean_4, 0);
end

function test_opponent_excitation_from_channel_4
    % Given
    I_in         = zeros(64,64,4);
    I_in(:,:,4)  = 1;
    config       = opponent_config(I_in);
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_excitation(I_in, interactions.color, config);
    % Then
    I_out_mean_1 = mean(mean(I_out(:,:,1)));
    I_out_mean_2 = mean(mean(I_out(:,:,2)));
    I_out_mean_3 = mean(mean(I_out(:,:,3)));
    I_out_mean_4 = mean(mean(I_out(:,:,4)));
    % Channel 1 should still be the most active
    assertTrue(I_out_mean_4 > I_out_mean_1);
    assertTrue(I_out_mean_4 > I_out_mean_2);
    assertTrue(I_out_mean_4 > I_out_mean_3);
    % Channel 2, it's oppenent, should be the least active
    assertTrue(I_out_mean_3 < I_out_mean_1);
    assertTrue(I_out_mean_3 < I_out_mean_2);
    % Channel 1 should have given some excitation to channels 3 & 4
    excitation_weight = config.zli.interaction.color.weight.excitation;
    assertElementsAlmostEqual(I_out_mean_1, excitation_weight);
    assertElementsAlmostEqual(I_out_mean_2, excitation_weight);
    assertElementsAlmostEqual(I_out_mean_3, 0);
    assertElementsAlmostEqual(I_out_mean_4, (1 - (excitation_weight * 2)));
end

%% UTILITIES

function config = opponent_config(I)
    config = common_config(I);
    config.zli.interaction.color.weight.excitation = 0.2;
    config.zli.interaction.color.weight.inhibition = 0.1;
end

function config = common_config(I)
    config = configurations.double_opponent();
    config.image.width                             = size(I, 1);
    config.image.height                            = size(I, 2);
    config.image.n_channels                        = size(I, 3);
    config.wave.n_scales                           = 1;
    config.display.plot                            = false;
    config.display.logging                         = false;
    config.zli.interaction.orient.enabled          = false;
    config.zli.interaction.scale.enabled           = false;
    config.zli.interaction.color.enabled           = true;
end