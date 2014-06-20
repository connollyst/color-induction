function [J_exc,W_inh]=get_Jithetajtheta_v0_4_sub(scale,K,orient,Delta,multires, zli)



orient_interaction=zli.orient_interaction;

diam=2*Delta+1; % maximum diameter of the area of influence


J_exc=zeros(diam,diam,K);
W_inh=zeros(diam,diam,K);


xx=repmat([(-Delta:1:Delta)],2*Delta+1,1);
yy=repmat([(-Delta:1:Delta)]',1,2*Delta+1);

factor_scale=utils.scale2size(scale,zli.scale2size_type,zli.scale2size_epsilon);

d=utils.distance_xop(xx/factor_scale,yy/factor_scale,zli.dist_type)*zli.reduccio_JW;




theta=utils.angle_orient(orient,multires);


for o=1:K
    
    
    M_exc_conv=zeros(size(d));
    M_inh_conv=zeros(size(d));
    
    % should this be 0 = orient??
    if (o~=orient && orient_interaction==0)
        J_exc(:,:,o)=0;
        W_inh(:,:,o)=0;
    else
        
        thetap=utils.angle_orient(o,multires);
        
        Dtheta=utils.send_in_the_right_interval_pi_2(theta-thetap);
        
        
        
        c=complex(xx,yy);
        angline=utils.send_in_the_right_interval_pi_2(angle(c));
        theta1=utils.send_in_the_right_interval_pi_2(theta-angline);
        theta2=utils.send_in_the_right_interval_pi_2(thetap-angline);
        
        angle1=theta1;
        angle2=theta2;
        
			ii=find(abs(theta1)>abs(theta2));
         theta1(ii)=angle2(ii);
			theta2(ii)=angle1(ii);
        
		  
	  
			beta=2*abs(theta1)+2*sin(abs(theta1+theta2));
        
        % J: Excitation
        
        ii=find( (d>=1 & d<=10 & beta<pi/2.69) | ((d>=1 & d<=10 & beta<pi/1.1) & abs(theta1)<pi/5.9 & abs(theta2)<pi/5.9) );
        M_exc_conv(ii)=0.126*exp(-(beta(ii)./d(ii)).^2-2*(beta(ii)./d(ii)).^7-(d(ii).^2)/90);
        
        % W: Inhibition
        
        jj=find(~(d<1 | d./cos(beta/4)>=10 | beta<pi/1.1 | abs(Dtheta)>=pi/3 | abs(theta1)<pi/11.999) );
        
        M_inh_conv(jj)=0.14*(1-exp(-0.4*(beta(jj)./d(jj)).^1.5))*exp(-(abs(Dtheta)/(pi/4))^1.5);
        
        
        J_exc(:,:,o)=M_exc_conv;
        W_inh(:,:,o)=M_inh_conv;
        
        
    end
end


J_exc=zli.kappax*J_exc/(factor_scale^2);
W_inh=zli.kappay*W_inh/(factor_scale^2);




end

