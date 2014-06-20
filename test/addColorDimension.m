function O = addColorDimension(I)
    if iscell(I)
        O = cell(size(I));
        for i=1:length(I)
            O{i} = addColorDimension(I{i});
        end
    else
        c = size(I, 1);
        r = size(I, 2);
        s = size(I, 3);
        o = size(I, 4);
        O = zeros(c, r, 1, s, o);
        O(:,:,1,:,:) = I;
    end
end