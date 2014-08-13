function test_suite = test_transform
  initTestSuite;
end

function test_no_transform
    % Given
    [I_in, config] = get_input('none');
    % When
    I_out = model.data.color.transform(I_in, config);
    % Then
    assertEqualData(I_out, as_double(I_in));
end

function test_lab_transform
    % Given
    [I_in, config] = get_input('lab');
    % When
    I_out = model.data.color.transform(I_in, config);
    % Then
    assertEqualData(I_out, as_lab(I_in));
end

%% UTILITIES

function [I, config] = get_input(transform)
    im                   = little_peppers();
    config                 = configurations.default();
    config.display.logging = false;
    config.display.plot    = false;
    config.image.transform = transform;
    config.wave.n_scales   = 2;
    I = { im };
end

function I_double = as_double(I)
    I_double = cell(size(I));
    for i=1:length(I)
        I_double{i} = im2double(I{i});
    end
end

function I_double = as_lab(I)
    I_double = cell(size(I));
    for i=1:length(I)
        I_double{i} = lab2double(applycform(I{i}, makecform('srgb2lab')));
    end
end