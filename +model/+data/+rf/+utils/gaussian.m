function g = gaussian(gsize, sigmax, sigmay, theta, offset, factor, center)
    g = model.data.rf.utils.customgauss(                                ...
            gsize, sigmax, sigmay, theta, offset, factor, center        ...
        );
    % Normalize so area under gaussian is 1
    g = g / sum(g(:));
end

