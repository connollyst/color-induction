function [curv, w, c] = wavelet_decomposition(img, n_membr, n_scales, dynamic)
%WAVELET_DECOMPOSITION Decompose the given img with a wavelet transform

    curv = cell([n_membr, n_scales, 1]);

    % number of wavelet decompositions to perform
    if dynamic == 1
        niter_wav = n_membr;
    else
        niter_wav = 1;
    end
    
    % different wavelet decompositions		
    for ff=1:niter_wav
        % TODO why are w & c needed for inverse transformation?
        [w, c] = wavelets.DWD_orient_undecimated(img(:,:,ff), n_scales-1);
        for s=1:n_scales-1
            ws = w{s};
            n_orientations = size(ws, 3);
            for o=1:n_orientations
                curv{ff}{s}{o}=w{s}(:,:,o);
            end
        end
        curv{ff}{n_scales}{1}=c{n_scales-1};
    end
    
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
end

