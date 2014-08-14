function rf = get_rf()
%CONFIGURATIONS.OPPONENT.GET_RF The opponent receptive field configs.

    % The size of the filter, not the gaussian.
    rf.size              = 50;
    
    % Single and double opponent receptive field configurations.
    % Note: excitation/inhibition generally refers to center/surround,
    %       respectively, though those terms aren't appropriate in double
    %       opponent cells.
    % TODO ..neither is excitatory/inhibitory Sean
    rf.excitation.weight = 0.5;
    rf.excitation.length = 1;
    rf.excitation.width  = 0.5;
    rf.excitation.offset = 5;
    rf.inhibition.weight = 0.5;
    rf.inhibition.length = 1;
    rf.inhibition.width  = 0.5;
    rf.inhibition.offset = 5;
    
end

