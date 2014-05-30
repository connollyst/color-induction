function res = optima_fft(data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft)
%  Performs discrete (using convn) or FFT (fftfilt) convolution depending
%  on data and filter sizes
    if fft_flag == 1
        conv_fft = data.*filter_fft;
        % TODO should we NOT be using ifftn here?
        res = ifft(conv_fft, 'symmetric');
        if avoid_circshift_fft ~= 1
            res = circshift(res, -half_size_filter);
        end
    else
        res = convn(data, filter_fft, 'same');
    end
end