function  theta = angle_orient(orient, transform)
% state it in the perpendicular direction, because one thing is the change
% direction and the other is the edge orientation 
    switch(transform)
        case('swt')
            thetas = [pi/2 -pi/4 0 pi/4];
        case('dwt')
            thetas = [pi/2 -pi/4 0 pi/4];
        case('opponent')
            thetas = [pi/2 -pi/4 0 pi/4];
        otherwise
            error('Invalid tranform: %s', transform);
    end
    theta = thetas(orient);
end

