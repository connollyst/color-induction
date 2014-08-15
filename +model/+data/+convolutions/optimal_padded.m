function result = optimal_padded(data, filter, varargin)
%OPTIMAL_PADDED Pad the input data and apply the Fourier filter.
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
    
    cols_data = size(data,1);
    rows_data = size(data,2);
    cols_filter = size(filter,1);
    rows_filter = size(filter,2);
    % Add padding appropriate for image
    cols_padding = max(ceil(cols_data/2), ceil(cols_filter/2));
    rows_padding = max(ceil(rows_data/2), ceil(rows_filter/2));
    padded = padarray(data, [cols_padding, rows_padding], 'symmetric', 'both');
    % Apply filter
    filtered = model.data.convolutions.optimal(padded, filter, varargin{:});
    % Remove padding
    cols_padding = cols_padding+1 : cols_padding+cols_data;
    rows_padding = rows_padding+1 : rows_padding+rows_data;
    result = filtered(cols_padding,rows_padding);
end