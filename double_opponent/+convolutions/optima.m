function res = optima(data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft)
%  Performs discrete (using convn) or FFT (fftfilt) convolution depending
%  on data and filter sizes
    if fft_flag == 1
        data_fft = fftn(data);
        conv_fft = data_fft.*filter_fft;
        % TODO should we be using ifftn here?
        res = ifftn(conv_fft, 'symmetric');
        if avoid_circshift_fft ~= 1
            res = circshift(res, -half_size_filter);
        end
    else
        res = convn(data, filter_fft, 'same');
    end
end