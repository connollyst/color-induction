function y = gy(y)
%GY Sigmoid-like function modeling cells' firing rates in response to
%   membrane potential y.
%
%   Refer to Z. Li 1999 p209   
    Ly         = 1.2;
    g1         = 0.21;
    g2         = 2.5;
    y(y < 0)   = 0;
    y(y < Ly)  = g1*y(y < Ly);
    y(Ly <= y) = g1*Ly+g2*(y(Ly <= y)-Ly); % Z. Li
    % y(ind3)    = 0.252*Ly+g2*(y(ind3)-Ly); % Machecler
end