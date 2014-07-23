function test_suite = test_color_induction
  initTestSuite;
end

function test_no_color_induction_with_zero_weights
    % Given
    I = little_peppers();
    config = configurations.double_opponent();
    config.display.logging                = false;
    config.display.plot                   = false;
    config.display.play                   = false;
    config.image.type                     = 'rgb';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 3;
    config.zli.n_iter                     = 3;
    config.zli.ON_OFF                     = 'opponent';
    configA = config;
    configA.zli.interaction.color.enabled = false;
    configB = config;
    configA.zli.interaction.color.enabled = true;
    configA.zli.interaction.color.weight.excitation = 0;
    configA.zli.interaction.color.weight.inhibition = 0;
    % When
    expected = model.apply(I, configA);
    actual   = model.apply(I, configB);
    % Then
    assertEqualData(expected, actual);
end

function ignored_test_opponent_channel_induction
    I        = ones(42, 42, 1) * -0.3;
    I(:,:,1) = get_image()     *  0.5;
    config = configurations.double_opponent();
    config.display.logging                = false;
    config.display.plot                   = false;
    config.display.play                   = false;
    config.image.type                     = 'bw';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 10;
    config.zli.n_iter                     = 10;
    config.zli.ON_OFF                     = 'opponent';
    config.zli.interaction.color.enabled  = true;
    config.zli.interaction.color.weight.excitation = 0;
    config.zli.interaction.color.weight.inhibition = 0;
    % When
    O = model.apply(I, config);
    %error('TODO assert the colors move in the direction expected');
end

function I = get_image()
    I = zeros(42, 42);
    I(11:end-11,11:end-11) = 1; 
end