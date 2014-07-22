function test_suite = test_error_handling
%Test suite for model.apply()
  initTestSuite;
end

%% 1D TESTS: channel interactions should not affect the output

function test_error_for_1_opponent_color
    % Given
    config = configurations.default();
    config.zli.interaction.color.enabled   = true;
    config.wave.n_scales = 1;
    config.image.type = 'lab';
    config.display.logging = false;
    config.display.plot    = false;
    I = im2double(imread('cameraman.tif'));
    % Then
    assertExceptionThrown(@() model.apply(I, config), 'MODEL:uneven_opponent');
end