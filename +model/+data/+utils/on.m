function I_on = on( I )
    if iscell(I)
        I_on = cell(size(I));
        for i=1:length(I)
            I_on{i} = limit(I{i}, 0);
        end
    else
        I_on = limit(I, 0);
    end
end

function limited = limit(I, x)
    limited = I;
    limited(limited < x) = x;
end