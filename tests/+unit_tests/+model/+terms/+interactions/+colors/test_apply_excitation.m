function test_suite = test_apply_excitation
  initTestSuite;
end

%% TEST NO COLOR INTERACTIONS

function test_no_color_excitation_when_disabled
    % Given
    I_in   = little_pepperman();
    config = get_config(I_in);
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
    config       = get_config(I_in);
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
    config       = get_config(I_in);
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.model             = 'opponent';
    config.zli.interaction.color.weight.excitation = 0.1;
    config.zli.interaction.color.weight.inhibition = 0.0;
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_excitation(I_in, interactions.color, config);
    % Then channel 2 should have excitated channels 3 & 4
    I_out_mean_1 = mean(mean(I_out(:,:,1)));
    I_out_mean_2 = mean(mean(I_out(:,:,2)));
    I_out_mean_3 = mean(mean(I_out(:,:,3)));
    I_out_mean_4 = mean(mean(I_out(:,:,4)));
    excitation_weight = config.zli.interaction.color.weight.excitation;
    assertElementsAlmostEqual(I_out_mean_1, 1);
    assertElementsAlmostEqual(I_out_mean_2, 0);
    assertElementsAlmostEqual(I_out_mean_3, excitation_weight);
    assertElementsAlmostEqual(I_out_mean_4, excitation_weight);
end

function test_opponent_excitation_from_channel_2
    % Given
    I_in         = zeros(64,64,4);
    I_in(:,:,2)  = 1;
    config       = get_config(I_in);
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.model             = 'opponent';
    config.zli.interaction.color.weight.excitation = 0.1;
    config.zli.interaction.color.weight.inhibition = 0.0;
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_excitation(I_in, interactions.color, config);
    % Then channel 2 should have excitated channels 3 & 4
    I_out_mean_1 = mean(mean(I_out(:,:,1)));
    I_out_mean_2 = mean(mean(I_out(:,:,2)));
    I_out_mean_3 = mean(mean(I_out(:,:,3)));
    I_out_mean_4 = mean(mean(I_out(:,:,4)));
    excitation_weight = config.zli.interaction.color.weight.excitation;
    assertElementsAlmostEqual(I_out_mean_1, 0);
    assertElementsAlmostEqual(I_out_mean_2, 1);
    assertElementsAlmostEqual(I_out_mean_3, excitation_weight);
    assertElementsAlmostEqual(I_out_mean_4, excitation_weight);
end

function test_opponent_excitation_from_channel_3
    % Given
    I_in         = zeros(64,64,4);
    I_in(:,:,3)  = 1;
    config       = get_config(I_in);
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.model             = 'opponent';
    config.zli.interaction.color.weight.excitation = 0.1;
    config.zli.interaction.color.weight.inhibition = 0.0;
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_excitation(I_in, interactions.color, config);
    % Then channel 3 should have excitated channels 1 & 2
    I_out_mean_1 = mean(mean(I_out(:,:,1)));
    I_out_mean_2 = mean(mean(I_out(:,:,2)));
    I_out_mean_3 = mean(mean(I_out(:,:,3)));
    I_out_mean_4 = mean(mean(I_out(:,:,4)));
    excitation_weight = config.zli.interaction.color.weight.excitation;
    assertElementsAlmostEqual(I_out_mean_1, excitation_weight);
    assertElementsAlmostEqual(I_out_mean_2, excitation_weight);
    assertElementsAlmostEqual(I_out_mean_3, 1);
    assertElementsAlmostEqual(I_out_mean_4, 0);
end

function test_opponent_excitation_from_channel_4
    % Given
    I_in         = zeros(64,64,4);
    I_in(:,:,4)  = 1;
    config       = get_config(I_in);
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.model             = 'opponent';
    config.zli.interaction.color.weight.excitation = 0.1;
    config.zli.interaction.color.weight.inhibition = 0.0;
    interactions = model.terms.get_interactions(config);
    % When
    I_out        = model.terms.interactions.colors.apply_excitation(I_in, interactions.color, config);
    % Then channel 4 should have excitated channels 1 & 2
    I_out_mean_1 = mean(mean(I_out(:,:,1)));
    I_out_mean_2 = mean(mean(I_out(:,:,2)));
    I_out_mean_3 = mean(mean(I_out(:,:,3)));
    I_out_mean_4 = mean(mean(I_out(:,:,4)));
    excitation_weight = config.zli.interaction.color.weight.excitation;
    assertElementsAlmostEqual(I_out_mean_1, excitation_weight);
    assertElementsAlmostEqual(I_out_mean_2, excitation_weight);
    assertElementsAlmostEqual(I_out_mean_3, 0);
    assertElementsAlmostEqual(I_out_mean_4, 1);
end

%% UTILITIES

function config = get_config(I)
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
    config.zli.interaction.color.weight.excitation = 0.2;
    config.zli.interaction.color.weight.inhibition = 0.1;
end