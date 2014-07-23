function pepperman = little_pepperman()
% Returns a small test image of represent an opponent color image
    pepperman  = im2double(imresize(imread('peppers.png'), 0.1));
    man        = im2double(imresize(imread('cameraman.tif'), 0.1));
    man_cols   = size(man, 1);
    man_rows   = size(man, 2);
    pepperman  = pepperman(1:man_cols, 1:man_rows);
    pepperman(:,:,4) = man;
end