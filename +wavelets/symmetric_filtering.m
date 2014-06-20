function b = symmetric_filtering(a, h)
% Filter a with h, using symmetric filtering at the edges, where extreme
% edges are not mirrored.
%
% outputs:
%   b: filtered matrix
%
% inputs:
%   a: input matrix
%   h: filter

    % Extent of padding is half radius of filter:
    pad_sz = floor(length(h)/2);

    a_padded = mirroring(a, pad_sz);                  % pad edges
    b_padded = imfilter(a_padded, h);                 % filter padded matrix
    b        = b_padded((pad_sz + 1):(end - pad_sz),(pad_sz + 1):(end - pad_sz),:); % remove padding

end

function mc = mirroring(w,n)
% Mirrors edges of the wavelet plane as a form of edge padding.
%
% outputs:
%   mc: padded wavelet plane
%
% inputs:
%   w: wavelet plane
%   n: extent of padding

    [c, r, ~] = size(w);

    A  = flipdim(w(2:(2+n-1),:,:),1);   % top padding
    B  = flipdim(w(c-n:c-1,:,:)  ,1);   % bottom padding
    mc = [A;w;B];                       % add padding

    A  = flipdim(mc(:,2:(2+n-1),:),2);  % left padding
    B  = flipdim(mc(:,r-n:r-1,:)  ,2);  % right padding
    mc = [A mc B];                      % add padding

end
