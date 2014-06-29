function res = optima_fft(data_fft, filter_fft, shift_size, avoid_circshift_fft)
%OPTIMA_FFT Apply the Fourier filter to the Fourier input data.
%   The Fourier filter is applied to the Fourier data and then the inverse
%   Fourier transform is applied to return the result.
%
%       data_fft:   the data to be filtered, already in Fourier space
%       filter_fft: the filer to be applied, already in Fourier space
%       shift_size: the shift size filter if avoiding FFT circshift
%       avoid_circshift_fft: 0/1 if we should compensate for FFT circhift

    conv_fft = data_fft.*filter_fft;
    res = ifftn(conv_fft, 'symmetric');
    if avoid_circshift_fft ~= 1
        res = circshift(res, -shift_size);
    end
end