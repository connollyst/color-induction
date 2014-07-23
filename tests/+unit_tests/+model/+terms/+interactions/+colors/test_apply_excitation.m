function test_suite = test_apply_excitation
  initTestSuite;
end

%% TEST NO COLOR INTERACTIONS

function test_no_color_excitation_when_disabled
    % Given
    I_in   = get_small_pepperman();
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
    I_in         = get_small_pepperman();
    config       = opponent_config(I_in);
    config.zli.interaction.color.weight.excitation = 0;
    interactions = model.terms.get_interactions(config);
    I_padded     = model.data.padding.add.color(I_in, interactions.color, config);
    % When
    I_out        = model.terms.interactions.colors.apply_excitation(I_padded, interactions.color, config);
    % Then
    assertEqual(I_out, I_padded);
end

%% TEST OPPONENT COLOR INTERACTIONS

function test_opponent_excitation
    % Given
    I_in         = get_small_pepperman();
    config       = opponent_config(I_in);
    interactions = model.terms.get_interactions(config);
    I_padded     = model.data.padding.add.color(I_in, interactions.color, config);
    % When
    I_out        = model.terms.interactions.colors.apply_excitation(I_padded, interactions.color, config);
    % Then
    I_expected   = convn(I_padded, interactions.color.excitation_filter, 'same');
    assertEqual(I_out, I_expected);
end

%% UTILITIES

function peppers = get_small_pepperman()
% Returns a small test image of represent an opponent color image
    peppers  = im2double(imresize(imread('peppers.png'), 0.1));
    man      = im2double(imresize(imread('cameraman.tif'), 0.1));
    man_cols = size(man, 1);
    man_rows = size(man, 2);
    peppers  = peppers(1:man_cols, 1:man_rows);
    peppers(:,:,4) = man;
end

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
    config.zli.interaction.color.enabled           = true;
end

% Tests:
% assert no change if disabled
% assert no change if 'default'
% assert opponent pairs interact if 'opponent'
% - assert that pairs do interact
% - assert that non-pairs don't interact