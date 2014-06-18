function O = addColorDimension(I)
    c = size(I, 1);
    r = size(I, 2);
    s = size(I, 3);
    o = size(I, 4);
    O = zeros(c, r, 1, s, o);
    O(:,:,1,:,:) = I;
end