 img=imread('cameraman.tif');
% img=imread('mandril.tif');
% img=imread('White_effect_pattern_W2_128.ppm');
% img=imread('Mach_OP.ppm');

canal=img(:,:,1);

figure,imshow (canal);

ampl=size(canal,2);
alc=size(canal,1);

nPlans=4;
[w c]=a_trous(double(canal),nPlans);
% [w c]=a_trous_contrast(double(canal),nPlans);

for i=1:nPlans
    figure,imagesc(w{i}(:,:));colormap('gray');
    figure,imagesc(c{i}/255);colormap('gray');
end



rec=Ia_trous(w,c);
% rec=Ia_trous_contrast(w,c);

figure,imshow(rec/255);

dif=double(rec)-double(canal);

figure,imagesc(dif);colormap('gray');

max(dif(:))
min(dif(:))
