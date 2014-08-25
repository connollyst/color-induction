function LAB = rgb2lab(rgb)
% Takes RGB input and converts it to the CIELAB opponent colorspace. Note
% that the opponent components are separated into their own channels.
    n_cols     = size(rgb, 1);
    n_rows     = size(rgb, 2);
    n_channels = 6; % L* on & off, a* on & off, b* at on & off
    LAB        = zeros(n_cols, n_rows, n_channels);
    
    % Transform to regular l*a*b*
    % L*: values closer to 0 are 'darker', closer to 100 are 'lighter'
    % a*: negative values are 'greener' and positive values are 'redder'
    % b*: negative values are 'bluer' and positive values are 'yellower'
    cform      = makecform('srgb2lab');
    lab        = lab2double(applycform(rgb, cform));
    lab(:,:,1) = lab(:,:,1) - 50;   % Lightness from 0/100 to -50/50
    
    lab_on  = model.data.utils.on(lab);
    lab_off = model.data.utils.off(lab);
    
    odds    = 1:2:n_channels;
    evens   = 2:2:n_channels;
    
    LAB(:,:,odds)  = lab_on;
    LAB(:,:,evens) = lab_off;
end