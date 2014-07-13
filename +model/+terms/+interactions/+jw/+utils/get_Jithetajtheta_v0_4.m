function [J_exc_out, W_inh_out] = get_Jithetajtheta_v0_4(scale, K, orient, Delta, transform, zli)
    K             = 4;
    pes_diag      = 0.5;
    [J_exc,W_inh] = get_Jithetajtheta_v0_4_sub(scale,K,orient,Delta,transform, zli);
    if orient == 1 || orient == 3
        % horizontal & vertical
        J_exc(:,:,2)     = (J_exc(:,:,2)     + J_exc(:,:,4))      * pes_diag;
        W_inh(:,:,2)     = (W_inh(:,:,2)     + W_inh(:,:,4))      * pes_diag;
    end
    if orient == 2
        % diagonal
        [J_diag, W_diag] = get_Jithetajtheta_v0_4_sub(scale, K, 4, Delta, transform, zli);
        J_exc(:,:,[1 3]) = (J_exc(:,:,[1 3]) + J_diag(:,:,[1 3])) * pes_diag;
        W_inh(:,:,[1 3]) = (W_inh(:,:,[1 3]) + W_diag(:,:,[1 3])) * pes_diag;
        J_exc(:,:,2)     = (J_exc(:,:,2)     + J_diag(:,:,4))     * pes_diag;
        W_inh(:,:,2)     = (W_inh(:,:,2)     + W_diag(:,:,4))     * pes_diag;
    end
    J_exc_out = J_exc(:,:,1:3);
    W_inh_out = W_inh(:,:,1:3);
end

function [J_exc, W_inh] = get_Jithetajtheta_v0_4_sub(scale, K, orient, Delta, transform, zli)
    diameter     = 2*Delta+1; % maximum diameter of the area of influence
    J_exc        = zeros(diameter, diameter, K);
    W_inh        = zeros(diameter, diameter, K);

    [xx, yy]     = model.terms.interactions.jw.utils.gradients(Delta);
    factor_scale = model.utils.scale2size(scale, zli.scale2size_type, zli.scale2size_epsilon);
    d            = model.utils.distance_xop(xx/factor_scale,yy/factor_scale,zli.dist_type)*zli.reduccio_JW;
    c            = complex(xx, yy);
    theta        = model.utils.angle_orient(orient, transform);

    for o=1:K
        M_exc_conv = zeros(size(d));
        M_inh_conv = zeros(size(d));
        % should this be 0 = orient??
        if o ~= orient && zli.orient_interaction == 0
            J_exc(:,:,o) = 0;
            W_inh(:,:,o) = 0;
        else
            thetap     = model.utils.angle_orient(o, transform);
            Dtheta     = model.utils.send_in_the_right_interval_pi_2(theta  - thetap);
            angline    = model.utils.send_in_the_right_interval_pi_2(angle(c));
            theta1     = model.utils.send_in_the_right_interval_pi_2(theta  - angline);
            theta2     = model.utils.send_in_the_right_interval_pi_2(thetap - angline);
            angle1     = theta1;
            angle2     = theta2;
            ii         = find(abs(theta1) > abs(theta2));
            theta1(ii) = angle2(ii);
            theta2(ii) = angle1(ii);
            beta       = 2*abs(theta1)+2*sin(abs(theta1+theta2));
            % J: Excitation
            ii = find( (d>=1 & d<=10 & beta<pi/2.69) | ((d>=1 & d<=10 & beta<pi/1.1) & abs(theta1)<pi/5.9 & abs(theta2)<pi/5.9) );
            M_exc_conv(ii) = 0.126*exp(-(beta(ii)./d(ii)).^2-2*(beta(ii)./d(ii)).^7-(d(ii).^2)/90);
            % W: Inhibition
            jj = find(~(d<1 | d./cos(beta/4)>=10 | beta<pi/1.1 | abs(Dtheta)>=pi/3 | abs(theta1)<pi/11.999) );
            M_inh_conv(jj) = 0.14*(1-exp(-0.4*(beta(jj)./d(jj)).^1.5))*exp(-(abs(Dtheta)/(pi/4))^1.5);
            
            J_exc(:,:,o) = M_exc_conv;
            W_inh(:,:,o) = M_inh_conv;
        end
    end
    J_exc = zli.kappax * J_exc / (factor_scale^2);
    W_inh = zli.kappay * W_inh / (factor_scale^2);
end