function test_suite = test_apply_excitation
  initTestSuite;
end

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