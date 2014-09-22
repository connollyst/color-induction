function g = gaussian(gsize, sigmax, sigmay, theta, offset, factor, center)
    g = model.data.rf.utils.customgauss(                                ...
            gsize, sigmax, sigmay, theta, offset, factor, center        ...
        );
    g = g / sum(g(:));
end

