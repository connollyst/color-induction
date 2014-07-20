function test_suite = test_apply_inhibition
  initTestSuite;
end

%% TEST NO COLOR INTERACTIONS

function test_no_color_inhibition_when_disabled
    % Given
    config = struct();
    config.zli.interaction.color.enabled = false;
    color_interactions = model.terms.interactions.colors.inhibition_filter(config);
    I = imread('peppers.png');
    I_in = im2double(imresize(I, 0.1));
    % When
    I_out = model.terms.interactions.colors.apply_inhibition(I_in, color_interactions, config);
    % Then
    assertEqual(I_out, I_in);
end


% Tests:
% assert no change if disabled
% assert no change if 'default'
% assert opponent pairs interact if 'opponent'
% - assert that pairs do interact
% - assert that non-pairs don't interact