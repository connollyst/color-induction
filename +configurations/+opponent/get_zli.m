function zli = get_zli()

    zli = configurations.defaults.get_zli();
    
    % Treat the ON & OFF values as interacting opponents
    zli.ON_OFF = 'abs';
    
    % Configure opponet color interactions
    zli.interaction.color.enabled           = true;
    zli.interaction.color.weight.excitation = 0.01;  % TODO determine appropriate value
    zli.interaction.color.weight.inhibition = 0.01;  % TODO determine appropriate value
    
end

