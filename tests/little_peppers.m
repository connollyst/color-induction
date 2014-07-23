function peppers = little_peppers()
%LITTLE_PEPPERS Load up a small copy for the 'peppers' image for testing.
    peppers = imresize(imread('peppers.png'), 0.1);
end

