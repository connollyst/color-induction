function Iitheta = normalize_input(Iitheta, config)
%NORMALIZE_INPUT Normalize the input signal.
%   Iitheta: the cell array of input signal Iitheta
%            each cell is a the signal at a membrane time step such that,
%            for example, Iitheta{3,2,1}(:,:,:) is the entire input signal
%            at the first time step, second scale, and third orientation.
    
    %DEBUGGING
    config.zli.normal_type = 'color';
    
    switch config.zli.normal_type
        case ('all')
            Iitheta = normalize_all(Iitheta, config);
        case ('color')
            Iitheta = normalize_colors(Iitheta, config);
        case ('scale')
            Iitheta = normalize_scales(Iitheta, config);
        case ('absolute')
            Iitheta = normalize_absolute(Iitheta, config);
    end

    % Per posar a zero el que era zero inicialment (Li 1998)
    for t=1:config.zli.n_membr
        Iitheta{t}(Iitheta{t} == config.zli.shift) = 0;
    end
end

function Iitheta = normalize_all(Iitheta, config)
%NORMALIZE_ALL Normalize all the data at once.

    shift         = config.zli.shift;
    factor_normal = config.zli.normal_input;
    n_membr       = config.zli.n_membr;
    normal_max_v  = zeros(n_membr, 1);
    normal_min_v  = zeros(n_membr, 1);

    for t=1:n_membr
        normal_max_v(t) = max(Iitheta{t}(:));
        normal_min_v(t) = min(Iitheta{t}(:));
    end

    normal_max = max(normal_max_v(:),[],1);
    normal_min = min(normal_min_v(:),[],1);

    if normal_max == normal_min
        for t=1:n_membr
            % Why not 1.02 like in normalize_scales?
            Iitheta{t}(:,:) = 1;
        end
    else
        for t=1:n_membr
            Iitheta{t} = ( ...
                (Iitheta{t} - normal_min) / (normal_max - normal_min) ...
            ) * (factor_normal - shift) + shift;
        end
    end
end

function Iitheta = normalize_colors(Iitheta, config)
%NORMALIZE_COLORS Normalize for each color channel independently.

    shift         = config.zli.shift;
    factor_normal = config.zli.normal_input;
    n_membr       = config.zli.n_membr;
    n_channels    = config.image.n_channels;
    
    normal_max_v  = zeros(n_channels, n_membr);
    normal_min_v  = zeros(n_channels, n_membr);
    for c=1:n_channels
        for t=1:n_membr
            scale = Iitheta{t}(:,:,c,:,:);
            normal_max_v(c,t) = max(scale(:));
            normal_min_v(c,t) = min(scale(:));
        end
    end
    normal_max = max(normal_max_v,[],2);
    normal_min = min(normal_min_v,[],2);

    for c=1:n_channels
        if normal_max(c)==normal_min(c)
            for t=1:n_membr
                Iitheta{t}(:,:) = 1.02; % El minim segons Li1998
            end
        else
            for t=1:n_membr
                Iitheta{t}(:,:,c,:,:) = (...
                    (Iitheta{t}(:,:,c,:,:)-normal_min(c))/(normal_max(c)-normal_min(c))...
                ) * (factor_normal - shift) + shift;
            end
        end
    end
end

function Iitheta = normalize_scales(Iitheta, config)
%NORMALIZE_SCALES Normalize for each scale independently.

    shift         = config.zli.shift;
    factor_normal = config.zli.normal_input;
    n_membr       = config.zli.n_membr;
    n_scales      = config.wave.n_scales;
    
    normal_max_v  = zeros(n_scales, n_membr);
    normal_min_v  = zeros(n_scales, n_membr);
    for s=1:n_scales
        for t=1:n_membr
            scale = Iitheta{t}(:,:,:,s,:);
            normal_max_v(s,t) = max(scale(:));
            normal_min_v(s,t) = min(scale(:));
        end
    end
    normal_max = max(normal_max_v,[],2);
    normal_min = min(normal_min_v,[],2);

    for s=1:n_scales
        if normal_max(s)==normal_min(s)
            for t=1:n_membr
                Iitheta{t}(:,:) = 1.02; % El minim segons Li1998
            end
        else
            for t=1:n_membr
                Iitheta{t}(:,:,:,s,:) = (...
                    (Iitheta{t}(:,:,:,s,:)-normal_min(s))/(normal_max(s)-normal_min(s))...
                ) * (factor_normal - shift) + shift;
            end
        end
    end
end

function Iitheta = normalize_absolute(Iitheta, config)
%NORMALIZE_ABSOLUTE Normalize the data using the absolute min and max.

    shift         = config.zli.shift;
    normal_min    = config.zli.normal_min_absolute;
    normal_max    = config.zli.normal_max_absolute;
    factor_normal = config.zli.normal_input;
    
    for t=1:config.zli.n_membr
        Iitheta{t} = (...
            (Iitheta{t} - normal_min)/(normal_max - normal_min)...
            ) * (factor_normal - shift) + shift;
    end
end