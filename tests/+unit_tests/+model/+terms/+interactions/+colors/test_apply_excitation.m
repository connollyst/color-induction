function test_suite = test_apply_excitation
  initTestSuite;
end

%% TEST NO COLOR INTERACTIONS

function test_no_color_excitation_when_disabled
    % Given
    config.zli.interaction.color.enabled = false;
    color_interactions.excitation_filter = model.terms.interactions.colors.excitation_filter(config);
    I_in = get_small_peppers();
    % When
    I_out = model.terms.interactions.colors.apply_excitation(I_in, color_interactions, config);
    % Then
    assertEqual(I_out, I_in);
end

function test_equal_excitation_when_default
    % Given
    I_in = get_small_peppers();
    config = default_config(I_in);
    color_interactions.excitation_filter = model.terms.interactions.colors.excitation_filter(config);
    % When
    I_out = model.terms.interactions.colors.apply_excitation(I_in, color_interactions, config);
    % Then
    % TODO should be combinatorial pair-wise
    assertEqual(I_out, I_in);
end

%% UTILITIES

function small_peppers = get_small_peppers()
    peppers = imread('peppers.png');
    small_peppers = im2double(imresize(peppers, 0.1));
end

function config = default_config(I)
    config = common_config(I);
    config.zli.interaction.color.scheme            = 'default';
    config.zli.interaction.color.weight            = 0.5;
end

function config = opponent_config(I)
    config = common_config(I);
    config.zli.interaction.color.scheme            = 'opponent';
    config.zli.interaction.color.weight.excitation = 0.5;
end

function config = common_config(I)
    config.image.width                             = size(I, 1);
    config.image.height                            = size(I, 2);
    config.image.n_channels                        = size(I, 3);
    config.wave.n_scales                           = 1;
    config.wave.n_orients                          = 1;
    config.display.plot                            = false;
    config.display.logging                         = false;
    config.zli.interaction.color.enabled           = true;
end

% Tests:
% assert no change if disabled
% assert no change if 'default'
% assert opponent pairs interact if 'opponent'
% - assert that pairs do interact
% - assert that non-pairs don't interact