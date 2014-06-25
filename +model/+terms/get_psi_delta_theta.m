function psi_delta_theta = get_psi_delta_theta()
% Orientation interaction limits
%   Based on Z. Li 1999, p209
    a               = pi/4;
    b               = pi/2;
    delta_theta     = [0 a b; a 0 a ; b a 0];
    psi_delta_theta = cos(abs(delta_theta)).^6;
end
