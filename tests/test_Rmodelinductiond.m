function test_suite = test_Rmodelinductiond
%Test suite for model.process.Rmodelinductiond_v*()
  initTestSuite;
end

function test_gx_final_3D_ON
    assert_gx_final('3D_ON')
end

function test_gx_final_3D_OFF
    assert_gx_final('3D_OFF')
end

%% ASSERTIONS

function assert_gx_final(instance)
    [Iitheta, config] = get_input(instance);
    expected = get_expected(instance);
    gx_final = model.process.Rmodelinductiond_v0_3_2(Iitheta, config);
    assertEqualData(gx_final, expected.gx_final);
end

%% TEST UTILITIES

function [Iitheta, config] = get_input(instance)
    input   = load(['data/input/Rmodelinductiond_',instance,'.mat']);
    Iitheta = input.Iitheta;
    config  = input.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected/Rmodelinductiond_',instance,'.mat']);
end