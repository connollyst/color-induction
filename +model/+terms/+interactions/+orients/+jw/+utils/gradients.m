function [x_gradient, y_gradient] = gradients(delta)
%GRADIENTS Summary of this function goes here
%   Detailed explanation goes here

    x_gradient = repmat([(-delta:1:delta)],  2*delta+1, 1);
    y_gradient = repmat([(-delta:1:delta)]', 1,         2*delta+1);
end

