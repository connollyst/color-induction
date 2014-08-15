function result = optimal(data, filter, varargin)
%OPTIMAL Apply the Fourier filter to the normal input data.
%   An FFT is applied to the normal input data and then convoluted with the
%   filter. If fft_flag is 1, it is assumed that the filter is already in
%   Fourier space. The inverse Fourier transform is applied to return the
%   result.
%
%   Note: if using this function frequently with the same filter, it is
%         best to first apply an FFT to the filter so as to avoid
%         repeatedly doing so herein.
%
%       data:       the data to be filtered, in normal data space
%       filter:     the filer to be applied, already in Fourier space
%       shift_size: the shift size filter if avoiding FFT circshift
%       fft_flag:   0/1 if the filter is already in Fourier space
%       avoid_circshift_fft: 0/1 if we should compensate for FFT circhift

    if isempty(varargin)
        shift_size          = 0;
        fft_flag            = 0;
        avoid_circshift_fft = 0;
    else
        if length(varargin) == 3
            shift_size          = varargin{1};
            fft_flag            = varargin{2};
            avoid_circshift_fft = varargin{3};
        else
            error('Incorrect use: either specify all FFT args or none.');
        end
    end
    if fft_flag == 1
        % Apply the Fourier filter to the normal data
        data_fft = fftn(data);
        conv_fft = data_fft.*filter;
        result = ifftn(conv_fft, 'symmetric');
        if avoid_circshift_fft ~= 1
            result = circshift(result, -shift_size);
        end
    else
        % Apply the normal filter to the normal data
        result = convn(data, filter, 'same');
    end
end