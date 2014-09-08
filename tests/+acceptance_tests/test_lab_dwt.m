function test_suite = test_lab_dwt
  initTestSuite;
end

function test_no_color_induction_with_zero_weights
% Setting the excitation & inhibition weights to 0 should be effectively
% the same as turning off interactions all together. Here we run both
% scenarios and expect the output to be the same.
    % Given
    I = little_peppers;
    config                                = configurations.default;
    config.display.logging                = false;
    config.display.plot                   = false;
    config.image.transform                = 'rgb2lab';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 2;
    config.zli.n_iter                     = 2;
    config.zli.ON_OFF                     = 'separate';
    configA = config;
    configA.zli.interaction.color.enabled = false;
    configB = config;
    configB.zli.interaction.color.enabled = true;
    configB.zli.interaction.color.model   = 'default';
    configB.zli.interaction.color.weight.excitation = 0;
    configB.zli.interaction.color.weight.inhibition = 0;
    configC = config;
    configC.zli.interaction.color.enabled = true;
    configC.zli.interaction.color.model   = 'opponent';
    configC.zli.interaction.color.weight.excitation = 0;
    configC.zli.interaction.color.weight.inhibition = 0;
    % When
    A = model.apply(I, configA);
    B = model.apply(I, configB);
    C = model.apply(I, configC);
    % Then
    assertEqualData(A, B);
    assertEqualData(A, C);
end

function test_opponent_color_excitation
    % Given
    I = synthetic_image * 0.5;
    config                               = configurations.default;
    config.display.logging               = false;
    config.display.plot                  = false;
    config.image.transform               = 'rgb2lab';
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 3;
    config.zli.n_iter                    = 5;
    config.zli.ON_OFF                    = 'separate';
    config.zli.interaction.color.enabled = true;
    configA = config;
    configA.zli.interaction.color.weight.excitation = 0.0;
    configA.zli.interaction.color.weight.inhibition = 0.0;
    configB = config;
    configB.zli.interaction.color.weight.excitation = 0.1;
    configB.zli.interaction.color.weight.inhibition = 0.0;
    % When
    [~, normal]  = model.apply(I, configA);
    [~, excited] = model.apply(I, configB);
    % Then
    n_channels = size(normal, 3);
    for c=1:n_channels
        % With added excitation and no inhibition, we expect increased
        % activity in all channels, in all directions..
        test = excited(:,:,c);
        reference = normal(:,:,c);
        assertNegativesPeakLower(test, reference, ['channel=',num2str(c)]);
        assertPositivesPeakHigher(test, reference, ['channel=',num2str(c)]);
        assertNegativesAverageLower(test, reference, ['channel=',num2str(c)]);
        assertPositivesAverageHigher(test, reference, ['channel=',num2str(c)]);
    end
end

function test_opponent_color_inhibition
    % Given
    I = synthetic_image * 0.5;
    config                               = configurations.default;
    config.display.logging               = false;
    config.display.plot                  = false;
    config.image.transform               = 'rgb2lab';
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 3;
    config.zli.n_iter                    = 5;
    config.zli.ON_OFF                    = 'separate';
    config.zli.interaction.color.enabled = true;
    configA = config;
    configA.zli.interaction.color.weight.excitation = 0.0;
    configA.zli.interaction.color.weight.inhibition = 0.0;
    configB = config;
    configB.zli.interaction.color.weight.excitation = 0.0;
    configB.zli.interaction.color.weight.inhibition = 0.1;
    % When
    normal    = model.apply(I, configA);
    inhibited = model.apply(I, configB);
    % Then
    n_channels = size(normal, 3);
    for c=1:n_channels
        % With added inhibition and no excitation, we expect reduced
        % activity in all channels, in all directions..
        test = inhibited(:,:,c);
        reference = normal(:,:,c);
        assertNegativesPeakLower(reference, test, ['channel=',num2str(c)]);
        assertPositivesPeakHigher(reference, test, ['channel=',num2str(c)]);
        assertNegativesAverageLower(reference, test, ['channel=',num2str(c)]);
        assertPositivesAverageHigher(reference, test, ['channel=',num2str(c)]);
    end
end

function test_double_opponent_lightness_contrast
    % Given
    width = 48;
    A = test_image('lightness contrast A', width);
    B = test_image('lightness contrast B', width);
    config                               = configurations.double_opponent_lab;
    config.display.logging               = false;
    config.display.plot                  = false;
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

function test_double_opponent_crispening_effect
    % Given
    width = 48;
    A = test_image('crispening effect A', width);
    B = test_image('crispening effect B', width);
    C = test_image('crispening effect C', width);
    config                               = configurations.double_opponent_lab;
    config.display.logging               = false;
    config.display.plot                  = false;
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
    % Then we should see that the top and bottom colored squares are most
    % noticeably different from each other when placed on a background
    % whose color is between the squares' colors. This backround drives
    % the squares colors' apart, while a black or white background drives
    % the colors toward each other.
    third_width    = floor(width/3);
    inner_cols     = third_width:width-third_width;
    inner_rows_one = inner_cols;
    inner_rows_two = inner_rows_one+width;
    A_out_one      = A_out(inner_rows_one, inner_cols, :);
    A_out_two      = A_out(inner_rows_two, inner_cols, :);
    B_out_one      = B_out(inner_rows_one, inner_cols, :);
    B_out_two      = B_out(inner_rows_two, inner_cols, :);
    C_out_one      = C_out(inner_rows_one, inner_cols, :);
    C_out_two      = C_out(inner_rows_two, inner_cols, :);
    A_mean_one     = mean(A_out_one(:));
    A_mean_two     = mean(A_out_two(:));
    B_mean_one     = mean(B_out_one(:));
    B_mean_two     = mean(B_out_two(:));
    C_mean_one     = mean(C_out_one(:));
    C_mean_two     = mean(C_out_two(:));
    A_mean_diff    = abs(A_mean_one - A_mean_two);
    B_mean_diff    = abs(B_mean_one - B_mean_two);
    C_mean_diff    = abs(C_mean_one - C_mean_two);
    assertTrue(B_mean_diff > A_mean_diff);
    assertTrue(B_mean_diff > C_mean_diff);
end

%% TEST UTILITIES

function I = synthetic_image()
% Generate a simple image for testing: a flat square on a flat background.
    I = ones(42, 42, 3) * 0.2;      % some base signal in every channel
    I(:,:,1) = 0.8;                 % strong red background
    I(11:end-11,11:end-11,:) = 0.7; % light grey square in the center
end

%% TEST ASSERTIONS

function assertPositivesAverageHigher(test, reference, message)
    test_pos       = test(test > 0);
    test_mean      = mean(test_pos(:));
    reference_pos  = reference(reference > 0);
    reference_mean = mean(reference_pos(:));
    assertTrue(test_mean > reference_mean, ...
        ['Mean of positive values should be higher than reference: ',message]);
end

function assertNegativesAverageLower(test, reference, message)
    test_neg       = test(test < 0);
    test_mean      = mean(test_neg(:));
    reference_neg  = reference(reference < 0);
    reference_mean = mean(reference_neg(:));
    assertTrue(test_mean < reference_mean, ...
        ['Mean of negative values should be lower than reference: ',message]);
end

function assertPositivesPeakHigher(test, reference, message)
    test_mean      = max(test(:));
    reference_mean = max(reference(:));
    assertTrue(test_mean > reference_mean, ...
        ['Peak of positive values should be higher than reference: ',message]);
end

function assertNegativesPeakLower(test, reference, message)
    test_mean      = min(test(:));
    reference_mean = min(reference(:));
    assertTrue(test_mean < reference_mean, ...
        ['Peak of negative values should be lower than reference: ',message]);
end