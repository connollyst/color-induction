function test_suite = test_Rmodelinductiond
%Test suite for model.process.Rmodelinductiond_v*()
  initTestSuite;
end

function test_gx_final_01_ON
    assert_gx_final('01_ON')
end

function test_gx_final_01_OFF
    assert_gx_final('01_OFF')
end

%% ASSERTIONS

function assert_gx_final(instance)
    [Iitheta, config] = get_input(instance);
    expected = get_expected(instance);
    gx_final = model.process.Rmodelinductiond_v0_3_2(Iitheta, config);
    assertEqualCells(gx_final, expected.gx_final);
end

%% TEST UTILITIES

function [Iitheta, config] = get_input(instance)
    input   = load(['data/input_to_Rmodelinductiond_',instance,'.mat']);
    Iitheta = addColorDimension(input.Iitheta);
    state   = load('data/state_UpdateXY.mat');
    config  = state.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected_from_Rmodelinductiond_',instance,'.mat']);
end