function test_suite = test_color_induction
  initTestSuite;
end

%% 1D TESTS: channel interactions should not affect the output

function test_red_green_induction_of_red
    I = imread('peppers.png');
    I = imresize(I, 0.15);
    config = configurations.double_opponent();
    config.display.logging                = true;
    config.display.plot                   = false;
    config.image.type                     = 'rgb';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 3;
    config.zli.n_iter                     = 3;
    % When
    model.apply(I, config);
end