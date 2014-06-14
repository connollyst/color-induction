function Iitheta = normalize_input(Iitheta, config)
%NORMALIZE_INPUT Normalize the input signal.
%   Iitheta: the cell array of input signal Iitheta
%            each cell is a the signal at a membrane time step such that,
%            for example, Iitheta{3,2,1}(:,:,:) is the entire input signal
%            at the first time step, second scale, and third orientation.

    % Move the diagonal orientation to the middle orientation position
    % TODO move this up to the wavelet decomposition step!
    Iitheta([2,3],:,:) = Iitheta([3,2],:,:);
    
    switch config.zli.normal_type
        case ('all')
            Iitheta = normalize_all(Iitheta, config);
        case ('scale')
            Iitheta = normalize_scales(Iitheta, config);
        case ('absolute')
            Iitheta = normalize_absolute(Iitheta, config);
    end

    % Per posar a zero el que era zero inicialment (Li1998)
    for i=1:config.zli.n_membr
        Iitheta{i}(Iitheta{i} == config.zli.shift) = 0;
    end
end

function Iitheta = normalize_all(Iitheta, config)
%NORMALIZE_ALL Normalize for all the data.

    factor_normal = config.zli.normal_input;
    n_membr       = config.zli.n_membr;
    shift         = config.zli.shift;
    normal_max_v  = zeros(n_membr, 1);
    normal_min_v  = zeros(n_membr, 1);

    for i=1:n_membr
        normal_max_v(i) = max(Iitheta{i}(:),[],1);
        normal_min_v(i) = min(Iitheta{i}(:),[],1);
    end

    normal_max = max(normal_max_v(:),[],1);
    normal_min = min(normal_min_v(:),[],1);

    if normal_max == normal_min
        Iitheta{i} = 1;
    else
        for i=1:n_membr
            Iitheta{i}=((Iitheta{i}-normal_min)/(normal_max-normal_min))*(factor_normal-shift)+shift;
        end
    end
end

function Iitheta = normalize_scales(Iitheta, config)
%NORMALIZE_SCALES Normalize for every scale.

    factor_normal = config.zli.normal_input;
    n_membr   = config.zli.n_membr;
    n_scales = config.wave.n_scales;
    
    normal_max_v = zeros(n_scales,n_membr);
    normal_min_v = zeros(n_scales,n_membr);
    for s=1:n_scales
        for i=1:n_membr
            kk = Iitheta{i}(:,:,s,:);
            normal_max_v(s,i) = max(kk(:),[],1);
            normal_min_v(s,i) = min(kk(:),[],1);
        end
    end
    normal_max = max(normal_max_v,[],2);
    normal_min = min(normal_min_v,[],2);

    for s=1:n_scales
        if normal_max(s)==normal_min(s)
            for i=1:n_membr
                Iitheta{i}(:,:,s,:)=1.02; % El minim segons Li1998
            end
        else
            for i=1:n_membr
                Iitheta{i}(:,:,s,:)=((Iitheta{i}(:,:,s,:)-normal_min(s))/(normal_max(s)-normal_min(s)))*(factor_normal-shift)+shift;
            end
        end
    end
end

function Iitheta = normalize_absolute(Iitheta, config)
%NORMALIZE_ABSOLUTE

    normal_min    = config.zli.normal_min_absolute;
    normal_max    = config.zli.normal_max_absolute;
    factor_normal = config.zli.normal_input;
    
    for i=1:config.zli.n_membr
        Iitheta{i}=((Iitheta{i}-normal_min)/(normal_max-normal_min))*(factor_normal-shift)+shift;
    end
end