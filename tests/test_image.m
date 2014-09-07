function rgb = test_image(name, width)
    switch name
        case 'default'
            rgb = make_default(width);
        case 'lightness contrast A'
            rgb = make_lightness_contrast_a(width);
        case 'lightness contrast B'
            rgb = make_lightness_contrast_b(width);
        case 'crispening effect A'
            rgb = make_crispening_effect_a(width);
        case 'crispening effect B'
            rgb = make_crispening_effect_b(width);
        case 'crispening effect C'
            rgb = make_crispening_effect_c(width);
        case 'isoluminant red green A'
            rgb = make_isoluminant_red_green_a(width);
        case 'isoluminant red green B'
            rgb = make_isoluminant_red_green_b(width);
        otherwise
            error(['Unknown test image: ',name]);
    end
end

%% DEFAULT TEST IMAGE

function rgb = make_default(w)
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
end

%% LIGHTNESS CONTRAST TEST IMAGES

function rgb = make_lightness_contrast_a(w)
    hsv_outer = [340/360, 0.35, 0.52];
    hsv_inner = [340/360, 0.35, 0.72];
    hsv = squares(w, hsv_outer, hsv_inner);
    rgb = hsv2rgb(hsv);
end

function rgb = make_lightness_contrast_b(w)
    hsv_outer = [340/360, 0.35, 0.92];
    hsv_inner = [340/360, 0.35, 0.72];
    hsv = squares(w, hsv_outer, hsv_inner);
    rgb = hsv2rgb(hsv);
end

function hsv = squares(width, hsv_outer, hsv_inner)
    hsv                = zeros(width, width, 3);
    hsv(:,:,1)         = hsv_outer(1);
    hsv(:,:,2)         = hsv_outer(2);
    hsv(:,:,3)         = hsv_outer(3);
    third_width        = floor(width/3);
    inner              = third_width:width-third_width;
    hsv(inner,inner,1) = hsv_inner(1);
    hsv(inner,inner,2) = hsv_inner(2);
    hsv(inner,inner,3) = hsv_inner(3);
end

%% CRISPENING EFFECT TEST IMAGES

function rgb = make_crispening_effect_a(w)
    rgb_outer     = [  0,   0,   0];
    rgb_inner_one = [114, 134, 117];
    rgb_inner_two = [ 99, 118, 101];
    rgb = double_squares(w, rgb_outer, rgb_inner_one, rgb_inner_two);
end

function rgb = make_crispening_effect_b(w)
    rgb_outer     = [104, 123, 106];
    rgb_inner_one = [114, 134, 117];
    rgb_inner_two = [ 99, 118, 101];
    rgb = double_squares(w, rgb_outer, rgb_inner_one, rgb_inner_two);
end

function rgb = make_crispening_effect_c(w)
    rgb_outer     = [255, 255, 255];
    rgb_inner_one = [114, 134, 117];
    rgb_inner_two = [ 99, 118, 101];
    rgb = double_squares(w, rgb_outer, rgb_inner_one, rgb_inner_two);
end

function rgb = double_squares(width, rgb_outer, rgb_inner_one, rgb_inner_two)
    rgb                              = zeros(width*2, width, 3);
    rgb(:,:,1)                       = rgb_outer(1);
    rgb(:,:,2)                       = rgb_outer(2);
    rgb(:,:,3)                       = rgb_outer(3);
    third_width                      = floor(width/3);
    inner_cols                       = third_width:width-third_width;
    inner_rows_one                   = inner_cols;
    inner_rows_two                   = inner_rows_one+width;
    rgb(inner_rows_one,inner_cols,1) = rgb_inner_one(1);
    rgb(inner_rows_one,inner_cols,2) = rgb_inner_one(2);
    rgb(inner_rows_one,inner_cols,3) = rgb_inner_one(3);
    rgb(inner_rows_two,inner_cols,1) = rgb_inner_two(1);
    rgb(inner_rows_two,inner_cols,2) = rgb_inner_two(2);
    rgb(inner_rows_two,inner_cols,3) = rgb_inner_two(3);
    rgb                              = rgb / 255;
end

%% ISOLUMINANT SQUARES

function rgb = make_isoluminant_red_green_a(w)
    hsv_outer = [360/360, 0.8, 0.90];
    hsv_inner = [140/360, 0.8, 0.90];
    hsv = squares(w, hsv_outer, hsv_inner);
    rgb = hsv2rgb(hsv);
end

function rgb = make_isoluminant_red_green_b(w)
    hsv_outer = [330/360, 0.8, 0.90];
    hsv_inner = [140/360, 0.8, 0.90];
    hsv = squares(w, hsv_outer, hsv_inner);
    rgb = hsv2rgb(hsv);
end