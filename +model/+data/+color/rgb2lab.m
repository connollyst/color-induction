function lab = rgb2lab(rgb)
% Takes RGB input and converts it to the CIELAB opponent colorspace. Note
% that the opponent components are separated into their own channels.
    
    % Transform to regular L*a*b*
    % L*: values closer to 0 are 'darker', closer to 100 are 'lighter'
    % a*: negative values are 'greener' and positive values are 'redder'
    % b*: negative values are 'bluer' and positive values are 'yellower'
    cform      = makecform('srgb2lab');
    lab        = lab2double(applycform(rgb, cform));
    % Shift lightness/darkness to a range of -50/50
    lab(:,:,1) = lab(:,:,1) - 50;
end