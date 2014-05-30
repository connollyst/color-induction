function [img_out] = NCZLd_channel_v1_0(img_in, struct)
% from NCZLd_channel_v1_0.m to NCZLd_channel_ON_OFF_v1_1.m
% perform the wavelet decomposition and its inverse transform
% img_in: monochromatic input image (i.e. one channel)

    %-------------------------------------------------------
    % make the structure explicit
    zli      = struct.zli;
    wave     = struct.wave;
    compute  = struct.compute;
    % struct.zli
    n_membr  = zli.n_membr;
    % struct.wave
    n_scales = wave.n_scales;
    % struct.compute
    dynamic  = compute.dynamic;
    %-------------------------------------------------------

    % scales we consider
    ini_scale = zli.ini_scale 
    fin_scale = n_scales - zli.fin_scale_offset
    struct.wave.fin_scale = fin_scale;
    % preallocation
    if dynamic ~= 1
        img_out = zeros([size(img_in) n_membr]);
    else
        img_out = zeros(size(img_in));
    end
    % trivial case (if the image is uniform we do not process it!)
    if max(img_in(:)) == min(img_in(:))
        img_out = img_out + min(img_in(:)); % give the initial value to all the pixels
        % 	iFactor = img_in*0;
        return;
    end

    % image
    img = double(img_in); % obsolete?

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% wavelet decomposition %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    curv=cell([zli.n_membr,n_scales,1]);

    % number of wavelet decompositions to perform
    if dynamic==1
        niter_wav=n_membr;
    else
        niter_wav=1;
    end
    
    % different wavelet decompositions		
    for ff=1:niter_wav
      [w, c] = a_trous(img(:,:,ff), n_scales-1);
        for s=1:n_scales-1
            for o=1:3
                curv{ff}{s}{o}=w{s}(:,:,o);
            end
        end
        curv{ff}{n_scales}{1}=c{n_scales-1};
    end
    iFactor = curv;
    
    % replicate wavelet planes if static stimulus
    if dynamic ~= 1
        for s=1:n_scales
            for o=1:size(curv{1}{s},2)
                for ff=2:n_membr
                    curv{ff}{s}{o}=curv{1}{s}{o};
                end
            end
        end
    end

    % display img and curv if needed
    if(struct.display_plot.plot_io==1)
        Mostrar_img_video(img,struct.display_plot.y_video, struct.display_plot.x_video);
        Mostrar_curv_video_POOL(curv,n_scales,1, struct.display_plot.y_video, struct.display_plot.x_video);
    end

    % mean value of residual planes
    if fin_scale==n_scales
        for ff=1:n_membr
            mean_orig{ff}=mean(curv{ff}{n_scales}{1}(:));
        end
    end

    % wavelet decomposition output
    curv_final = curv;			% in order to define it with the same structure
    iFactor    = curv;          % in order to define it with the same structure
    for ff=1:n_membr
        for scale=1:n_scales
            n_orient=size(iFactor{ff}{scale},2);
            for o=1:n_orient
                iFactor{ff}{scale}{o}(:)=1.;
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% here is the CORE of the process -> NCZLd_channel_ON_OFF_v1_1 %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    curv_final = NCZLd_channel_ON_OFF_v1_1(curv,struct);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%   end of the core   %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    % number of frames (among the last ones) we use when we consider the mean
    ff_ini  = 1;
    ff_fin  = n_membr;
    % prepare output image
    img_out = zeros(size(img,1), size(img,2), ff_fin-ff_ini+1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% inverse wavelet decomposition %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % N.B.: we only perform the inverse wavelet transform of the frames used for computing the
    % mean, and NOT of all the sequence!

    % inverse transform
    for ff=ff_ini:ff_fin
       for s=1:n_scales-1
            for o=1:3
                w{s}(:,:,o)=curv_final{ff}{s}{o};
            end
       end
       c{n_scales-1}=curv_final{ff}{n_scales}{1};
       img_out(:,:,ff) = Ia_trous(w,c);
    end

    % 0/1 display it all
    if(struct.display_plot.plot_io==1)
        Mostrar_curv_video_POOL(curv_final,n_scales,1, struct.display_plot.y_video, struct.display_plot.x_video);
    end
end


 

