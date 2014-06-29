function res = optima_fft(data_fft, filter_fft, half_size_filter, avoid_circshift_fft)
%  Performs discrete (using convn) or FFT (fftfilt) convolution depending
%  on data and filter sizes
    conv_fft = data_fft.*filter_fft;
    % TODO should we NOT be using ifftn here?
    res = ifft(conv_fft, 'symmetric');
    if avoid_circshift_fft ~= 1
        res = circshift(res, -half_size_filter);
    end
end