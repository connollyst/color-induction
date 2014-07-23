function config = double_opponent()
    config     = configurations.default();
    config.zli = configurations.opponent.get_zli();
end