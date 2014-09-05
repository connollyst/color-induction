function image = get_image()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  stimulus (image, name...) %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    image.transform.pre   = 'none';
    image.transform.post  = 'none';
    image.n_frames_promig = 0;  % number iterations (from the last one) considered for the ouput (mean)
end