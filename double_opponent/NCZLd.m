function [img_out] = NCZLd(img, struct)
    % Track processing time
    t_ini = tic;
    
    % Display input image dimensions
    img_width  = size(img, 1);
    img_height = size(img, 2);
    fprintf('Image size: %ix%i\n', img_width, img_height);
    
    %-------------------------------------------------------
    % get the structure/parameters
    zli      = struct.zli;
    compute  = struct.compute;
    image    = struct.image;
    n_membr  = zli.n_membr;
    n_scales = struct.wave.n_scales;
    mida_min = struct.wave.mida_min;
    dynamic  = compute.dynamic;
    %-------------------------------------------------------
    
    % calculate number of scales (n_scales) automatically
    if n_scales == 0
        if zli.fin_scale_offset == 0
            % parameter to adjust the correct number of the last wavelet plane (obsolete)
            extra = 2;
        else
            extra = 3;
        end
        % TODO scales should be calculated using all dimensions
        n_scales = floor(log(max(size(img(:,:,1))-1)/mida_min)/log(2)) + extra;
    end
    struct.wave.n_scales = n_scales;
    
    %-------------------------------------------------------

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% NCZLd for every channel %%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    img_out_tmp = NCZLd_channel_v1_0(double(img), struct);

    % do/don't store img and img_out (warning: img_out is 4D in the dynamical case!)
    if struct.display_plot.store_img_img_out==1
        save([image.name, '_img.mat'],'img')
        save([image.name, '_img_out.mat'],'img_out')
     end

    % static case
    if dynamic == 0
        % take the mean (see Li, 1999)
        n_frames_promig = struct.image.n_frames_promig;
        ff_ini          = n_membr-n_frames_promig+1;
        ff_fin          = n_membr;
        img_out         = mean(img_out_tmp(:,:,ff_ini:ff_fin), 3);
    end

    % time
    toc(t_ini)
end
