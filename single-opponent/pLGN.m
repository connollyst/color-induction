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
        show_figure(1, 'pLo', pLo);
        show_figure(2, 'mLo', mLo);
        show_figure(3, 'pMo', pMo);
        show_figure(4, 'mMo', mMo);
        show_figure(5, 'pSo', pSo);
        show_figure(6, 'mSo', mSo);
        show_figure(7, 'LMs', LMs);
    end
    
    %% Higher level integration of color channels by V1 (p1011)
    light  = pLo + pMo + pSo;
    dark   = mMo + mLo + mSo;
    red    = pLo + mMo + pSo;
    yellow = pLo + mMo + mSo;
    green  = pMo + mLo + mSo;
    blue   = pMo + mLo + pSo;
    if do_show()
        show_figure(11, 'light',  light);
        show_figure(12, 'dark',   dark);
        show_figure(13, 'red',    red);
        show_figure(14, 'yellow', yellow);
        show_figure(15, 'green',  green);
        show_figure(16, 'blue',   blue);
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

function show_figure(index, name, I)
    f = figure(index);
    set(f, 'name', name);
    set(f, 'Color', [1 1 1]);
    imagesc(I);
end