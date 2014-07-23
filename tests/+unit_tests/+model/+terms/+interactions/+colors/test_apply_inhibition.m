function test_suite = test_apply_inhibition
  initTestSuite;
end

%% TEST NO COLOR INTERACTIONS

function test_no_color_inhibition_when_disabled
    % Given
    I_in   = little_pepperman();
    config = opponent_config(I_in);
    config.zli.interaction.color.enabled = false;
    color_interactions.inhibition_filter = model.terms.interactions.colors.inhibition_filter(config);
    % When
    I_out  = model.terms.interactions.colors.apply_inhibition(I_in, color_interactions, config);
    % Then
    assertEqual(I_out, I_in);
end

function test_no_color_inhibition_with_zero_weight
    % Given
    I_in         = little_pepperman();
    config       = opponent_config(I_in);
    config.zli.interaction.color.weight.inhibition = 0;
    interactions = model.terms.get_interactions(config);
    I_padded     = model.data.padding.add.color(I_in, interactions.color, config);
    % When
    I_out        = model.terms.interactions.colors.apply_inhibition(I_padded, interactions.color, config);
    % Then
    assertEqual(I_out, I_in);
end

%% TEST COLOR OPPONENT INTERACTIONS

function test_opponent_color_inhibition_simple
% Apply opponent color inhibition to a 2D image.
% Assert that the two color channels inhibit each other as expected.
    % Given
    I_in         = little_pepperman();
    I_in         = I_in(:,:,[1,2]);     % Reduce to a 2D image
    config       = opponent_config(I_in);
    interactions = model.terms.get_interactions(config);
    I_padded     = model.data.padding.add.color(I_in, interactions.color, config);
    % When
    I_out        = model.terms.interactions.colors.apply_inhibition(I_padded, interactions.color, config);
    % Then
    I_expected   = convn(I_in, interactions.color.inhibition_filter, 'same');
    assertEqual(I_out, I_expected);
end

function test_opponent_color_inhibition_advanced
% Apply opponent color inhibition to a 4D image.
% Assert that the two pairs of channels (1 & 2, and 3 & 4) inhibit
% themselves, but that there is no inhibition between the pairs.
    % Given
    I_in         = little_pepperman();
    config       = opponent_config(I_in);
    interactions = model.terms.get_interactions(config);
    I_padded     = model.data.padding.add.color(I_in, interactions.color, config);
    % When
    I_out        = model.terms.interactions.colors.apply_inhibition(I_padded, interactions.color, config);
    % Then
    I_expected   = zeros(config.image.width, config.image.height, 4);
    I_expected(:,:,[1,2]) = model.data.convolutions.optima( ...
                    I_in(:,:,[1,2]), interactions.color.inhibition_filter, 0, 0 ...
                 );
    I_expected(:,:,[3,4]) = model.data.convolutions.optima( ...
                    I_in(:,:,[3,4]), interactions.color.inhibition_filter, 0, 0 ...
                 );
    assertEqual(I_out, I_expected);
end

%% UTILITIES

function config = opponent_config(I)
    config = common_config(I);
    config.zli.interaction.color.weight.excitation = 0.5;
    config.zli.interaction.color.weight.inhibition = 0.2;
end

function config = common_config(I)
    config = configurations.double_opponent();
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
end

% Tests:
% assert no change if disabled
% assert no change if 'default'
% assert opponent pairs interact if 'opponent'
% - assert that pairs do interact
% - assert that non-pairs don't interact