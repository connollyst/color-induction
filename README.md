This directory contains the MATLAB code corresponding to the computational
model presented in the paper
 
"A neurodynamical model of brightness induction in V1"
O. Penacchio, X. Otazu and L. Dempere-Marco
PLoS One, 2013.

Feel free to use/modify the code but please do not forget to cite the paper
if appropriate. Comments on the code are very welcome (cf. below for our
email addresses).

The main routine is general_NCZLd.m
 
Here is a running example:
```
>> img    = imread('cameraman.tif');
>> steps  = 5;
>> figure, imagesc(img);    colormap('gray');
>> imgout = process_image(img, steps);
>> figure, imagesc(imgout); colormap('gray');
```

Please take into account that required memory and execution time rapidly
increase with image size and number of membrane times. For a 256x256 image
and 5 membrane times the computation takes about 3-4 minutes using a 3.6GHz
quad-core CPU. A minimum of 16 membrane time constants is generally required
to have a good picture of the behaviour of the network.


For more information:

penacchio@cvc.uab.cat,xotazu@cvc.uab.cat


