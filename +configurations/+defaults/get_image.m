function image = get_image(zli)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  stimulus (image, name...) %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    image.n_frames_promig = zli.n_membr-1;  % number iterations (from the last one) considered for the ouput (mean)
    %image.updown         = [1];            % up/downsample ([1,2])
end