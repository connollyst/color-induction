function rf = get_rf()
%CONFIGURATIONS.OPPONENT.GET_RF The opponent receptive field configs.
    
    % The opponent process method
    rf.method             = 'rgb2itti'; % Options: 'rgb2opp', 'rgb2itti'
    
    % Single and double opponent receptive field configurations
    rf.so.size            = 50;
    rf.so.enabled         = true;
    rf.so.center.weight   = 1;
    rf.so.center.length   = 1;
    rf.so.center.width    = 0.5;
    rf.so.center.offset   = 0.25;
    rf.so.surround.weight = 0.4;
    rf.so.surround.length = 1;
    rf.so.surround.width  = 0.5;
    rf.so.surround.offset = 0.25;
    
    % Single and double opponent receptive field configurations
    rf.do.size            = 50;
    rf.do.enabled         = true;
    rf.do.center.weight   = 1;
    rf.do.center.length   = 1;
    rf.do.center.width    = 0.5;
    rf.do.center.offset   = 0.25;
    rf.do.surround.weight = 0.4;
    rf.do.surround.length = 1;
    rf.do.surround.width  = 0.5;
    rf.do.surround.offset = 0.25;
end