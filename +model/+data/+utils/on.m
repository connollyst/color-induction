function I_on = on( I )
    I_on = I;
    I_on(I_on < 0) = 0;
end