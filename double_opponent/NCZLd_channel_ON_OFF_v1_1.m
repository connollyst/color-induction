function [curv_final_out, curv_ON_final, curv_OFF_final, iFactor_ON, iFactor_OFF] = NCZLd_channel_ON_OFF_v1_1(curv_in,struct)

% from NCZLd_channel_ON_OFF_v1_1.m to Rmodelinductiond_v0_3_2.m

% separate ON and OFF channels
% start the recovering at the level of the wavelet/Gabor responses

% preallocate
curv_final_out = curv_in;

%-------------------------------------------------------
% make the structure explicit/get the parameters
zli           = struct.zli;
display_plot  = struct.display_plot;
image         = struct.image;
% struct.zli  
% normalization
n_membr       = zli.n_membr;
ON_OFF        = zli.ON_OFF;
plot_wavelet_planes = display_plot.plot_wavelet_planes;
% struct.compute
% dynamic/constant
% dynamic=compute.dynamic;
% n_orient=size(curv{1}{scale},2);
fin_scale     = struct.wave.fin_scale;
%-------------------------------------------------------

curv=cell(n_membr,1);
% initialize
for ff=1:n_membr
	n_orient = size(curv_in{ff}{1},2);
	curv{ff} = zeros([size(curv_in{ff}{1}{1}) fin_scale n_orient]);
	for s=1:fin_scale
		for o=1:n_orient
			curv{ff}(:,:,s,o) = curv_in{ff}{s}{o};
		end
	end
end
% number of scales
struct.wave.n_scales=fin_scale;
% initialize
curv_final     = curv;	 
index_ON       = cell(n_membr,1);
index_OFF      = cell(n_membr,1);
curv_ON        = curv;
curv_OFF       = curv;
curv_ON_final  = curv;
curv_OFF_final = curv;
	 
% handle ON and OFF separately/together
for t_membr=1:n_membr
    index_OFF{t_membr} = find(curv{t_membr}<=0);  % was curv{orient}
    index_ON{t_membr}  = find(curv{t_membr}>=0);
end

% choose the algorithm (separated, abs, quadratic) 
switch(ON_OFF)
    case 0 % separated
        for t_membr=1:n_membr
            curv_ON{t_membr} = curv{t_membr};
            curv_OFF{t_membr} = -curv{t_membr};
            curv_OFF{t_membr}(index_ON{t_membr})=0;
            curv_ON{t_membr}(index_OFF{t_membr})=0;
        end
        
            
            % positius +++++++++++++++++++++++++++++++++++++++++++++++++++
            %%% MAIN PROCESS %%%
			disp('Starting ON processing');
            iFactor_ON=Rmodelinductiond_v0_3_2(curv_ON, struct);
            %%% END MAIN PROCESS %%%
            
            
            % negatius ----------------------------------------------------
            %%% MAIN PROCESS %%%
			disp('Starting OFF processing');
            iFactor_OFF=Rmodelinductiond_v0_3_2(curv_OFF, struct);
            %%% END MAIN PROCESS %%%
            
            iFactor=iFactor_ON;
        
        for t_membr=1:n_membr
            curv_ON_final{t_membr}=curv_ON{t_membr}.*iFactor_ON{t_membr}*zli.normal_output;
            curv_OFF_final{t_membr}=-curv_OFF{t_membr}.*iFactor_OFF{t_membr}*zli.normal_output;

				iFactor{t_membr}=iFactor_ON{t_membr}+iFactor_OFF{t_membr};
            curv_final{t_membr}=curv_ON_final{t_membr}+curv_OFF_final{t_membr};
        end
        
        
    case 1 % abs
        dades=curv;
        for t_membr=1:n_membr
            dades{t_membr}=abs(curv{t_membr});
        end
        
        iFactor=Rmodelinductiond_v0_3_2(dades, struct);
        
        for t_membr=1:n_membr
            curv_final{t_membr}=curv{t_membr}.*iFactor{t_membr}*zli.normal_output;t;
        end
        
    case 2 % square (quadratic)
        dades=curv;
        for t_membr=1:n_membr
            dades{t_membr}=curv{t_membr}.*curv{t_membr};
        end
        iFactor=Rmodelinductiond_v0_3_2(dades, struct);
        for t_membr=1:n_membr
            curv_final{t_membr}=curv{t_membr}.*iFactor{t_membr}*zli.normal_output;
        end
end

		 
for ff=1:n_membr
			for s=1:fin_scale
				for o=1:n_orient
					curv_final_out{ff}{s}{o}=curv_final{ff}(:,:,s,o);
				end
			end
end

% save raw values for all
if struct.display_plot.store==1
    save([image.name '_curv'],'curv');
    save([image.name '_curv_final'],'curv_final');
    switch(ON_OFF)
        case 0
            save([image.name '_curv_ON'],'curv_ON');
            save([image.name '_curv_OFF'],'curv_OFF');
            save([image.name '_curv_ON_final'],'curv_ON_final');
            save([image.name '_curv_OFF_final'],'curv_OFF_final');
            save([image.name '_iFactor_ON'],'iFactor_ON');
            save([image.name '_iFactor_OFF'],'iFactor_OFF');
            save([image.name '_iFactor'],'iFactor');
        case 1
            save([image.name '_iFactor'],'iFactor');
        case 2
            save([image.name '_iFactor'],'iFactor');
    end
end

% display for debuging
if plot_wavelet_planes==1
    figure;
    subplot(1,3,1),imagesc(curv{n_iter}{scale}{orient});colormap('gray');
    subplot(1,3,2),imagesc(iFactor(:,:,n_iter),[0 1]); colormap('gray');
    subplot(1,3,3),imagesc(curv_final{n_iter}{orient});colormap('gray');
end


end