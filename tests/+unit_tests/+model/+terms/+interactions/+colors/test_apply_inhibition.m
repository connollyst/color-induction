function test_suite = test_apply_inhibition
  initTestSuite;
end

%% TEST NO COLOR INTERACTIONS

function test_no_color_inhibition_when_disabled
    % Given
    config = struct();
    config.zli.interaction.color.enabled = false;
    color_interactions = model.terms.interactions.colors.inhibition_filter(config);
    I_in = get_small_peppers();
    % When
    I_out = model.terms.interactions.colors.apply_inhibition(I_in, color_interactions, config);
    % Then
    assertEqual(I_out, I_in);
end

function test_no_color_inhibition_when_default
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'default';
    color_interactions = model.terms.interactions.colors.inhibition_filter(config);
    I_in = get_small_peppers();
    % When
    I_out = model.terms.interactions.colors.apply_inhibition(I_in, color_interactions, config);
    % Then
    assertEqual(I_out, I_in);
end

function test_opponent_color_inhibition_simple
% Apply opponent color inhibition to a 2D image.
% Assert that the two color channels inhibit each other as expected.
    % Given
    I_in = get_small_peppers();
    I_in = I_in(:,:,[1,2]);     % Reduce to a 2D image
    config = opponent_config(I_in);
    color_interactions.inhibition_filter = model.terms.interactions.colors.inhibition_filter(config);
    % When
    I_out = model.terms.interactions.colors.apply_inhibition(I_in, color_interactions, config);
    % Then
    I_expected = model.data.convolutions.optima( ...
                    I_in(:,:,:), color_interactions.inhibition_filter, 0, 0 ...
                 );
    assertEqual(I_out, I_expected);
end

function test_opponent_color_inhibition_advanced
% Apply opponent color inhibition to a 4D image.
% Assert that the two pairs of channels (1 & 2, and 3 & 4) inhibit
% themselves, but that there is no inhibition between the pairs.
    % Given
    I_in = get_small_peppers();
    I_in(:,:,4) = I_in(:,:,2);  % Bump up to a 4D image
    config = opponent_config(I_in);
    color_interactions.inhibition_filter = model.terms.interactions.colors.inhibition_filter(config);
    % When
    I_out = model.terms.interactions.colors.apply_inhibition(I_in, color_interactions, config);
    % Then
    I_expected = zeros(config.image.width, config.image.height, 4);
    I_expected(:,:,[1,2]) = model.data.convolutions.optima( ...
                    I_in(:,:,[1,2]), color_interactions.inhibition_filter, 0, 0 ...
                 );
    I_expected(:,:,[3,4]) = model.data.convolutions.optima( ...
                    I_in(:,:,[3,4]), color_interactions.inhibition_filter, 0, 0 ...
                 );
    assertEqual(I_out, I_expected);
end

%% UTILITIES

function small_peppers = get_small_peppers()
    peppers = imread('peppers.png');
    small_peppers = im2double(imresize(peppers, 0.1));
end

function config = opponent_config(I)
    config.image.width                             = size(I, 1);
    config.image.height                            = size(I, 2);
    config.image.n_channels                        = size(I, 3);
    config.wave.n_scales                           = 1;
    config.wave.n_orients                          = 1;
    config.display.plot                            = false;
    config.display.logging                         = false;
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.scheme            = 'opponent';
    config.zli.interaction.color.weight.inhibition = 0.5;
end

% Tests:
% assert no change if disabled
% assert no change if 'default'
% assert opponent pairs interact if 'opponent'
% - assert that pairs do interact
% - assert that non-pairs don't interact