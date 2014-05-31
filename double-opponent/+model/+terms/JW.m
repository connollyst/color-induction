function [all_J, all_W, all_J_fft, all_W_fft, M_norm_conv_fft, half_size_filter] = JW(n_scales, diameter, radius_sc, K, Delta, M, N, M_norm_conv, config)
%JW Summary of this function goes here
%   Detailed explanation goes here
    wave      = config.wave;
    zli       = config.zli;
    all_J     = cell(n_scales,1);
    all_W     = cell(n_scales,1);
    all_J_fft = cell(n_scales,1);
    all_W_fft = cell(n_scales,1);
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
        if config.compute.use_fft
            all_J_fft{s}=zeros(M+2*Delta(s),N+2*Delta(s),1,K,K);
            all_W_fft{s}=zeros(M+2*Delta(s),N+2*Delta(s),1,K,K);
            all_W_fft{s}=zeros(M+2*Delta(s),N+2*Delta(s));
            for ov=1:K
                for oc=1:K
                    if config.compute.avoid_circshift_fft==1
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
            if config.compute.avoid_circshift_fft==1
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
end