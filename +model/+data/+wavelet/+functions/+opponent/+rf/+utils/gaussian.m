function g = gaussian(gsize, sigmax, sigmay, theta, offset, factor, center)
    g = model.data.wavelet.functions.opponent.rf.utils.customgauss(     ...
            gsize, sigmax, sigmay, theta, offset, factor, center        ...
        );
    g = g / sum(g(:));
end

