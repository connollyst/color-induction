function test_suite = test_color_induction
  initTestSuite;
end

function test_opponent_channel_induction
    I = zeros(42, 42, 2);
    I(:,:,1) = get_image() *  0.5;
    I(:,:,2) = get_image() * -0.3;
    config = configurations.double_opponent();
    config.display.logging                = true;
    config.display.plot                   = false;
    config.image.type                     = 'bw';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 18;
    config.zli.n_iter                     = 10;
    % When
    O = model.apply(I, config);
    error('TODO assert the colors move in the direction expected');
end

function I = get_image()
    I = zeros(42, 42);
    I(11:end-11,11:end-11) = 1; 
end