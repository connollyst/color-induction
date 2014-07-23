function test_suite = test_color_induction
  initTestSuite;
end

function ignored_test_opponent_channel_induction
    I        = ones(42, 42, 1) * -0.3;
    I(:,:,1) = get_image()     *  0.5;
    config = configurations.double_opponent();
    config.display.logging                = true;
    config.display.plot                   = true;
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