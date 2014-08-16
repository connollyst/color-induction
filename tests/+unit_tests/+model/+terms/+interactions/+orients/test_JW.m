function test_suite = test_JW
  initTestSuite;
end

%% ASSERT SINGLE OPPONENT J & W INTERACTION MAPS

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

function test_single_opponent_J_interactions_horizontal
    config = single_opponent_config;
    interactions = model.terms.get_interactions(config);
    for s=1:config.wave.n_scales
        J = interactions.orient.JW.J{s};
        assertNotEmpty(J(:,:,1,1,1), 'non-edges should excite non-edges');
    end
end

%% ASSERT DOUBLE OPPONENT J & W INTERACTION MAPS

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

function test_double_opponent_J_interactions_horizontal
    config = double_opponent_config;
    interactions = model.terms.get_interactions(config);
    for s=1:config.wave.n_scales
        J = interactions.orient.JW.J{s};
        assertNotEmpty(J(:,:,1,1,1), 'horizontal edges should excite horizontal edges');
        assertNotEmpty(J(:,:,1,1,2), 'horizontal edges should excite diagonal edges');
        assertEmpty(   J(:,:,1,1,3), 'horizontal edges shouldnt excite vertical edges');
    end
end

function test_double_opponent_J_interactions_diagonal
    config = double_opponent_config;
    interactions = model.terms.get_interactions(config);
    for s=1:config.wave.n_scales
        J = interactions.orient.JW.J{s};
        assertNotEmpty(J(:,:,1,2,1), 'diagonal edges should excite horizontal edges');
        assertNotEmpty(J(:,:,1,2,2), 'diagonal edges should excite diagonal edges');
        assertNotEmpty(J(:,:,1,2,3), 'diagonal edges should excite vertical edges');
    end
end

function test_double_opponent_J_interactions_vertical
    config = double_opponent_config;
    interactions = model.terms.get_interactions(config);
    for s=1:config.wave.n_scales
        J = interactions.orient.JW.J{s};
        assertEmpty(   J(:,:,1,3,1), 'vertical edges shouldnt excite horizontal edges');
        assertNotEmpty(J(:,:,1,3,2), 'vertical edges should excite diagonal edges');
        assertNotEmpty(J(:,:,1,3,3), 'vertical edges should excite vertical edges');
    end
end

%% ASSERT SINGLE & DOUBLE OPPONENT J & W INTERACTION MAPS

function test_single_and_double_opponent_JW_exists
    interactions = model.terms.get_interactions(opponent_config);
    assertTrue(isfield(interactions.orient,'JW'))
end

function test_single_and_double_opponent_W_exists
    interactions = model.terms.get_interactions(opponent_config);
    assertTrue(isfield(interactions.orient.JW,'W'))
end

function test_single_and_double_opponent_Jfft_exists
    interactions = model.terms.get_interactions(opponent_config);
    assertTrue(isfield(interactions.orient.JW,'J_fft'))
end

function test_single_and_double_opponent_Wfft_exists
    interactions = model.terms.get_interactions(opponent_config);
    assertTrue(isfield(interactions.orient.JW,'W_fft'))
end

function test_single_and_double_opponent_J_dimensions
    config = opponent_config;
    interactions = model.terms.get_interactions(config);
    assertJorWDimensions(config, interactions.scale, interactions.orient.JW.J);
end

function test_single_and_double_opponent_W_dimensions
    config = opponent_config;
    interactions = model.terms.get_interactions(config);
    assertJorWDimensions(config, interactions.scale, interactions.orient.JW.W);
end

function test_single_and_double_opponent_J_interactions_horizontal
    config = opponent_config;
    interactions = model.terms.get_interactions(config);
    for s=1:config.wave.n_scales
        J = interactions.orient.JW.J{s};
        assertNotEmpty(J(:,:,1,1,1), 'horizontal edges should excite horizontal edges');
        assertNotEmpty(J(:,:,1,1,2), 'horizontal edges should excite diagonal edges');
        assertEmpty(   J(:,:,1,1,3), 'horizontal edges shouldnt excite vertical edges');
        assertNotEmpty(J(:,:,1,1,4), 'horizontal edges should excite non-edges');
    end
end

function test_single_and_double_opponent_J_interactions_diagonal
    config = opponent_config;
    interactions = model.terms.get_interactions(config);
    for s=1:config.wave.n_scales
        J = interactions.orient.JW.J{s};
        assertNotEmpty(J(:,:,1,2,1), 'diagonal edges should excite horizontal edges');
        assertNotEmpty(J(:,:,1,2,2), 'diagonal edges should excite diagonal edges');
        assertNotEmpty(J(:,:,1,2,3), 'diagonal edges should excite vertical edges');
        assertNotEmpty(J(:,:,1,2,4), 'diagonal edges should excite non-edges');
    end
end

function test_single_and_double_opponent_J_interactions_vertical
    config = opponent_config;
    interactions = model.terms.get_interactions(config);
    for s=1:config.wave.n_scales
        J = interactions.orient.JW.J{s};
        assertEmpty(   J(:,:,1,3,1), 'vertical edges shouldnt excite horizontal edges');
        assertNotEmpty(J(:,:,1,3,2), 'vertical edges should excite diagonal edges');
        assertNotEmpty(J(:,:,1,3,3), 'vertical edges should excite vertical edges');
        assertNotEmpty(J(:,:,1,3,4), 'vertical edges should excite non-edges');
    end
end

function test_single_and_double_opponent_J_interactions_nonedge
    config = opponent_config;
    interactions = model.terms.get_interactions(config);
    for s=1:config.wave.n_scales
        J = interactions.orient.JW.J{s};
        assertEmpty(   J(:,:,1,4,1), 'non-edges shouldnt excite horizontal edges');
        assertEmpty(   J(:,:,1,4,2), 'non-edges shouldnt excite diagonal edges');
        assertEmpty(   J(:,:,1,4,3), 'non-edges shouldnt excite vertical edges');
        assertNotEmpty(J(:,:,1,4,4), 'non-edges should excite non-edges');
    end
end

%% TEST ASSERTIONS

function assertJorWDimensions(config, scale_interactions, JorW)
    actualLength   = length(JorW);
    expectedLength = config.wave.n_scales;
    assertEqual(actualLength, expectedLength);
    for s=1:config.wave.n_scales
        expectedDiameter = scale_interactions.diameters(s);
        expectedComponents = config.wave.n_components;
        assertEqual(size(JorW{s}, 1), expectedDiameter);
        assertEqual(size(JorW{s}, 2), expectedDiameter);
        assertEqual(size(JorW{s}, 3), 1);
        assertEqual(size(JorW{s}, 4), expectedComponents);
        assertEqual(size(JorW{s}, 5), expectedComponents);
    end
end

function assertNotEmpty(matrix, message)
    assertFalse(max(matrix(:)) == 0, message);
end

function assertEmpty(matrix, message)
    assertTrue(max(matrix(:)) == 0, message);
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
    config = configurations.default();
    config.image.width      = 137;
    config.image.height     = 42;
    config.image.n_channels = 4;
    config.wave.n_scales    = 2;
end