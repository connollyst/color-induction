function filtered = gaussian( img, hsize, sigma)
    filter   = fspecial('gaussian', [hsize hsize], sigma);
    filtered = imfilter(img, filter, 'same');
end

