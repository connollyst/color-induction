function [img_out] = NCZLd_channel_v1_0(img, struct)
% from NCZLd_channel_v1_0.m to NCZLd_channel_ON_OFF_v1_1.m
% perform the wavelet decomposition and its inverse transform
% img: input image

    %-------------------------------------------------------
    % make the structure explicit
    zli      = struct.zli;
    n_membr  = struct.zli.n_membr;
    n_scales = struct.wave.n_scales;
    dynamic  = struct.compute.dynamic;
    %-------------------------------------------------------

    % scales we consider
    ini_scale = zli.ini_scale 
    fin_scale = n_scales - zli.fin_scale_offset
    struct.wave.fin_scale = fin_scale;
    
    [img_out, done] = preallocate_img_out(img, n_membr, dynamic);
    if done == 1
        return;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% wavelet decomposition %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % TODO why are w & c needed for inverse transformation?
    [curv, w, c] = utils.wavelet_decomposition(img, n_membr, n_scales, dynamic);

    % display img and curv if needed
    if(struct.display_plot.plot_io==1)
        Mostrar_img_video(img,struct.display_plot.y_video, struct.display_plot.x_video);
        Mostrar_curv_video_POOL(curv,n_scales,1, struct.display_plot.y_video, struct.display_plot.x_video);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% here is the CORE of the process -> NCZLd_channel_ON_OFF_v1_1 %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    curv_final = model.process.NCZLd_channel_ON_OFF_v1_1(curv,struct);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%   end of the core   %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% inverse wavelet decomposition %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    img_out = utils.wavelet_decomposition_inverse(img, w, c, curv_final, n_membr, n_scales);

    % 0/1 display it all
    if(struct.display_plot.plot_io==1)
        Mostrar_curv_video_POOL(curv_final,n_scales,1, struct.display_plot.y_video, struct.display_plot.x_video);
    end
end

function [img_out, done] = preallocate_img_out(img, n_membr, dynamic)
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


