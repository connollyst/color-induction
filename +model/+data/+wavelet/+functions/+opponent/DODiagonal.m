function RGBY_d = DODiagonal(rgb, config)
%DODIAGONAL Double Opponent (Diagonal)
%   Decomposes the RGB image into it's RGBY diagonal opponent components.
%
%   Input
%       rgb:    the original rgb image
%       config: the model configuration
%   Output
%       RGBY_h: the diagonal opponent color components in the format
%               RGBY_h(column, row, color, scale)

    RGBY_d = zeros(size(rgb,1), size(rgb,2), 4, config.wave.n_scales);

    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    
    for scale=1:config.wave.n_scales
        [r_tl_c, r_tr_c, r_br_c, r_bl_c] = centers(r, scale, config);
        [g_tl_c, g_tr_c, g_br_c, g_bl_c] = centers(g, scale, config);
        [b_tl_c, b_tr_c, b_br_c, b_bl_c] = centers(b, scale, config);

        [r_tl_s, r_tr_s, r_br_s, r_bl_s] = surrounds(r, scale, config);
        [g_tl_s, g_tr_s, g_br_s, g_bl_s] = surrounds(g, scale, config);
        [b_tl_s, b_tr_s, b_br_s, b_bl_s] = surrounds(b, scale, config);

        % Combine center surround signals to obtain color opponency..
        % TOP LEFT
        R_tl = model.data.utils.on(r_tl_c - (g_br_s + b_br_s)/2);
        G_tl = model.data.utils.on(g_tl_c - (r_br_s + b_br_s)/2);
        B_tl = model.data.utils.on(b_tl_c - (r_br_s + g_br_s)/2);
        Y_tl = model.data.utils.on((r_tl_c + g_tl_c)/2 - abs(r_br_s - g_br_s)/2 - b_br_s);
        % TOP RIGHT
        R_tr = model.data.utils.on(r_tr_c - (g_bl_s + b_bl_s)/2);
        G_tr = model.data.utils.on(g_tr_c - (r_bl_s + b_bl_s)/2);
        B_tr = model.data.utils.on(b_tr_c - (r_bl_s + g_bl_s)/2);
        Y_tr = model.data.utils.on((r_tr_c + g_tr_c)/2 - abs(r_bl_s - g_bl_s)/2 - b_bl_s);
        % BOTTOM RIGHT
        R_br = model.data.utils.on(r_br_c - (g_tl_s + b_tl_s)/2);
        G_br = model.data.utils.on(g_br_c - (r_tl_s + b_tl_s)/2);
        B_br = model.data.utils.on(b_br_c - (r_tl_s + g_tl_s)/2);
        Y_br = model.data.utils.on((r_br_c + g_br_c)/2 - abs(r_tl_s - g_tl_s)/2 - b_tl_s);
        % BOTTOM LEFT
        R_bl = model.data.utils.on(r_bl_c - (g_tr_s + b_tr_s)/2);
        G_bl = model.data.utils.on(g_bl_c - (r_tr_s + b_tr_s)/2);
        B_bl = model.data.utils.on(b_bl_c - (r_tr_s + g_tr_s)/2);
        Y_bl = model.data.utils.on((r_bl_c + g_bl_c)/2 - abs(r_tr_s - g_tr_s)/2 - b_tr_s);

        % Consolidate to get all diagonal color opponency..
        % TODO average? sum?
        R_d = max(max(max(R_tl, R_tr), R_br), R_bl);
        G_d = max(max(max(G_tl, G_tr), G_br), G_bl);
        B_d = max(max(max(B_tl, B_tr), B_br), B_bl);
        Y_d = max(max(max(Y_tl, Y_tr), Y_br), Y_bl);

        RGBY_d(:,:,1,scale) = R_d;
        RGBY_d(:,:,2,scale) = G_d;
        RGBY_d(:,:,3,scale) = B_d;
        RGBY_d(:,:,4,scale) = Y_d;
    end
end

function [tlc, trc, brc, blc] = centers(color, scale, config)
% Returns the top & bottom by left & right centers.
    tlc = model.data.utils.on(apply_top_left_center_filter      (color, scale, config));
    trc = model.data.utils.on(apply_top_right_center_filter     (color, scale, config));
    blc = model.data.utils.on(apply_bottom_left_center_filter   (color, scale, config));
    brc = model.data.utils.on(apply_bottom_right_center_filter  (color, scale, config));
end

function [tls, trs, brs, bls] = surrounds(color, scale, config)
% Returns the top & bottom by left & right surrounds.
    tls = model.data.utils.off(apply_top_left_surround_filter    (color, scale, config));
    trs = model.data.utils.off(apply_top_right_surround_filter   (color, scale, config));
    bls = model.data.utils.off(apply_bottom_left_surround_filter (color, scale, config));
    brs = model.data.utils.off(apply_bottom_right_surround_filter(color, scale, config));
end

function I_out = apply_top_left_center_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.center_top_left(scale, config) ...
             - model.data.wavelet.functions.opponent.rf.oriented.center_bottom_right(scale, config);
    I_out = gaussian(color, filter());
end

function I_out = apply_top_right_center_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.center_top_right(scale, config) ...
             - model.data.wavelet.functions.opponent.rf.oriented.center_bottom_left(scale, config);
    I_out = gaussian(color, filter());
end

function I_out = apply_bottom_right_center_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.center_bottom_right(scale, config) ...
             - model.data.wavelet.functions.opponent.rf.oriented.center_top_left(scale, config);
    I_out = gaussian(color, filter());
end

function I_out = apply_bottom_left_center_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.center_bottom_left(scale, config) ...
             - model.data.wavelet.functions.opponent.rf.oriented.center_top_right(scale, config);
    I_out = gaussian(color, filter());
end

function I_out = apply_top_left_surround_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.surround_top_left(scale, config) ...
             - model.data.wavelet.functions.opponent.rf.oriented.surround_bottom_right(scale, config);
    I_out = gaussian(color, filter());
end

function I_out = apply_top_right_surround_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.surround_top_right(scale, config) ...
             - model.data.wavelet.functions.opponent.rf.oriented.surround_bottom_left(scale, config);
    I_out = gaussian(color, filter());
end

function I_out = apply_bottom_right_surround_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.surround_bottom_right(scale, config) ...
             - model.data.wavelet.functions.opponent.rf.oriented.surround_top_left(scale, config);
    I_out = gaussian(color, filter());
end

function I_out = apply_bottom_left_surround_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.surround_bottom_left(scale, config) ...
             - model.data.wavelet.functions.opponent.rf.oriented.surround_top_right(scale, config);
    I_out = gaussian(color, filter());
end

function filtered = gaussian(img, filter)
    % Add padding
    pad_cols = ceil(size(img,1)/2);
    pad_rows = ceil(size(img,2)/2);
    padded   = padarray(img, [pad_cols, pad_rows], 'symmetric','both');
    % Apply filter
    padded_filtered = imfilter(padded, filter, 'same');
    % Remove padding
    cols = pad_cols+1:pad_cols+size(img,1);
    rows = pad_rows+1:pad_rows+size(img,2);
    filtered = padded_filtered(cols,rows);
end