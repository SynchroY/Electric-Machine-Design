clearvars;
u0 = 4*pi*1e-7;

%设置迭代初始值
KE = 0.9;
error_KE = 1;
Ks = 1.4;
%不满足误差条件，持续迭代
while (error_KE>0.005)

    E1 = KE*220;
    error_Ks = 1;

    At1 = 2573e-6;
    At2 = 2554e-6;
    Aj1 = 939e-6;
    Aj2 = 937e-6;
    Adelta= 6943e-6;
    deltaef = 0.268e-3;
    Kdelta1 = 1.018;

    %对饱和系数进行迭代
    while  (error_Ks>0.01)
        %查表得到对应值
        KNm = input(['When Ks = ',num2str(Ks),'KNm = ']);
        Phi = E1/(4*KNm*0.927*50*354);
        Fs = input(['When Ks = ',num2str(Ks),'Fs = ']);
        Bdelta = Fs*Phi/Adelta;
        Bi1 = Fs*Phi/At1;
        Bi2 = Fs*Phi/At2;
        %查磁化曲线并输入磁场强度
        Hi1 = input(['When Bi1 = ',num2str(Bi1),'Hi1 = ']);
        Hi2 = input(['When Bi2 = ',num2str(Bi2),'Hi2 = ']);
        Fdelta = 0.8e6*1.016*0.259e-3*Bdelta;
        Fi1 = Hi1*9.03e-1;
        Fi2 = Hi2*7.3e-1;
        %得到饱和系数计算值
        Ks_new = (Fdelta+Fi1+Fi2)/Fdelta;
        error_Ks = abs(Ks_new - Ks)/Ks;
        %误差不满足要求，重新设定初始值
        if (error_Ks>0.01)
            Ks = (Ks_new-(Ks_new-Ks)/3);
        end
    end
    %显示饱和系数迭代完成信息
    disp(['Ks is OK, and Ks = ',num2str(Ks)]);
    Ks = Ks_new;

    Bj1 = 0.5*Phi/Aj1;
    Bj2 = 0.5*Phi/Aj2;
    %查磁化曲线并输入磁场强度
    Hj1 = input(['When Bj1  ',num2str(Bj1),'Hj1 = ']);
    Hj2 = input(['When Bj2 = ',num2str(Bj2),'Hj2 = ']);
    Cj1 = input(['When Bj1 = ',num2str(Bj1),'Cj1 = ']);
    Cj2 = input(['When Bj2 = ',num2str(Bj2),'Cj2 = ']);
    Fj1 = Cj1*Hj1*0.0823e2;
    Fj2 = Cj2*Hj2*0.0268e2;
    F0 = Fj1+Fj2+Fi1+Fi2+Fdelta;
    Im = 2*1*F0/(0.9*3*354*0.927);
    Imb = Im/1.136;
    Xms = 4*50*u0*3*(354*0.927)^2*0.0655*0.106/(pi*Ks*1*0.268e-3);
    Xmsb = Xms*1.136/220;

    Cx = 0.02877;

    Xs1b = 0.2874*Cx;
    Xdelta1b = 3*0.106*0.0095/(pi^2*0.268*1e-3*0.927^2*Ks)*Cx;
    XE1b = 0.2684*Cx;
    Xsigma1b = Xs1b+Xdelta1b+XE1b;

    Xs2b = 0.5127*Cx;
    Xdelta2b = 3*0.106*0.014/(pi^2*0.268e-3*Ks)*Cx;
    XE2b = 0.326*Cx;
    Xskb = 0.4567*Cx;
    Xsigma2b = Xs2b+Xdelta2b+Xskb+XE2b;

    Xsigmab = Xsigma1b + Xsigma2b;

    R1b = 0.0532;
    R2b = 0.0358;

    I1pb = 1.33;
    sigma1 = 1+Xsigma1b/Xmsb;
    Ixb = sigma1*Xsigmab*I1pb^2*(1+(sigma1*Xsigmab*I1pb)^2);
    I1Qb = Ixb + Imb;
    
    %得到KE计算值
    KE_new = 1-(I1pb*R1b+I1Qb*Xsigma1b);
    %与本次初始值的误差
    error_KE = abs(KE_new-KE)/KE;
    %误差不满足要求，则重新设置迭代初始值
    if (error_KE>0.005)
		KE = (KE_new-(KE_new-KE)/3);
    end
    %显示最终迭代结果
    disp(['KE = ',num2str(KE),'  error = ',num2str(error_KE)]);
end