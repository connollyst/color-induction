function [x, y] = UpdateXY(t_membr, Iitheta, x, y, M, N, K, Delta, JW, norm_mask, interactions, config)
%UPDATEXY Summary of this function goes here
%   Detailed explanation goes here
    
    %% Initialize Parameters
    % Orientation/Scale Interactions
    half_size_filter    = interactions.half_size_filter;
    border_weight       = interactions.border_weight;
    scale_filter        = interactions.scale_filter;
    radius_sc           = interactions.radius_sc;
    Delta_ext           = interactions.Delta_ext;
    PsiDtheta           = interactions.PsiDtheta;
    % Equaltion Parameters
    n_scales            = config.wave.n_scales;
    r                   = config.zli.normalization_power; % normalization (I_norm)
    prec                = 1/config.zli.n_iter;
    var_noise           = 0.1 * 2;
    % Computation Configurations
    use_fft             = config.compute.use_fft;
    avoid_circshift_fft = config.compute.avoid_circshift_fft;

    toroidal_x = cell(n_scales+2*radius_sc,1);
    toroidal_y = cell(n_scales+2*radius_sc,1);
    for s=1:n_scales
        % mirror boundary condition
        toroidal_x{s+radius_sc}=padarray(x(:,:,s,:),[Delta(s),Delta(s),0],'symmetric');
        toroidal_y{s+radius_sc}=padarray(y(:,:,s,:),[Delta(s),Delta(s),0],'symmetric');
    end	% of the loop over scales
    % Assign values to the pad (for scales)
    kk_tmp1=zeros(size(toroidal_x{radius_sc+1})); 
    kk_tmp2=zeros(size(toroidal_x{n_scales+radius_sc}));
    kk_tmp1_y=zeros(size(toroidal_y{radius_sc+1})); 
    kk_tmp2_y=zeros(size(toroidal_y{n_scales+radius_sc}));
    newgx_toroidal_x=cell(n_scales+2*radius_sc,1);
    newgy_toroidal_y=cell(n_scales+2*radius_sc,1);
    restr_newgx_toroidal_x=zeros(M,N,n_scales+2*radius_sc,K);
    restr_newgy_toroidal_y=zeros(M,N,n_scales+2*radius_sc,K);

    for s=1:n_scales+2*radius_sc
        newgx_toroidal_x{s}=model.terms.newgx(toroidal_x{s});
        newgy_toroidal_y{s}=model.terms.newgy(toroidal_y{s});

    end

    for i=1:radius_sc+1
        kk_tmp1(Delta(1)+1:Delta(1)+M,Delta(1)+1:Delta(1)+N,:)=kk_tmp1(Delta(1)+1:Delta(1)+M,Delta(1)+1:Delta(1)+N,:)+border_weight(i) * newgx_toroidal_x{radius_sc+i}(Delta(i)+1:Delta(i)+M,Delta(i)+1:Delta(i)+N,:);
        kk_tmp2(Delta(n_scales)+1:Delta(n_scales)+M,Delta(n_scales)+1:Delta(n_scales)+N,:)=kk_tmp2(Delta(n_scales)+1:Delta(n_scales)+M,Delta(n_scales)+1:Delta(n_scales)+N,:)+border_weight(i) * newgx_toroidal_x{n_scales+radius_sc-(i-1)}(Delta(n_scales-i+1)+1:Delta(n_scales-i+1)+M,Delta(n_scales-i+1)+1:Delta(n_scales-i+1)+N,:);
        kk_tmp1_y(Delta(1)+1:Delta(1)+M,Delta(1)+1:Delta(1)+N,:)=kk_tmp1_y(Delta(1)+1:Delta(1)+M,Delta(1)+1:Delta(1)+N,:)+border_weight(i) * newgy_toroidal_y{radius_sc+i}(Delta(i)+1:Delta(i)+M,Delta(i)+1:Delta(i)+N,:);
        kk_tmp2_y(Delta(n_scales)+1:Delta(n_scales)+M,Delta(n_scales)+1:Delta(n_scales)+N,:)=kk_tmp2_y(Delta(n_scales)+1:Delta(n_scales)+M,Delta(n_scales)+1:Delta(n_scales)+N,:)+border_weight(i) * newgy_toroidal_y{n_scales+radius_sc-(i-1)}(Delta(n_scales-i+1)+1:Delta(n_scales-i+1)+M,Delta(n_scales-i+1)+1:Delta(n_scales-i+1)+N,:);
    end

    newgx_toroidal_x{1:radius_sc} = kk_tmp1;
    newgx_toroidal_x{n_scales+radius_sc+1:n_scales+2*radius_sc} = kk_tmp2;
    newgy_toroidal_y{1:radius_sc} = kk_tmp1_y;
    newgy_toroidal_y{n_scales+radius_sc+1:n_scales+2*radius_sc} = kk_tmp2_y;

    for s=1:n_scales+2*radius_sc
        restr_newgx_toroidal_x(:,:,s,:)=newgx_toroidal_x{s}(Delta_ext(s)+1:Delta_ext(s)+M, Delta_ext(s)+1:Delta_ext(s)+N, :);
        restr_newgy_toroidal_y(:,:,s,:)=newgy_toroidal_y{s}(Delta_ext(s)+1:Delta_ext(s)+M, Delta_ext(s)+1:Delta_ext(s)+N, :);
    end

    x_ee   = zeros(M, N, n_scales, K);
    x_ei   = zeros(M, N, n_scales, K);
    y_ie   = zeros(M, N, n_scales, K);
    I_norm = zeros(M, N, n_scales, K);

    %%%%%%%%%%%%%% preparatory terms %%%%%%%%%%%%%%%%%%%%%%%%%%
    if use_fft
        newgx_toroidal_x_fft=cell(radius_sc+n_scales,1);
        for s=1:n_scales
            newgx_toroidal_x_fft{radius_sc+s}=cell(K,1);
            for ov=1:K  % loop over all the orientations given the central (reference orientation)
                newgx_toroidal_x_fft{radius_sc+s}{ov}=fftn(newgx_toroidal_x{radius_sc+s}(:,:,ov));
            end
        end
    end

    for oc=1:K  % loop over the central (reference) orientation
        % excitatory-inhibitory term (no existia):   x_ei
        % influence of the neighboring scales first

        sum_scale_newgy_toroidal_y=convolutions.optima(restr_newgy_toroidal_y,scale_filter,0,0,avoid_circshift_fft); % does it give the right dimension? 'same' needed?
        restr_sum_scale_newgy_toroidal_y=sum_scale_newgy_toroidal_y(:,:,radius_sc+1:radius_sc+n_scales,:); % restriction over scales
        w=zeros(1,1,1,K);w(1,1,1,:)=PsiDtheta(oc,:);
        x_ei(:,:,:,oc)=sum(restr_sum_scale_newgy_toroidal_y.*repmat(w,[M,N,n_scales,1]),4);

        % excitatory and inhibitory terms (the big sums)
        % excitatory-excitatory term:    x_ee
        % excitatory-inhibitory term:    y_ie

        x_ee_conv_tmp = zeros(M, N, n_scales, K);
        y_ie_conv_tmp = zeros(M, N, n_scales, K);

        for ov=1:K  % loop over all the orientations given the central (reference orientation)
            % FFT
            if use_fft
                for s=1:n_scales
                    kk=convolutions.optima_fft(newgx_toroidal_x_fft{radius_sc+s}{ov},JW.J_fft{s}(:,:,1,ov,oc),half_size_filter{s},1,avoid_circshift_fft);
                    x_ee_conv_tmp(:,:,s,ov)=kk(Delta(s)+1:Delta(s)+M,Delta(s)+1:Delta(s)+N);
                    kk=convolutions.optima_fft(newgx_toroidal_x_fft{radius_sc+s}{ov},JW.W_fft{s}(:,:,1,ov,oc),half_size_filter{s},1,avoid_circshift_fft);
                    y_ie_conv_tmp(:,:,s,ov)=kk(Delta(s)+1:Delta(s)+M,Delta(s)+1:Delta(s)+N);
                end
            else
                error('Non FFT approach is not implemented.');
            end
        end
        x_ee(:,:,:,oc)=sum(x_ee_conv_tmp,4);
        y_ie(:,:,:,oc)=sum(y_ie_conv_tmp,4);
    end   % of the loop over the central (reference) orientation

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % influence of the neighboring spatial frequencies
    x_ee = convolutions.optima(x_ee, scale_filter, 0, 0);
    y_ie = convolutions.optima(y_ie, scale_filter, 0, 0);

    %%%%%%%%%%%%%% normalization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    I_norm = normalize(M, N, n_scales, K, norm_mask, radius_sc, newgx_toroidal_x);
    %%%%%%%%%%%%%% end normalization %%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [x, y] = calculate_xy(Iitheta, t_membr, I_norm, x, y, x_ee, x_ei, y_ie, var_noise, config);
end

% TODO get M, N, n_scales, K from config
function I_norm = normalize(M, N, n_scales, K, norm_mask, radius_sc, newgx_toroidal_x)
%NORMALIZE
%   We generalize Z.Li's formula for the normalization by suming over all
%   the scales within a given hypercolumn (cf. p209, where she already sums
%   over all the orientations)

    inv_den             = norm_mask.inv_den;
    M_norm_conv         = norm_mask.M_norm_conv;
    M_norm_conv_fft     = norm_mask.M_norm_conv_fft;

    I_norm = zeros(M, N, n_scales, K);
    for s=radius_sc+1:radius_sc+n_scales
        radi=(size(M_norm_conv{s-radius_sc})-1)/2;
        % sum over all the orientations
        sum_newgx_toroidal_x_sc = sum(newgx_toroidal_x{s},4);
        despl = radi;
        kk = convolutions.optima(sum_newgx_toroidal_x_sc(Delta_ext(s)+1-radi(1):Delta_ext(s)+M+radi(1),Delta_ext(s)+1-radi(2):Delta_ext(s)+N+radi(2)),M_norm_conv_fft{s-radius_sc},despl,1,avoid_circshift_fft); % Xavier. El filtre diria que ha d'estar normalitzat per tal de calcular el valor mig
        I_norm(:,:,s-radius_sc,:) = repmat(kk(radi(1)+1:M+radi(1),radi(2)+1:N+radi(2)),[1 1 K]);
    end
    for s=1:n_scales  % times  roughly 50 if the flag is 1
        I_norm(:,:,s,:) = -2 * (I_norm(:,:,s,:) * inv_den{s}) .^ r;
    end
end

% TODO just pass the current image as Iitheta, no need to pass t_membr
function [x, y] = calculate_xy(Iitheta, t_membr, I_norm, x, y, x_ee, x_ei, y_ie, var_noise, config)
%CALCULATE_XY
%   Formula (1) and (2) p.192, Li 1999
    
    % (1) inhibitory neurons
    y = y + prec * (...
            - config.zli.alphay * y...                  % decay
            + model.terms.newgx(x)...
            + y_ie...
            + 1.0...                                    % spontaneous firing rate
            + generate_noise(var_noise, config)...      % neural noise (comment for speed)
        );
    % (2) excitatory neurons
    x = x + prec * (...
            - config.zli.alphax * x...				    % decay
            - x_ei...					                % ei term
            + config.zli.J0 * model.terms.newgx(x)...              % input
            + x_ee...
            + Iitheta{t_membr}...                       % Iitheta
            + I_norm...                                 % normalization
            + 0.85...                                   % spontaneous firing rate
            + generate_noise(var_noise, config)...      % neural noise (comment for speed)
        );
end

function noise = generate_noise(var_noise, config)
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;   % TODO reshape noise to include channels
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    noise      = var_noise * (rand(n_cols, n_rows, n_scales, n_orients)) - 0.5;
end