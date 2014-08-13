function [I, R, G, B, Y] = IRGBY(img)
%RGBY Separate RGB image into intensity (I), red (R), green (G), blue (B),
%     and yellow (Y) components according to the transformations defined in
%     Itti L, Kock C, Niebur E (1998) A model of saliency-based visual
%     attention for rabid scene analysis. IEEE Transactions on Pattern
%     Analysis and Machiene Intelligence 20:1254-1259
    img = im2double(img);
    
    r = img(:,:,1);
    g = img(:,:,2);
    b = img(:,:,3);
    
    I = (r + b + g)/3;
    
    r = normalize(r, I);
    g = normalize(g, I);
    b = normalize(b, I);

    R = utils.on(r - (g + b)/2);
    G = utils.on(g - (r + b)/2);
    B = utils.on(b - (r + g)/2);
    Y = utils.on((r + g)/2 - abs(r - g)/2 - b);
    
    figure()
    subplot(3, 2, 1), imshow(img);
    subplot(3, 2, 2), imagesc(I), colormap('gray'), title('intensity');
    subplot(3, 2, 3), imagesc(R), colormap('gray'), title('red');
    subplot(3, 2, 4), imagesc(G), colormap('gray'), title('green');
    subplot(3, 2, 5), imagesc(B), colormap('gray'), title('blue');
    subplot(3, 2, 6), imagesc(Y), colormap('gray'), title('yellow');
end

function n = normalize(channel, I)
% Normalize channel (r, g, or b) by I.
%   "..because hue variations are not perceivable at very low luminance ...
%   normalization is only applied at the locations where I is larger than
%   1/10 of its maximum over the entire image."
%   - L. Itti, 1998, p. 1255
    m = max(I(:)) / 10;
    I(I < m) = 1;
    n = channel./I;
end