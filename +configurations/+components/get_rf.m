function rf = get_rf()
%CONFIGURATIONS.OPPONENT.GET_RF The opponent receptive field configs.
    
    % The opponent process method
    % Options: 'rgb2opp'  (presented in thesis)
    %          'rgb2itti' (based on L. Itti's color equations)
    rf.method             = 'rgb2opp';
    
    % Single and double opponent receptive field configurations
    rf.so.enabled         = true;
    rf.so.size            = 50;
    rf.so.center.weight   = 1.0;
    rf.so.surround.weight = 0.3;
    rf.so.center.width    = 0.5;
    rf.so.surround.width  = 1.0;
    
    % Single and double opponent receptive field configurations
    rf.do.enabled         = true;
    rf.do.size            = 100;
    rf.do.center.weight   = 1;
    rf.do.center.length   = 1;
    rf.do.center.width    = 0.5;
    rf.do.center.offset   = 0.25;
    rf.do.surround.weight = 0.5;
    rf.do.surround.length = 1;
    rf.do.surround.width  = 0.5;
    rf.do.surround.offset = 0.25;
end