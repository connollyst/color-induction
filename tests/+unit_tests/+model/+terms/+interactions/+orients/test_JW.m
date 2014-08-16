function test_suite = test_JW
  initTestSuite;
end

%% ASSERT DOUBLE OPPONENT JW DATA STRUCTURE

function test_double_opponent_JW_exists
    interactions = model.terms.get_interactions(double_opponent_config);
    assertTrue(isfield(interactions.orient,'JW'))
end

function test_double_opponent_J_exists
    interactions = model.terms.get_interactions(double_opponent_config);
    assertTrue(isfield(interactions.orient.JW,'J'))
end

function test_double_opponent_W_exists
    interactions = model.terms.get_interactions(double_opponent_config);
    assertTrue(isfield(interactions.orient.JW,'W'))
end

function test_double_opponent_Jfft_exists
    interactions = model.terms.get_interactions(double_opponent_config);
    assertTrue(isfield(interactions.orient.JW,'J_fft'))
end

function test_double_opponent_Wfft_exists
    interactions = model.terms.get_interactions(double_opponent_config);
    assertTrue(isfield(interactions.orient.JW,'W_fft'))
end

function test_double_opponent_J_dimensions
    config = double_opponent_config;
    interactions = model.terms.get_interactions(config);
    assertJorWDimensions(config, interactions.scale, interactions.orient.JW.J);
end

function test_double_opponent_W_dimensions
    config = double_opponent_config;
    interactions = model.terms.get_interactions(config);
    assertJorWDimensions(config, interactions.scale, interactions.orient.JW.W);
end

%% ASSERT SINGLE OPPONENT JW DATA STRUCTURE

function test_single_opponent_JW_exists
    interactions = model.terms.get_interactions(single_opponent_config);
    assertTrue(isfield(interactions.orient,'JW'))
end

function test_single_opponent_J_exists
    interactions = model.terms.get_interactions(single_opponent_config);
    assertTrue(isfield(interactions.orient.JW,'J'))
end

function test_single_opponent_W_exists
    interactions = model.terms.get_interactions(single_opponent_config);
    assertTrue(isfield(interactions.orient.JW,'W'))
end

function test_single_opponent_Jfft_exists
    interactions = model.terms.get_interactions(single_opponent_config);
    assertTrue(isfield(interactions.orient.JW,'J_fft'))
end

function test_single_opponent_Wfft_exists
    interactions = model.terms.get_interactions(single_opponent_config);
    assertTrue(isfield(interactions.orient.JW,'W_fft'))
end

function test_single_opponent_J_dimensions
    config = single_opponent_config;
    interactions = model.terms.get_interactions(config);
    assertJorWDimensions(config, interactions.scale, interactions.orient.JW.J);
end

function test_single_opponent_W_dimensions
    config = single_opponent_config;
    interactions = model.terms.get_interactions(config);
    assertJorWDimensions(config, interactions.scale, interactions.orient.JW.W);
end

%% TEST ASSERTIONS

function assertJorWDimensions(config, scale_interactions, JorW)
    actualLength   = length(JorW);
    expectedLength = config.wave.n_scales;
    assertEqual(actualLength, expectedLength);
    for s=1:config.wave.n_scales
        expectedDiameter = scale_interactions.diameters(s);
        expectedOrientations = config.wave.n_orients;
        assertEqual(size(JorW{s}, 1), expectedDiameter);
        assertEqual(size(JorW{s}, 2), expectedDiameter);
        assertEqual(size(JorW{s}, 3), 1);
        assertEqual(size(JorW{s}, 4), expectedOrientations);
        assertEqual(size(JorW{s}, 5), expectedOrientations);
    end
end

%% TEST UTILITIES

function config = double_opponent_config()
    config = configurations.double_opponent();
    config.image.width      = 137;
    config.image.height     = 42;
    config.image.n_channels = 4;
    config.wave.n_scales    = 2;
end

function config = single_opponent_config()
    config = configurations.single_opponent();
    config.image.width      = 137;
    config.image.height     = 42;
    config.image.n_channels = 4;
    config.wave.n_scales    = 2;
end

function config = opponent_config()
    config = configurations.opponent();
    config.image.width      = 137;
    config.image.height     = 42;
    config.image.n_channels = 4;
    config.wave.n_scales    = 2;
end