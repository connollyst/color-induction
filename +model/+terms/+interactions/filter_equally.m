function equal_filter = filter_equally(count, weight)
%MODEL.TERMS.INTERACTIONS.FILTER_EQUALLY
% Returns a filter which models equal interaction between all channels.
% The influence from other channels is mediated by the configured weight.
    weights        = (count-1) * weight;
    if weights > 1
        error('Cannot create filter where weights sum greater than 1.');
    end
    count          = to_odd(count);
    center         = round(count / 2);
    filter         = ones(count, 1) * weight;
    filter(center) = 1 - weights;
    equal_filter   = zeros(1, 1, count, 1, 1);  % TODO hard coded for color!
    equal_filter(1,1,:,1,1) = filter;
end

function odd = to_odd(num)
% We want a symmetrical filter so round up to the nearest odd number.
    odd = 2.*round((num+1)/2)-1;
end