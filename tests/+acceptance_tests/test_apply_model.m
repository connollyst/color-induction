function test_suite = test_apply_model
  initTestSuite;
end

function ignored_test_3D_without_interactions
% TODO this test doesn't pass.. should it?
    I = imread('peppers.png');
    I_in = imresize(I, 0.15);
    config = configurations.disabled();
    config.display.logging                = false;
    config.display.plot                   = false;
    config.image.transform                = 'none';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 3;
    config.zli.n_iter                     = 3;
    I_out = model.apply(I_in, config);
    assertEqualData(I_out, im2double(I_in))
end