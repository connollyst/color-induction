function plotRFDO()
% PLOT DOUBLE-OPPONENT RECEPTIVE FIELDS
    config = configurations.default;
    dof = figure(1); set(dof, 'name', 'Double-Opponent Receptive Fields (Default)')
    clf
    hold on
    subplot(2,3,1), surf(dorf(1, config)), zlim([-0.2, 0.2]), view(180,0), title('scale = 1');
    subplot(2,3,2), surf(dorf(2, config)), zlim([-0.2, 0.2]), view(180,0), title('scale = 2');
    subplot(2,3,3), surf(dorf(3, config)), zlim([-0.2, 0.2]), view(180,0), title('scale = 3');
    subplot(2,3,4), surf(dorf(4, config)), zlim([-0.2, 0.2]), view(180,0), title('scale = 4');
    subplot(2,3,5), surf(dorf(5, config)), zlim([-0.2, 0.2]), view(180,0), title('scale = 5');
    subplot(2,3,6), surf(dorf(6, config)), zlim([-0.2, 0.2]), view(180,0), title('scale = 6');
    hold off
end

function rf = dorf(scale, config)
    c = model.data.rf.oriented.center_middle_left(scale, config);
    s = model.data.rf.oriented.surround_middle_right(scale, config);
    rf = c-s;
end