function x = gx(x)
%GX Sigmoid-like function modeling cells' firing rates in response to
%   membrane potential x.
%
%   Refer to Z. Li 1999 p209
    x      = x-1;
    x(x<0) = 0;
    x(x>1) = 1;
end