function config = disabled()
% Configured with all interactions (orientation, scale, & color) disabled.
    config = configurations.default();
    config.zli.interaction.orient.enabled = false;
    config.zli.interaction.scale.enabled  = false;
    config.zli.interaction.color.enabled  = false;
end