function display = get_display()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% display plot/store    %%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    display.logging             = 1;        % display log messages
    display.plot                = 1;        % display plots
    display.plot_io             = 1;        % plot input/output
    display.reduce              = 0;        % 0 all (9)/ 1 reduced ; useless if single_or_multiple=1
    display.plot_wavelet_planes = 0;        % plot wavelet planes
    display.store               = 1;        % 0 don't store/ 1 store
    display.y_video             = 0.5;
    display.x_video             = 68/128;
end