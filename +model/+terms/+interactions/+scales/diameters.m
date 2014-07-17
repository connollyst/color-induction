function scale_diameters = diameters(scale_deltas)
%INTERACTIONS.SCALES.DIAMETERS Maximum diameter of the area of influence
    scale_diameters = 2 * scale_deltas + 1;
end

