function C = to_cells( I )
%AS_CELLS Initialize the input image(s)
%   If it is a single image, return a 1x1 cell containg just that image.
%   If it is a cell array of images, return the cell array.
    if ~iscell(I)
        C = cell(1, 1);
        C{1} = I;
    else
        C = I;
    end
end

