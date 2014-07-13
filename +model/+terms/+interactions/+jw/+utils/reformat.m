function [J, W] = reformat(J, W, scale_diameters, scale_distance, n_scales, n_orients)
%JW.UTILS.REFORMAT Reformat the J and W cell array structure.
%   THIS SHOULD BE OBVIATED!
%   This function is left over from some old (bad) logic. We should create
%   J and W correctly the first time.
    for s=1:n_scales
        if scale_distance > 0
            Js = zeros(scale_diameters(s), scale_diameters(s), 1, n_orients, n_orients);
            Ws = zeros(scale_diameters(s), scale_diameters(s), 1, n_orients, n_orients);
            Js(:,:,1,:,:) = 1 * J{s}(:,:,:,:);
            Ws(:,:,1,:,:) = 1 * W{s}(:,:,:,:);
            J{s} = Js;
            W{s} = Ws;
            %max_j_s = max(Js(:))
            %min_j_s = min(Js(:))
        end
    end
end

