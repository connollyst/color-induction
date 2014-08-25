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
    config.image.transform                = 'none';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 3;
    config.zli.n_iter                     = 3;
    config.zli.ON_OFF                     = 'abs';
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
    config.display.logging                = false;
    config.display.plot                   = false;
    config.display.play                   = false;
    config.image.transform                = 'none';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 5;
    config.zli.n_iter                     = 10;
    config.zli.ON_OFF                     = 'abs';
    configB.zli.interaction.color.enabled = true;
    configA = config;
    configB.zli.interaction.color.weight.excitation = 0.0;
    configB.zli.interaction.color.weight.inhibition = 0.0;
    configB = config;
    configB.zli.interaction.color.weight.excitation = 0.3;
    configB.zli.interaction.color.weight.inhibition = 0.0;
    % When
    normal  = model.apply(I, configA);
    excited = model.apply(I, configB);
    % Then
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
    config.image.transform                = 'none';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 5;
    config.zli.n_iter                     = 10;
    config.zli.ON_OFF                     = 'abs';
    configB.zli.interaction.color.enabled = true;
    configA = config;
    configB.zli.interaction.color.weight.excitation = 0.0;
    configB.zli.interaction.color.weight.inhibition = 0.0;
    configB = config;
    configB.zli.interaction.color.weight.excitation = 0.0;
    configB.zli.interaction.color.weight.inhibition = 0.3;
    % When
    normal  = model.apply(I, configA);
    inhibited = model.apply(I, configB);
    % Then
    assertNegativesPeakLower(inhibited, normal);
    assertPositivesPeakHigher(inhibited, normal);
    % FAILS: current implementation is lacking somewhere
    assertNegativesAverageLower(inhibited, normal);
    assertPositivesAverageHigher(inhibited, normal);
end

function I = synthetic_image()
% Generate a simple image for testing: a flat square on a flat background.
    I = zeros(42, 42, 3);
    I(11:end-11,11:end-11,:) = 1;
end

function assertPositivesAverageHigher(test, reference)
    test_mean      = mean(test(test > 0));
    reference_mean = mean(reference(reference > 0));
    assertTrue(test_mean > reference_mean, ...
                'Mean of positive values should be higher than reference.');
end

function assertNegativesAverageLower(test, reference)
    test_mean      = mean(test(test < 0));
    reference_mean = mean(reference(reference < 0));
    assertTrue(test_mean < reference_mean, ...
                'Mean of negative values should be lower than reference.');
end

function assertPositivesPeakHigher(test, reference)
    test_mean      = max(test(test > 0));
    reference_mean = max(reference(reference > 0));
    assertTrue(test_mean > reference_mean, ...
                'Peak of positive values should be higher than reference.');
end

function assertNegativesPeakLower(test, reference)
    test_mean      = min(test(test < 0));
    reference_mean = min(reference(reference < 0));
    assertTrue(test_mean < reference_mean, ...
                'Peak of negative values should be lower than reference.');
end