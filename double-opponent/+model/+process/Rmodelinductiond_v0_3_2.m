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
    Delta = zli.Delta*utils.scale2size(1:n_scales, zli.scale2size_type, zli.scale2size_epsilon);
    % normalization (I_norm)
    r = zli.normalization_power;
    % config.compute
    % dynamic/constant
    % dynamic=compute.dynamic;
    % debug display
    XOP_DEBUG = config.compute.XOP_DEBUG;

    M = size(Iitheta{1}, 1);
    N = size(Iitheta{1}, 2);

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%% Input data normalization %%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Iitheta = normalize_input(Iitheta, config);

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
    % orientations
    a         = pi/4;
    b         = pi/2;
    Dtheta    = [0 a b; a 0 a ; b a 0];
    PsiDtheta = model.terms.Psi(Dtheta);
    % scales (define the interraction between the scales)
    radius_sc       = 1;
    n_weight_scales = 1+2*radius_sc;
    weight_scales   = zeros(1, n_weight_scales);

    if zli.scale_interaction == 1
        e = 0.01;
        f = 1;
    else
        e = 0;
        f = 1;
    end

    weight_scales = [e f e];
    border_weight = model.get_border_weights(e, f);
    Delta_ext     = zeros(1, n_scales+radius_sc*2);
    Delta_ext(radius_sc+1:n_scales+radius_sc)            = Delta;
    Delta_ext(1:radius_sc)                               = Delta(1);
    Delta_ext(n_scales+radius_sc+1:n_scales+radius_sc*2) = Delta(n_scales);

    if radius_sc>1
        disp('Warning: border_weights only handle radius_sc=1 and here radius_sc > 1!');
    end

    % define the filter
    scale_filter             = zeros(1,1,1+2*radius_sc,1);
    scale_filter(1, 1, :, 1) = weight_scales;

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%   prepare J_ithetajtheta' and J_ithetajtheta   %%%%%%%%%%%%%%%%%
    %%%%%%%%%          for x_ee and y_ie					 %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    all_J=cell(n_scales,1);
    all_W=cell(n_scales,1);
    all_J_fft=cell(n_scales,1);
    all_W_fft=cell(n_scales,1);
    M_norm_conv_fft=cell(n_scales,1);
    half_size_filter=cell(n_scales,1);
    for s=1:n_scales
        all_J{s}=zeros(diameter(s),diameter(s),K,K);
        all_W{s}=zeros(diameter(s),diameter(s),K,K);
        for o=1:K
            [all_J{s}(:,:,:,o),all_W{s}(:,:,:,o)]=model.get_Jithetajtheta_v0_4(s,K,o,Delta(s),wave,zli);
        end
    end

    for s=1:n_scales
        if radius_sc >0
            J=zeros(diameter(s),diameter(s),1,K,K);
            W=zeros(diameter(s),diameter(s),1,K,K);
            half_size_filter{s}=[Delta(s) Delta(s) 0];
                J(:,:,1,:,:)=1*all_J{s}(:,:,:,:);
                W(:,:,1,:,:)=1*all_W{s}(:,:,:,:);
            all_J{s}=J;
            all_W{s}=W;
        end

        % a matrix for each scale
        % fft for speed (convolutions are computed in another space)
        if (use_fft)	
            all_J_fft{s}=zeros(M+2*Delta(s),N+2*Delta(s),1,K,K);
            all_W_fft{s}=zeros(M+2*Delta(s),N+2*Delta(s),1,K,K);
            all_W_fft{s}=zeros(M+2*Delta(s),N+2*Delta(s));
            for ov=1:K
                for oc=1:K
                    if compute.avoid_circshift_fft==1
                        % fft that do not requires circshift (by far better)
                        J_circ=padarray(all_J{s}(:,:,1,ov,oc),[M+2*Delta(s)-diameter(s),N+2*Delta(s)-diameter(s)],0,'post');
                        W_circ=padarray(all_W{s}(:,:,1,ov,oc),[M+2*Delta(s)-diameter(s),N+2*Delta(s)-diameter(s)],0,'post');
                        J_circ=circshift(J_circ,-[Delta(s) Delta(s)]);
                        W_circ=circshift(W_circ,-[Delta(s) Delta(s)]);
                        all_J_fft{s}(:,:,1,ov,oc)=fftn(J_circ);
                        all_W_fft{s}(:,:,1,ov,oc)=fftn(W_circ);
                else
                        % this fft requires circshift
                        all_J_fft{s}(:,:,1,ov,oc)=fftn(all_J{s}(:,:,1,ov,oc),[M+2*Delta(s),N+2*Delta(s)]);
                        all_W_fft{s}(:,:,1,ov,oc)=fftn(all_W{s}(:,:,1,ov,oc),[M+2*Delta(s),N+2*Delta(s)]);
                    end
                end
            end

            radi=(size(M_norm_conv{s})-1)/2;
            if compute.avoid_circshift_fft==1
                % fft that do not requires circshift (by far better)
                M_circ=padarray(M_norm_conv{s},[M+2*radi(1)-(radi(1)*2+1),N+2*radi(2)-(radi(2)*2+1)],0,'post');
                M_circ=circshift(M_circ,-radi);
                M_norm_conv_fft{s}=fftn(M_circ);
            else
                % this fft requires circshift (slower)
                M_norm_conv_fft{s}=fftn(M_norm_conv{s},[M+2*radi(1),N+2*radi(2)]);
            end
        end


    end

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% recurrent network: the loop over time    %%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    K=size(Iitheta{1},4);

    % preallocate
    x=Iitheta{1}; % visual input (Iitheta) initializes the activity levels newgx(x) (p.192)
    y=zeros(M,N,n_scales,K);

    if XOP_DEBUG
        for s=1:min(3,n_scales)
            for o=1:3
                fig(s,o)=figure('Name',['s: ' int2str(s) ', o: ' int2str(o)]);
                pos=get(fig(s,o),'OuterPosition');
                set(fig(s,o),'OuterPosition',[0+(o-1)*pos(3) 0+(s-1)*pos(4) pos(3) pos(4)]);
            end
        end
    end

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

                x_ee_conv_tmp=zeros(M,N,n_scales,K);
                y_ie_conv_tmp=zeros(M,N,n_scales,K);

                for ov=1:K  % loop over all the orientations given the central (reference orientation)
                    % FFT
                    if (use_fft)
                        for s=1:n_scales
                            kk=convolutions.optima_fft(newgx_toroidal_x_fft{radius_sc+s}{ov},all_J_fft{s}(:,:,1,ov,oc),half_size_filter{s},1,avoid_circshift_fft);  % (max(1,M+1-diameter):min(3*M,2*M+diameter),max(1,N+1-diameter):min(3*N,2*N+diameter)
                            x_ee_conv_tmp(:,:,s,ov)=kk(Delta(s)+1:Delta(s)+M,Delta(s)+1:Delta(s)+N);
                            kk=convolutions.optima_fft(newgx_toroidal_x_fft{radius_sc+s}{ov},all_W_fft{s}(:,:,1,ov,oc),half_size_filter{s},1,avoid_circshift_fft);  % (max(1,M+1-diameter):min(3*M,2*M+diameter),max(1,N+1-diameter):min(3*N,2*N+diameter)
                            y_ie_conv_tmp(:,:,s,ov)=kk(Delta(s)+1:Delta(s)+M,Delta(s)+1:Delta(s)+N);
                        end
                    else
                        disp('Part no adaptada 1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                        J_ov=all_J(:,:,:,ov,oc);
                        W_ov=all_W(:,:,:,ov,oc);
                        J_conv_tmp(:,:,:,ov)=convolutions.optima(newgx_toroidal_x(:,:,:,ov),J_ov,0,0);  % (max(1,M+1-diameter):min(3*M,2*M+diameter),max(1,N+1-diameter):min(3*N,2*N+diameter)
                        restr_J_conv_tmp=J_conv_tmp(Delta(s)+1:M+Delta(s),Delta(s)+1:N+Delta(s),radius_sc+1:radius_sc+n_scales,:);
                        W_conv_tmp(:,:,:,ov)=convolutions.optima(newgx_toroidal_x(:,:,:,ov),W_ov,0,0);
                        restr_W_conv_tmp=W_conv_tmp(Delta(s)+1:M+Delta(s),Delta(s)+1:N+Delta(s),radius_sc+1:radius_sc+n_scales,:);
                    end
                end
                x_ee(:,:,:,oc)=sum(x_ee_conv_tmp,4);
                y_ie(:,:,:,oc)=sum(y_ie_conv_tmp,4);
            end   % of the loop over the central (reference) orientation


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % influence of the neighboring spatial frequencies
            x_ee=convolutions.optima(x_ee,scale_filter,0,0);
            y_ie=convolutions.optima(y_ie,scale_filter,0,0);

            %%%%%%%%%%%%%% normalization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % we generalize Z.Li's formula for the normalization by suming
            % over all the scales within a given hypercolumn (cf. p209, where she
            % already sums over all the orientations)
            I_norm=zeros(M,N,n_scales,K);
            %		disp('Compte!!!!!!! No calculem I_norm incloent les escales !!!!!');
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
            if XOP_DEBUG
                show_x_y(fig,x,y,I_norm,Iitheta{t_membr},n_scales);
            end
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

function Iitheta = normalize_input(Iitheta, config)
    for i=1:config.zli.n_membr;
        Iitheta_2 = Iitheta{i}(:,:,:,2);
        Iitheta{i}(:,:,:,2) = Iitheta{i}(:,:,:,3);
        Iitheta{i}(:,:,:,3) = Iitheta_2;
    end

    [Iitheta,~,~] = model.curv_normalization(Iitheta, config);
end

