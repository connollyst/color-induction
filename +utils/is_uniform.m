function uniform = is_uniform(input)
%IS_UNIFORM Determine if the input is uniform.
    if iscell(input)
        uniform = are_cells_uniform(input);
    else
        uniform = is_matrix_uniform(input);
    end
end

function uniform = are_cells_uniform(C)
    % TODO we need to check that all cells are the same as each other!
    uniform = is_matrix_uniform(C{1});
end

function uniform = is_matrix_uniform(M)
    uniform = max(M(:)) == min(M(:));
end