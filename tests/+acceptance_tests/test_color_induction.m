function test_suite = test_color_induction
  initTestSuite;
end

function test_no_color_induction_with_zero_weights
% Setting the excitation & inhibition weights to 0 should be effectively
% the same as turning off interactions all together. Here we run both
% scenarios and expect the output to be the same.
    % Given
    I = little_peppers();
    config = configurations.double_opponent();
    config.display.logging                = false;
    config.display.plot                   = false;
    config.display.play                   = false;
    config.image.transform                = 'rgb2lab';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 3;
    config.zli.n_iter                     = 3;
    config.zli.ON_OFF                     = 'separate';
    configA = config;
    configA.zli.interaction.color.enabled = false;
    configB = config;
    configB.zli.interaction.color.enabled = true;
    configB.zli.interaction.color.weight.excitation = 0;
    configB.zli.interaction.color.weight.inhibition = 0;
    % When
    expected = model.apply(I, configA);
    actual   = model.apply(I, configB);
    % Then
    assertEqualData(expected, actual);
end

function test_opponent_color_excitation
    % Given
    I = synthetic_image() * 0.5;
    config = configurations.double_opponent();
    config.display.logging               = false;
    config.display.plot                  = false;
    config.display.play                  = false;
    config.image.transform               = 'rgb2lab';
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 5;
    config.zli.n_iter                    = 10;
    config.zli.ON_OFF                    = 'separate';
    config.zli.interaction.color.enabled = true;
    configA = config;
    configA.zli.interaction.color.weight.excitation = 0.0;
    configA.zli.interaction.color.weight.inhibition = 0.0;
    configB = config;
    configB.display.plot                  = true;
    configB.display.play                  = true;
    configB.zli.interaction.color.weight.excitation = 0.1;
    configB.zli.interaction.color.weight.inhibition = 0.0;
    % When
    [~, normal]  = model.apply(I, configA);
    [~, excited] = model.apply(I, configB);
    % Then
    % TODO these acceptance criteria aren't necessarily logical..
    %      why would we expect more extremes?
    %      what do we really expect when colors interact?
    %      filter_equal with a center of 1 gives this result, but that adds
    %      energy to the system, is that what we want??
    assertNegativesPeakLower(excited, normal);
    assertPositivesPeakHigher(excited, normal);
    % FAILS: current implementation is lacking somewhere
    assertNegativesAverageLower(excited, normal);
    assertPositivesAverageHigher(excited, normal);
end

function test_opponent_color_inhibition
    % Given
    I = synthetic_image() * 0.5;
    config = configurations.double_opponent();
    config.display.logging                = false;
    config.display.plot                   = false;
    config.display.play                   = false;
    config.image.transform                = 'rgb2lab';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 5;
    config.zli.n_iter                     = 10;
    config.zli.ON_OFF                     = 'separate';
    configB.zli.interaction.color.enabled = true;
    configA = config;
    configB.zli.interaction.color.weight.excitation = 0.0;
    configB.zli.interaction.color.weight.inhibition = 0.0;
    configB = config;
    configB.zli.interaction.color.weight.excitation = 0.0;
    configB.zli.interaction.color.weight.inhibition = 0.3;
    % When
    normal    = model.apply(I, configA);
    inhibited = model.apply(I, configB);
    % Then
    assertNegativesPeakLower(inhibited, normal);
    assertPositivesPeakHigher(inhibited, normal);
    % FAILS: current implementation is lacking somewhere
    assertNegativesAverageLower(inhibited, normal);
    assertPositivesAverageHigher(inhibited, normal);
end

function test_lightness_contrast
    % Given
    width = 48;
    A = test_image('lightness contrast A', width);
    B = test_image('lightness contrast B', width);
    config = configurations.double_opponent();
    config.display.logging               = true;
    config.display.plot                  = true;
    config.display.play                  = true;
    config.image.transform               = 'rgb2lab';
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 5;
    config.zli.n_iter                    = 10;
    config.zli.ON_OFF                    = 'separate';
    config.zli.interaction.color.enabled = false;
    % When
    [~, A_out] = model.apply(A, config);
    [~, B_out] = model.apply(B, config);
    % Then
    third_width = floor(width/3);
    inner_range = third_width:width-third_width;
    A_inner_out = A_out(inner_range,inner_range,:);
    B_inner_out = B_out(inner_range,inner_range,:);
    A_lightness = sum(sum(A_inner_out(:,:,1))) / third_width^2;
    B_lightness = sum(sum(B_inner_out(:,:,1))) / third_width^2;
    assertTrue(A_lightness > B_lightness, ...
               'Lightnes contrast: A should be lighter than B.');
    assertTrue(A_lightness > 0, ...
               'Lightnes contrast: A should be lightened.');
    assertTrue(B_lightness < 0, ...
               'Lightnes contrast: B should be darkened.');
end

function test_crispening_effect
    % Given
    width = 48;
    A = test_image('crispening effect A', width);
    B = test_image('crispening effect B', width);
    C = test_image('crispening effect C', width);
    config = configurations.double_opponent();
    config.display.logging               = true;
    config.display.plot                  = true;
    config.display.play                  = true;
    config.image.transform               = 'rgb2lab';
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 5;
    config.zli.n_iter                    = 10;
    config.zli.ON_OFF                    = 'separate';
    config.zli.interaction.color.enabled = false;
    % When
    [~, A_out] = model.apply(A, config);
    [~, B_out] = model.apply(B, config);
    [~, C_out] = model.apply(C, config);
    % Then
end

function I = synthetic_image()
% Generate a simple image for testing: a flat square on a flat background.
    I = ones(42, 42, 3) * 0.2;      % some base signal in every channel
    I(:,:,1) = 0.8;                 % strong red background
    I(11:end-11,11:end-11,:) = 0.7; % light grey square in the center
end

function assertPositivesAverageHigher(test, reference)
    test_mean      = mean(test(:));
    reference_mean = mean(reference(:));
    assertTrue(test_mean > reference_mean, ...
                'Mean of positive values should be higher than reference.');
end

function assertNegativesAverageLower(test, reference)
    test_mean      = mean(test(:));
    reference_mean = mean(reference(:));
    assertTrue(test_mean < reference_mean, ...
                'Mean of negative values should be lower than reference.');
end

function assertPositivesPeakHigher(test, reference)
    test_mean      = max(test(:));
    reference_mean = max(reference(:));
    assertTrue(test_mean > reference_mean, ...
                'Peak of positive values should be higher than reference.');
end

function assertNegativesPeakLower(test, reference)
    test_mean      = min(test(:));
    reference_mean = min(reference(:));
    assertTrue(test_mean < reference_mean, ...
                'Peak of negative values should be lower than reference.');
end