function old = new_to_old(new)
%NEW_TO_OLD This is a total hack and should be deleted SOON!
%   Converts the new cell array data structure to the old multi-dimensional
%   matrix data structure. Note that the old structure only handles a
%   single color dimension, here we use the first color dimension from the
%   new data structure.

    n_scales  = 2;
    n_orients = 3;
    old = zeros(64, 64, 2, 3);
    for s=1:n_scales
        for o=1:n_orients
            old(:,:,s,o) = new{o,s}(:,:,1);
        end
    end
end