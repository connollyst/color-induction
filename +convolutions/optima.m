function result = optima(data, filter, shift_size, fft_flag, avoid_circshift_fft)
%OPTIMA Apply the Fourier filter to the normal input data.
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
%       filter: the filer to be applied, already in Fourier space
%       shift_size: the shift size filter if avoiding FFT circshift
%       fft_flag:   0/1 if the filter is already in Fourier space
%       avoid_circshift_fft: 0/1 if we should compensate for FFT circhift

    if fft_flag == 1
        % Apply the Fourier filter to the normal data
        data_fft = fftn(data);
        result   = convolutions.optima_fft(data_fft, filter, shift_size, avoid_circshift_fft);
    else
        % Apply the normal filter to the normal data
        result = convn(data, filter, 'same');
    end
end