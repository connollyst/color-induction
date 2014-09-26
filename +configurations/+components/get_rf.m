function rf = get_rf()
%CONFIGURATIONS.OPPONENT.GET_RF The opponent receptive field configs.
    
    % The opponent process method
    % Options: 'rgb2opp'  (presented in thesis)
    %          'rgb2itti' (based on L. Itti's color equations)
    rf.method             = 'rgb2opp';
    
    % Single and double opponent receptive field configurations
    rf.so.size            = 100;
    rf.so.enabled         = true;
    rf.so.center.weight   = 1;
    rf.so.center.width    = 0.5;
    rf.so.surround.weight = 0.4;
    rf.so.surround.width  = 0.75;
    
    % Single and double opponent receptive field configurations
    rf.do.size            = 100;
    rf.do.enabled         = true;
    rf.do.center.weight   = 1;
    rf.do.center.length   = 1;
    rf.do.center.width    = 0.5;
    rf.do.center.offset   = 0.25;
    rf.do.surround.weight = 0.5;
    rf.do.surround.length = 1;
    rf.do.surround.width  = 0.5;
    rf.do.surround.offset = 0.25;
end