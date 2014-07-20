Color Induction Tests
=====================

This directory contains all tests for the provided code. The tests are
separated into _unit tests_ and _integration tests_; the former focusing on
individual functions, and the latter containing full executions of the
model.

The unit tests prove to be much easier to interpret, while the integration
tests are essential to validate the functionality of the model.

To run either the unit or integration tests, first ensure that the
`tests/` directory, and all it's subdirectories, are added to your path.

### Run all tests
```
runtests unit_tests
runtests integration_tests
```

### Run a specific test suite
```
runtests unit_tests.model.data.wavelet.test_decomposition
runtests integration_tests.test_apply_model
```

### Run a specific test
```
runtests unit_tests.model.data.wavelet.test_decomposition:test_replication_of_single_image
runtests integration_tests.test_apply_model:test_separate_and_opponent_ON_OFF_without_channel_interactions
```