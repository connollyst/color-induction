function [gx_final] = Rmodelinductiond_v0_3_2(Iitheta, config)
%Rmodelinductiond_v0_3_2 apply model to input image
%   from NCZLd_channel_ON_OFF_v1_1.m to all the functions for implementing
%   Li 1999
%   Iitheta: cell struct of input stimuli at each membrane time step, eg:
%            Iitheta{1}(:,:,2,3) is the full image decomposed at the
%            second scale and third orientation.
%   config:  the model configuration struct

    %% ------------------------------------------------------
    % get the structure and the parameters
    wave      = config.wave;
    use_fft   = config.compute.use_fft;
    n_scales  = wave.n_scales;
    % make the structure explicit
    zli       = config.zli;
    compute   = config.compute;
    avoid_circshift_fft = compute.avoid_circshift_fft;
    % config.zli
    % differential equation
    n_membr   = zli.n_membr;
    n_iter    = zli.n_iter;
    prec      = 1/n_iter;
    % normalization
    dist_type = zli.dist_type;
    var_noise = 0.1 * 2;
    % Delta
    Delta     = zli.Delta*utils.scale2size(1:n_scales, zli.scale2size_type, zli.scale2size_epsilon);
    % normalization (I_norm)
    r         = zli.normalization_power;
    
    M         = size(Iitheta{1}, 1);
    N         = size(Iitheta{1}, 2);

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%% Input data normalization %%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Iitheta = model.normalize_input(Iitheta, config);

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % the number of neuron pairs in each hypercolumn (i.e. the number of preferred orientations)
    K  = size(Iitheta{1}, 4);
    % self-excitation coefficient (Li 1999)
    J0 = 0.8;

    if N <= 10
       disp('Bad stimulus dimensions! The toroidal boundary conditions are ill-defined.')
    end

    % membrane potentials
    gx_final = cell(n_membr, 1);
    gy_final = cell(n_membr, 1);

    % preallocate
    for i=1:n_membr
        gx_final{i} = zeros(M, N, n_scales, K); 
        gy_final{i} = zeros(M, N, n_scales, K);
    end

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%% prepare the excitatory and inhibitory masks %%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % maximum diameter of the area of influence
    diameter = 2*Delta+1;

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%% Normalization mask %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [M_norm_conv, inv_den] = ...
        model.Fer_M_norm_conv(n_scales, dist_type, zli.scale2size_type, zli.scale2size_epsilon);

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%% prepare orientation/scale interaction for x_ei   %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [radius_sc, scale_filter, border_weight, PsiDtheta, Delta_ext] = ...
        model.terms.interaction_maps(Delta, config);

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%   prepare J_ithetajtheta' and J_ithetajtheta   %%%%%%%%%%%%%%%%%
    %%%%%%%%%          for x_ee and y_ie					 %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [all_J, all_W, all_J_fft, all_W_fft, M_norm_conv_fft, half_size_filter] = ...
        model.terms.JW(n_scales, diameter, radius_sc, K, Delta, M, N, M_norm_conv, config);

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% recurrent network: the loop over time    %%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    K=size(Iitheta{1},4);

    % preallocate
    x=Iitheta{1}; % visual input (Iitheta) initializes the activity levels newgx(x) (p.192)
    y=zeros(M,N,n_scales,K);

    % new 27 9 12 store I_norm values!
    vector_I_norm=zeros(3,n_membr*n_iter);

    for t_membr=1:n_membr  % membrane time
        disp(['t_membr: ' int2str(t_membr)]);
        tic
        for t_iter=1:n_iter  % from the differential equation (Euler!)
            toroidal_x=cell(n_scales+2*radius_sc,1);
            toroidal_y=cell(n_scales+2*radius_sc,1);
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
            disp(['t_iter: ' int2str(t_iter)]);
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

            newgx_toroidal_x{1:radius_sc}=kk_tmp1;
            newgx_toroidal_x{n_scales+radius_sc+1:n_scales+2*radius_sc}=kk_tmp2;
            newgy_toroidal_y{1:radius_sc}=kk_tmp1_y;
            newgy_toroidal_y{n_scales+radius_sc+1:n_scales+2*radius_sc}=kk_tmp2_y;

            for s=1:n_scales+2*radius_sc
                restr_newgx_toroidal_x(:,:,s,:)=newgx_toroidal_x{s}(Delta_ext(s)+1:Delta_ext(s)+M,Delta_ext(s)+1:Delta_ext(s)+N,:);
                restr_newgy_toroidal_y(:,:,s,:)=newgy_toroidal_y{s}(Delta_ext(s)+1:Delta_ext(s)+M,Delta_ext(s)+1:Delta_ext(s)+N,:);
            end

            x_ee=zeros(M,N,n_scales,K);
            x_ei=zeros(M,N,n_scales,K);
            y_ie=zeros(M,N,n_scales,K);
            I_norm=zeros(M,N,n_scales,K);

            %%%%%%%%%%%%%% preparatory terms %%%%%%%%%%%%%%%%%%%%%%%%%%
            if (use_fft)
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
                            kk=convolutions.optima_fft(newgx_toroidal_x_fft{radius_sc+s}{ov},all_J_fft{s}(:,:,1,ov,oc),half_size_filter{s},1,avoid_circshift_fft);
                            x_ee_conv_tmp(:,:,s,ov)=kk(Delta(s)+1:Delta(s)+M,Delta(s)+1:Delta(s)+N);
                            kk=convolutions.optima_fft(newgx_toroidal_x_fft{radius_sc+s}{ov},all_W_fft{s}(:,:,1,ov,oc),half_size_filter{s},1,avoid_circshift_fft);
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
            % we generalize Z.Li's formula for the normalization by suming
            % over all the scales within a given hypercolumn (cf. p209, where she
            % already sums over all the orientations)
            I_norm=zeros(M,N,n_scales,K);
            for s=radius_sc+1:radius_sc+n_scales
                radi=(size(M_norm_conv{s-radius_sc})-1)/2;
                % sum over all the orientations
                sum_newgx_toroidal_x_sc=sum(newgx_toroidal_x{s},4);
                despl=radi;
                kk=convolutions.optima(sum_newgx_toroidal_x_sc(Delta_ext(s)+1-radi(1):Delta_ext(s)+M+radi(1),Delta_ext(s)+1-radi(2):Delta_ext(s)+N+radi(2)),M_norm_conv_fft{s-radius_sc},despl,1,avoid_circshift_fft); % Xavier. El filtre diria que ha d'estar normalitzat per tal de calcular el valor mig
                I_norm(:,:,s-radius_sc,:)=repmat(kk(radi(1)+1:M+radi(1),radi(2)+1:N+radi(2)),[1 1 K]);
            end
            for s=1:n_scales  % times  roughly 50 if the flag is 1
                I_norm(:,:,s,:)=-2*(I_norm(:,:,s,:)*inv_den{s}).^r;
            end
            %%%%%%%%%%%%%% end normalization %%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %%%%%%%%%% CENTRAL FORMULA (formulae (1) and (2) p.192, Li 1999) %%%%%%
            % (1) inhibitory neurons
            y = y+prec*(...
                    - zli.alphay*y...                           % decay
                    + model.terms.newgx(x)...
                    + y_ie...
                    + 1.0...                                    % spontaneous firing rate
                    + var_noise*(rand(M,N,n_scales,K))-0.5...   % neural noise (comment for speed)
                );
            % (2) excitatory neurons
            x = x+prec*(...
                    - zli.alphax*x...				            % decay
                    - x_ei...					                % ei term
                    + J0 * model.terms.newgx(x)...              % input
                    + x_ee...
                    + Iitheta{t_membr}...                       % Iitheta
                    + I_norm...                                 % normalization
                    + 0.85...                                   % spontaneous firing rate
                    + var_noise*(rand(M,N,n_scales,K))-0.5...	% neural noise (comment for speed)
                );
            % store I_norm
            vector_I_norm(:,(t_membr-1)*n_iter+t_iter)=[min(I_norm(:));max(I_norm(:));mean(I_norm(:))];
        end % end t_iter=1:n_iter
        toc
        gx_final{t_membr}=model.terms.newgx(x);
        gy_final{t_membr}=model.terms.newgy(y);
    end  % end t_membr=1:t_membr

    for i=1:n_membr
        gx_final_2=gx_final{i}(:,:,:,2);
        gx_final{i}(:,:,:,2)=gx_final{i}(:,:,:,3);
        gx_final{i}(:,:,:,3)=gx_final_2;
    end

end