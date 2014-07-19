function zli = get_zli()

    zli = configurations.defaults.get_zli();
    
    % Treat the ON & OFF values as interacting opponents
    zli.ON_OFF = 'opponent';
    
    % Configure opponet color interactions
    zli.interaction.color.enabled  = false;
    zli.interaction.color.scheme   = 'opponent';
    zli.interaction.color.weight.excitation = 0.2;  % determine appropriate value
    zli.interaction.color.weight.inhibition = 0.2;  % determine appropriate value
    
end

