function  theta = angle_orient(orient, transform)
% S'han de posar en la direccio perpendicular, ja que una cosa es la dir 
% de variacio i l'altra la del marge
    switch(transform)
        case('wav')
            thetas = [pi/2 -pi/4 0];
        case('a_trous')
            % TODO does this work for DWD_orient_undecimated also?
            thetas = [pi/2 -pi/4 0 pi/4];
        case('a_trous_contrast')
            thetas = [pi/2 -pi/4 0 pi/4];
        case('gabor_HMAX')
            thetas = [pi/2 -pi/4 0 pi/4];
    end
    theta = thetas(orient);
end

