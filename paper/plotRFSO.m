function plotRFSO()
    clf
    config = configurations.default;
    % PLOT SINGLE-OPPONENT RECEPTIVE FIELDS
    dof = figure(1); set(dof, 'name', 'Double-Opponent Receptive Fields (Default)')
    subplot(2,3,1),
        hold on
        surf( model.data.rf.center(1, config)),
        surf(-model.data.rf.surround(1, config)),
        zlim([-0.2, 1]),
        view(180,0), title('scale = 1');
        hold off
    subplot(2,3,2),
        hold on
        surf( model.data.rf.center(2, config)),
        surf(-model.data.rf.surround(2, config)),
        zlim([-0.2, 1]),
        view(180,0), title('scale = 2');
        hold off
    subplot(2,3,3),
        hold on
        surf( model.data.rf.center(3, config)),
        surf(-model.data.rf.surround(3, config)),
        zlim([-0.2, 1]),
        view(180,0), title('scale = 3');
        hold off
    subplot(2,3,4),
        hold on
        surf( model.data.rf.center(4, config)),
        surf(-model.data.rf.surround(4, config)),
        zlim([-0.2, 1]),
        view(180,0), title('scale = 4');
        hold off
    subplot(2,3,5),
        hold on
        surf( model.data.rf.center(5, config)),
        surf(-model.data.rf.surround(5, config)),
        zlim([-0.2, 1]),
        view(180,0), title('scale = 5');
        hold off
    subplot(2,3,6),
        hold on
        surf( model.data.rf.center(6, config)),
        surf(-model.data.rf.surround(6, config)),
        zlim([-0.2, 1]),
        view(180,0), title('scale = 6');
        hold off
end