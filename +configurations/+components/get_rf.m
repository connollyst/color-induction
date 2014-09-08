function rf = get_rf()
%CONFIGURATIONS.OPPONENT.GET_RF The opponent receptive field configs.
    
    rf.single          = true;
    rf.double          = true;
    
    % The size of the filter, not the gaussian itself
    rf.size            = 50;
    
    % Single and double opponent receptive field configurations
    rf.center.weight   = 1;
    rf.center.length   = 1;
    rf.center.width    = 0.5;
    rf.center.offset   = 5;
    rf.surround.weight = 0.95; % Lennie & Haake
    rf.surround.length = 1;
    rf.surround.width  = 0.5;
    rf.surround.offset = 5; 
end