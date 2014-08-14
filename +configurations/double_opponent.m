function config = double_opponent()
    config     = configurations.default();
    config.rf  = configurations.opponent.get_rf();
    config.zli = configurations.opponent.get_zli();
end