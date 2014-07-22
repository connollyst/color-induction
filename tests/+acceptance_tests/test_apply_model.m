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
    config.image.type                     = 'bw';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 3;
    config.zli.n_iter                     = 3;
    I_out = model.apply(I_in, config);
    assertEqualData(I_out, im2double(I_in))
end

function test_separate_and_opponent_ON_OFF_without_channel_interactions
% Processing the ON & OFF channels 'separate' should give the exact same
% output as processing them as 'opponent', if channel interactions are
% disabled.
    % Given
    I = imread('peppers.png');
    I = imresize(I, 0.15);
    I = I(:,:,1);
    config = configurations.default();
    config.display.logging                = false;
    config.display.plot                   = false;
    config.image.type                     = 'bw';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 3;
    config.zli.n_iter                     = 3;
    config.zli.interaction.orient.enabled = true;
    config.zli.interaction.scale.enabled  = true;
    config.zli.interaction.color.enabled  = false;
    configA = config;
    configB = config;
    configA.zli.ON_OFF                   = 'separate';
    configB.zli.ON_OFF                   = 'opponent';
    % When
    I_separate = model.apply(I, configA);
    I_opponent = model.apply(I, configB);
    % Then
    assertEqualData(I_separate, I_opponent)
end