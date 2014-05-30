function d = distance_xop(xx, yy, type)
    switch type
        case ('eucl')
            d = sqrt(xx.*xx + yy.*yy);
        case ('manh')
            d = abs(xx) + abs(yy);
        otherwise
            error('Unsupported distance calculation type: %s', type);
    end
end