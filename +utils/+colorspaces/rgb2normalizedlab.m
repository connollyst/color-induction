function lab = rgb2normalizedlab(rgb)
%RGB2NORMALIZEDLAB Convert the RGB image to L*a*b* color space, normalized.
%   The output image is in the L*a*b* color space, but the values are
%   normalized to be between 0 and 255 in all channels. This is important
%   so as to avoid negative or very large numbers while processing the
%   image.
    
    lab = lab2uint8(applycform(rgb, makecform('srgb2lab')));
    
end
