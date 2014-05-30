function X = newgy(X)
    Ly = 1.2;
    g1 = 0.21;
    g2 = 2.5;

    X(X < 0)   = 0;
    X(X < Ly)  = g1*X(X < Ly);
    X(Ly <= X) = g1*Ly+g2*(X(Ly <= X)-Ly); % Li
    % X(ind3)    = 0.252*Ly+g2*(X(ind3)-Ly); % Machecler
end