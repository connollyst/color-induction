function  theta = angle_orient(orient, transform)
% state it in the perpendicular direction, because one thing is the change
% direction and the other is the edge orientation 
    switch(transform)
        case('wav')
            thetas = [pi/2 -pi/4 0];
        case('a_trous')
            thetas = [pi/2 -pi/4 0 pi/4];
        case('a_trous_contrast')
            thetas = [pi/2 -pi/4 0 pi/4];
        case('gabor_HMAX')
            thetas = [pi/2 -pi/4 0 pi/4];
        case('DWD_orient_undecimated')
            thetas = [pi/2 -pi/4 0 pi/4];
        case('DWD_and_a_trous')
            thetas = [pi/2 -pi/4 0 pi/4];
        otherwise
            error('Invalid tranform: %s', transform);
    end
    theta = thetas(orient);
end

