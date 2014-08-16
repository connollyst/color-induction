function [rgb, lab] = make_test_image(w)
    h = w/2;
    [t, l] = deal(1:h);
    [b, r] = deal(h+1:w);
    c = h-(h/4):h+(h/4);
    rgb = zeros(w, w, 3);
    % TL: Red
    rgb(t, l, 1) = 1;
    % TR: Green
    rgb(t, r, 2) = 1;
    % BR: Blue
    rgb(b, r, 3) = 1;
    % BL: Yellow
    rgb(b, l, [1,2]) = 1;
    % Center: Fuschia
    rgb(c, c, 2) = 0;
    rgb(c, c, [1,3]) = 1;
    % Convert to L*a*b* space
    C = makecform('srgb2lab');
    lab = applycform(rgb,C);
end