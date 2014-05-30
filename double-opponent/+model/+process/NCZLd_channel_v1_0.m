function [img_out] = NCZLd_channel_v1_0(img, config)
% from NCZLd_channel_v1_0.m to NCZLd_channel_ON_OFF_v1_1.m
% perform the wavelet decomposition and its inverse transform
% img: input image

    %-------------------------------------------------------
    % make the structure explicit
    n_membr  = config.zli.n_membr;
    n_scales = config.wave.n_scales;
    dynamic  = config.compute.dynamic;
    %-------------------------------------------------------
    
    config.wave.fin_scale = n_scales - config.zli.fin_scale_offset;
    
    [img_out, done] = check_for_uniformity(img, n_membr, dynamic);
    if done == 1
        return;
    end
    
    [curv, w, c] = utils.wavelet_decomposition(img, n_membr, n_scales, dynamic);

    curv_final   = model.process.NCZLd_channel_ON_OFF_v1_1(curv, config);

    img_out      = utils.wavelet_decomposition_inverse(img, w, c, curv_final, n_membr, n_scales);

end

function [img_out, done] = check_for_uniformity(img, n_membr, dynamic)
    if dynamic ~= 1
        img_out = zeros([size(img) n_membr]);
    else
        img_out = zeros(size(img));
    end
    % trivial case (if the image is uniform we do not process it!)
    if max(img(:)) == min(img(:))
        img_out = img_out + min(img(:)); % give the initial value to all the pixels
        done = 1;
    else
        done = 0;
    end
end


