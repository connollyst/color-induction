function neigbor_filter = filter_neighbors(a, b)
%MODEL.TERMS.INTERACTIONS.FILTER_NEIGHBORS
% Returns a filter which models equal interaction between all channels.
% The influence from other channels is mediated by the configured weight.
    
    % TODO this is hard coded for color!! can be reused for scales.
    neigbor_filter = zeros(1, 1, 3, 1, 1);
    neigbor_filter(1, 1, :, 1, 1) = [b a b];
end