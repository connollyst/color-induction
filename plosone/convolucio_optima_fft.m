function [res] = convolucio_optima_fft (data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft)


%
%  Performs discrete (using convn) or FFT (fftfilt) convolution depending
%  on data and filter sizes
%

% if(log2(numel(data))*2<numel(filter_fft))



if(fft_flag==1)

	% GPU
% 	data_gpu=gpuArray(data);
% 	filter_fft_gpu=gpuArray(filter_fft);
% 	data_fft_gpu=fft(data_gpu);
% 	
% 	conv_fft_gpu=data_fft_gpu.*filter_fft_gpu;
% 	conv_fft=gather(conv_fft_gpu);
% 	
% 	res=ifft(conv_fft,'symmetric');
% 	
% 	if avoid_circshift_fft~=1
% 		res=circshift(res,-half_size_filter);
% 	end

	
	

	
% 	res=fftfilt(filter,data);

	
	conv_fft=data.*filter_fft;
 	res=ifft(conv_fft,'symmetric');
	
		
	if avoid_circshift_fft~=1
		res=circshift(res,-half_size_filter);
	end
	
else
% 	datapad=padarray(data,[half_size_filter,'symmetric');

	%	GPU
% 	data_gpu=gpuArray(data);
% 	filter_fft_gpu=gpuArray(filter_fft);
% 	res_gpu=convn(data_gpu,filter_fft_gpu,'same');
% 	res=gather(res_gpu);




	res=convn(data,filter_fft,'same');



end


% Amb el filtre que NO es una FFT

% if(fft_flag==1)
% 	% 	res=fftfilt(filter,data);
% 	
% 	data_fft=fftn(data);
% 	
% 	filter_fft_pad=fftn(filter_fft,size(data));
% 	
% 	conv_fft=data_fft.*filter_fft_pad;
% 	
% 	res=ifftn(conv_fft,'symmetric');
% 	
% 	res=circshift(res,-half_size_filter);
% 	
% else
% 	res=convn(data,filter_fft,'same');
% end





end