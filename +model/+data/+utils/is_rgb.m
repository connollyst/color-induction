function flag = is_rgb(I)
    flag = true;
    if iscell(I)
        for i=1:length(I)
            if ~is_rgb_matrix(I{i})
                flag = false;
            end
        end
    else
        if ~is_rgb_matrix(I)
            flag = false;
        end
    end
end

function flag = is_rgb_matrix(I)
    flag = true;
    if ndims(I) ~= 3
        flag = false;
    else 
        if size(I,3) ~= 3
            flag = false;
        end
    end
end