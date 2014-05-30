function [res] = convolucio_optima (data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft)
%  Performs discrete (using convn) or FFT (fftfilt) convolution depending
%  on data and filter sizes
    if fft_flag == 1
        data = fftn(data);
    end
    res = convolucio_optima_fft (data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft);
end