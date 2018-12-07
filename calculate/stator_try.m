clearvars;


b01_step = 0.01;
h01_step = 0.01;
max_b01 = 3.8;
min_b01 = 0.01;
max_h01 = 1.5;
min_h01 = 0.01;
B01 = min_b01:b01_step:max_b01;
H01 = min_h01:h01_step:max_h01;

Ksf = zeros(length(B01),length(H01));

for i = 1:length(B01)
    for j = 1:length(H01)
        
        b01 = B01(i);
        h01 = H01(j);
        [Ksf(i,j),bi11,bi12] = stator_size(b01*1e-3,h01*1e-3);
        if (Ksf(i,j)>0.7)&&(Ksf(i,j)<0.8)&&((abs(bi11-bi12)/bi11)<0.005)
            disp(['b01=',num2str(b01),',h01=',num2str(h01),' Ksf=',num2str(Ksf(i,j)*100),'%']);
        end
    end
end

imagesc(B01,H01,Ksf);