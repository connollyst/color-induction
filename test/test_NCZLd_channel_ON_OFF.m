function test_suite = test_NCZLd_channel_ON_OFF
%Test suite for model.process.NCZLd_channel_ON_OFF_v*()
  initTestSuite;
end

function test_NCZLd_channel_ON_OFF_01
    assert_NCZLd_channel_ON_OFF('01')
end

%% ASSERTIONS

function assert_NCZLd_channel_ON_OFF(instance)
    [Iitheta, config] = get_input(instance);
    actual = model.process.NCZLd_channel_ON_OFF_v1_1(Iitheta, config);
    expected = get_expected(instance);
    assertEqual(length(actual), length(expected), 'cell arrays should be the same length');
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    n_membr    = config.zli.n_membr;
    for t=1:n_membr
        % Note: current tests assert with data from the old algorithm, we
        %       need to transform the data for comparison.
        for s=1:n_scales
            for o=1:n_orients
                nextActual   = actual{t}(:,:,1,s,o);
                nextExpected = expected{t}{s}{o};
                assertEqual(nextActual, nextExpected, ...
                    ['expected same response at t=', num2str(t), ', s=', num2str(s), ', o=', num2str(o)] ...
                );
            end
        end
    end
end

%% TEST UTILITIES

function [Iitheta, config] = get_input(instance)
    input   = load(['data/input_to_NCZLd_channel_ON_OFF_',instance,'.mat']);
    Iitheta = addColorDimension(input.curv);
    state   = load('data/state_UpdateXY.mat');
    config  = state.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected_from_NCZLd_channel_ON_OFF_',instance,'.mat']);
    expected = expected.curv_final_out;
end