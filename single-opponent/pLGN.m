function [light, dark, red, yellow, green, blue] = pLGN( I, varargin )
%pLGN Parvocellular Lateral Geniculate Nucleus (pLGN) simulation
%   Simulate the parvocellular lateral geniculate nucleus (pLGN) processing
%   of the input color image.
    L = I(:,:,1); % Long wavelength:   red
    M = I(:,:,2); % Middle wavelength: green
    S = I(:,:,3); % Short wavelength:  blue
    Lc = center(L);
    Mc = center(M);
    Sc = center(S);
    Ls = surround(L);
    Ms = surround(M);
    Ss = surround(S);   % TODO any reference to short surround in lit?
    
    %% Plus (p**) and minus (m**) opponency channels (p1009)
    pLo =  Lc - Ms;
    mLo = -Lc + Ms;
    pMo =  Mc - Ls;
    mMo = -Mc + Ls;
    LMs =  Ls .* Ms;
    pSo =  Sc - LMs;
    mSo = -Sc + LMs;
    if do_show()
        figure(1); imshow(pLo);
        figure(2); imshow(mLo);
        figure(3); imshow(pMo);
        figure(4); imshow(mMo);
        figure(5); imshow(pSo);
        figure(6); imshow(mSo);
        figure(7); imshow(LMs);
    end
    
    %% Higher level integration of color channels by V1 (p1011)
    light  = pLo + pMo + pSo;
    dark   = mMo + mLo + mSo;
    red    = pLo + mMo + pSo;
    yellow = pLo + mMo + mSo;
    green  = pMo + mLo + mSo;
    blue   = pMo + mLo + pSo;
    if do_show()
        figure(11); imshow(light);
        figure(12); imshow(dark);
        figure(13); imshow(red);
        figure(14); imshow(yellow);
        figure(15); imshow(green);
        figure(16); imshow(blue);
    end
    
    %% Utility function to find 
    function show = do_show()
        show = ~isempty(varargin) && strcmp(varargin{1},'display');
    end
end

function Ic = center( I )
    Ic = gaussian(I, 5, 2);
end

function Is = surround( I )
    Is = gaussian(I, 20, 5);
end

function filtered = gaussian( img, hsize, sigma)
    filter   = fspecial('gaussian', [hsize hsize], sigma);
    filtered = imfilter(img, filter, 'same');
end