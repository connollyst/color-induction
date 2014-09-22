function test_suite = test_apply_excitation
  initTestSuite;
end

%% TEST OUTPUT DIMENSIONS

function test_output_image_dimension
    % Given
    config          = get_config();
    I_in            = model.utils.zeros(config);
    interactions    = model.terms.get_interactions(config);
    % When
    I_out           = model.terms.interactions.orients.apply_excitation( ...
                        I_in, interactions, config ...
                      );
    % Then
    actual_cols   = size(I_out, 1);
    actual_rows   = size(I_out, 2);
    expected_cols = config.image.width;
    expected_rows = config.image.height;
    assertEqual(expected_cols, actual_cols);
    assertEqual(expected_rows, actual_rows);
end

function test_output_color_dimension
    % Given
    config          = get_config();
    I_in            = model.utils.zeros(config);
    interactions    = model.terms.get_interactions(config);
    % When
    I_out           = model.terms.interactions.orients.apply_excitation( ...
                        I_in, interactions, config ...
                      );
    % Then
    actual_colors   = size(I_out, 3);
    expected_colors = config.image.n_channels;
    assertEqual(expected_colors, actual_colors); % TODO this fails because color padding is lost!
end

function test_output_scale_dimension
    % Given
    config          = get_config();
    I_in            = model.utils.zeros(config);
    interactions    = model.terms.get_interactions(config);
    % When
    I_out           = model.terms.interactions.orients.apply_excitation( ...
                        I_in, interactions, config ...
                      );
    % Then
    actual_scales   = size(I_out, 4);
    expected_scales = config.wave.n_scales;
    assertEqual(expected_scales, actual_scales);
end

function test_output_orient_dimension
    % Given
    config           = get_config();
    I_in             = model.utils.zeros(config);
    interactions     = model.terms.get_interactions(config);
    % When
    I_out            = model.terms.interactions.orients.apply_excitation( ...
                         I_in, interactions, config ...
                       );
    % Then
    actual_orients   = size(I_out, 5);
    expected_orients = config.wave.n_orients;
    assertEqual(expected_orients, actual_orients);
end

%% TEST EXCITATION BETWEEN ORIENTATIONS WITHIN SO & DO

function test_excitation_within_DO_when_SO_connections_are_disabled
    % Given
    config            = get_config();
    config.zli.interaction.so_to_do = 0;
    config.zli.interaction.do_to_so = 0;
    config.wave.n_orients = 4;
    config.rf.so.enabled  = true;
    config.rf.do.enabled  = true;
    I_in              = model.utils.zeros(config);
    I_in(:,:,:,:,1:3) = 1;
    interactions  = model.terms.get_interactions(config);
    % When
    I_out         = model.terms.interactions.orients.apply_excitation( ...
                        I_in, interactions, config ...
                    );
    % Then
    I_in_DO  = I_in(:,:,:,:,1:3);
    I_out_DO = I_out(:,:,:,:,1:3);
    assertFalse(isequal(I_in_DO, I_out_DO), 'Expected excitation to change.');
end

function test_excitation_within_SO_when_DO_connections_are_disabled
    % Given
    config            = get_config();
    config.zli.interaction.so_to_do = 0;
    config.zli.interaction.do_to_so = 0;
    config.wave.n_orients = 4;
    config.rf.so.enabled  = true;
    config.rf.do.enabled  = true;
    I_in              = model.utils.zeros(config);
    I_in(:,:,:,:,4) = 1;
    interactions  = model.terms.get_interactions(config);
    % When
    I_out         = model.terms.interactions.orients.apply_excitation( ...
                        I_in, interactions, config ...
                    );
    % Then
    I_in_SO  = I_in(:,:,:,:,4);
    I_out_SO = I_out(:,:,:,:,4);
    assertFalse(isequal(I_in_SO, I_out_SO), 'Expected excitation to change.');
end

%% TEST INTERACTIONS BETWEEN SINGLE & DOUBLE OPPONENT CELLS

function test_no_excitation_from_DO_to_SO_when_connections_disabled
    % Given
    config            = get_config();
    config.zli.interaction.orient.to_so   = 0;  % expect no excitation
    config.zli.interaction.orient.from_so = 1;
    config.wave.n_orients = 4;
    config.rf.so.enabled  = true;
    config.rf.do.enabled  = true;
    I_in              = model.utils.zeros(config);
    I_in(:,:,:,:,1:3) = 1;
    interactions  = model.terms.get_interactions(config);
    % When
    I_out         = model.terms.interactions.orients.apply_excitation( ...
                        I_in, interactions, config ...
                    );
    % Then
    I_in_SO  = I_in(:,:,:,:,4);
    I_out_SO = I_out(:,:,:,:,4);
    assertEqual(I_in_SO, I_out_SO);
end

function test_no_excitation_from_SO_to_DO_when_connections_disabled
    % Given
    config            = get_config();
    config.zli.interaction.orient.to_so   = 1;
    config.zli.interaction.orient.from_so = 0;  % expect no excitation
    config.wave.n_orients = 4;
    config.rf.so.enabled  = true;
    config.rf.do.enabled  = true;
    I_in            = model.utils.zeros(config);
    I_in(:,:,1,1,4) = 1;
    I_in(:,:,2,1,4) = 2;
    I_in(:,:,3,1,4) = 3;
    I_in(:,:,4,1,4) = 4;
    I_in(:,:,1,2,4) = 5;
    I_in(:,:,2,2,4) = 6;
    I_in(:,:,3,2,4) = 7;
    I_in(:,:,4,2,4) = 8;
    interactions  = model.terms.get_interactions(config);
    % When
    I_out         = model.terms.interactions.orients.apply_excitation( ...
                        I_in, interactions, config ...
                    );
    % Then
    I_in_DO  = I_in(:,:,:,:,1:3);
    I_out_DO = I_out(:,:,:,:,1:3);
    assertEqual(I_in_DO, I_out_DO);
end

function test_excitation_from_DO_to_SO_by_weight
    % Given
    config            = get_config();
    config.zli.interaction.orient.to_so   = 0.5;    % expect 50% excitation
    config.zli.interaction.orient.from_so = 0;
    config.wave.n_orients = 4;
    config.rf.so.enabled  = true;
    config.rf.do.enabled  = true;
    I_in              = model.utils.zeros(config);
    I_in(:,:,1,1,3) = 1;
    I_in(:,:,2,1,3) = 2;
    I_in(:,:,3,1,3) = 3;
    I_in(:,:,4,1,3) = 4;
    I_in(:,:,1,2,3) = 5;
    I_in(:,:,2,2,3) = 6;
    I_in(:,:,3,2,3) = 7;
    I_in(:,:,4,2,3) = 8;
    interactions  = model.terms.get_interactions(config);
    % When
    I_out         = model.terms.interactions.orients.apply_excitation( ...
                        I_in, interactions, config ...
                    );
    % Then
    I_in_DO3 = I_in(:,:,:,:,3);
    I_out_SO = I_out(:,:,:,:,4);
    assertElementsAlmostEqual(I_in_DO3/2, I_out_SO, ...
                    ['Incorrect excitation from DO to SO']);
end

function test_excitation_from_SO_to_DO_by_weight
    % Given
    config            = get_config();
    config.zli.interaction.orient.to_so   = 0;
    config.zli.interaction.orient.from_so = 0.5;    % expect 50% excitation
    config.wave.n_orients = 4;
    config.rf.so.enabled  = true;
    config.rf.do.enabled  = true;
    I_in              = model.utils.zeros(config);
    I_in(:,:,1,1,4) = 1;
    I_in(:,:,2,1,4) = 2;
    I_in(:,:,3,1,4) = 3;
    I_in(:,:,4,1,4) = 4;
    I_in(:,:,1,2,4) = 5;
    I_in(:,:,2,2,4) = 6;
    I_in(:,:,3,2,4) = 7;
    I_in(:,:,4,2,4) = 8;
    interactions  = model.terms.get_interactions(config);
    % When
    I_out         = model.terms.interactions.orients.apply_excitation( ...
                        I_in, interactions, config ...
                    );
    % Then
    I_in_SO  = I_in(:,:,:,:,4);
    for o=1:3
        I_out_DO = I_out(:,:,:,:,o);
        assertElementsAlmostEqual(I_in_SO/2, I_out_DO, ...
                        ['Incorrect excitation from SO to DO #',num2str(o)]);
    end
end

%% UTILITIES

function config = get_config()
    config = configurations.default();
    config.display.plot                  = false;
    config.display.logging               = false;
    config.image.width                   = 42;
    config.image.height                  = 42;
    config.image.n_channels              = 4;
    config.wave.n_scales                 = 2;
    config.wave.n_orients                = 3;
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.weight.excitation = 0.5;
    config.zli.interaction.color.weight.inhibition = 0.2;
end