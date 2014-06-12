function new = old_to_new(old)
%OLD_TO_NEW This is a total hack and should be deleted SOON!
%   Converts old multi-dimensional matrix data structure to the new cell
%   array data structure.

    n_scales  = 2;
    n_orients = 3;
    new = cell(n_orients, n_scales);
    for s=1:n_scales
        for o=1:n_orients
            new{o,s} = zeros(64, 64, 3);
            new{o,s}(:,:,1) = old(:,:,s,o);
            new{o,s}(:,:,2) = old(:,:,s,o);
            new{o,s}(:,:,3) = old(:,:,s,o);
        end
    end
end