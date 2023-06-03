function features = extractFeaturesFromHsIntervals(assigned_states, PCG)

indx = find(abs(diff(assigned_states))>0); % find the locations with changed states

if assigned_states(1)>0   % for some recordings, there are state zeros at the beginning of assigned_states
    switch assigned_states(1)
        case 4
            K=1;
        case 3
            K=2;
        case 2
            K=3;
        case 1
            K=4;
    end
else
    switch assigned_states(indx(1)+1)
        case 4
            K=1;
        case 3
            K=2;
        case 2
            K=3;
        case 1
            K=0;
    end
    K=K+1;
end

indx2                = indx(K:end);
rem                  = mod(length(indx2),4);
indx2(end-rem+1:end) = [];
A                    = reshape(indx2,4,length(indx2)/4)'; % A is N*4 matrix, the 4 columns save the beginnings of S1, systole, S2 and diastole in the same heart cycle respectively

%% Feature calculation
m_RR        = round(mean(diff(A(:,1))));             % mean value of RR intervals
sd_RR       = round(std(diff(A(:,1))));              % standard deviation (SD) value of RR intervals
mean_IntS1  = round(mean(A(:,2)-A(:,1)));            % mean value of S1 intervals
sd_IntS1    = round(std(A(:,2)-A(:,1)));             % SD value of S1 intervals
mean_IntS2  = round(mean(A(:,4)-A(:,3)));            % mean value of S2 intervals
sd_IntS2    = round(std(A(:,4)-A(:,3)));             % SD value of S2 intervals
mean_IntSys = round(mean(A(:,3)-A(:,2)));            % mean value of systole intervals
sd_IntSys   = round(std(A(:,3)-A(:,2)));             % SD value of systole intervals
mean_IntDia = round(mean(A(2:end,1)-A(1:end-1,4)));  % mean value of diastole intervals
sd_IntDia   = round(std(A(2:end,1)-A(1:end-1,4)));   % SD value of diastole intervals
for i=1:size(A,1)-1
    R_SysRR(i)  = (A(i,3)-A(i,2))/(A(i+1,1)-A(i,1))*100;
    R_DiaRR(i)  = (A(i+1,1)-A(i,4))/(A(i+1,1)-A(i,1))*100;
    R_SysDia(i) = R_SysRR(i)/R_DiaRR(i)*100;
    
    P_S1(i)     = sum(abs(PCG(A(i,1):A(i,2))))/(A(i,2)-A(i,1));
    P_Sys(i)    = sum(abs(PCG(A(i,2):A(i,3))))/(A(i,3)-A(i,2));
    P_S2(i)     = sum(abs(PCG(A(i,3):A(i,4))))/(A(i,4)-A(i,3));
    P_Dia(i)    = sum(abs(PCG(A(i,4):A(i+1,1))))/(A(i+1,1)-A(i,4));
    if P_S1(i)>0
        P_SysS1(i) = P_Sys(i)/P_S1(i)*100;
    else
        P_SysS1(i) = 0;
    end
    if P_S2(i)>0
        P_DiaS2(i) = P_Dia(i)/P_S2(i)*100;
    else
        P_DiaS2(i) = 0;
    end
end
R_SysRR(i)  = (A(i,3)-A(i,2))/(A(i+1,1)-A(i,1))*100;
m_Ratio_SysRR   = mean(R_SysRR);  % mean value of the interval ratios between systole and RR in each heart beat
sd_Ratio_SysRR  = std(R_SysRR);   % SD value of the interval ratios between systole and RR in each heart beat
m_Ratio_DiaRR   = mean(R_DiaRR);  % mean value of the interval ratios between diastole and RR in each heart beat
sd_Ratio_DiaRR  = std(R_DiaRR);   % SD value of the interval ratios between diastole and RR in each heart beat
m_Ratio_SysDia  = mean(R_SysDia); % mean value of the interval ratios between systole and diastole in each heart beat
sd_Ratio_SysDia = std(R_SysDia);  % SD value of the interval ratios between systole and diastole in each heart beat

indx_sys = find(P_SysS1>0 & P_SysS1<100);   % avoid the flat line signal
if length(indx_sys)>1
    m_Amp_SysS1  = mean(P_SysS1(indx_sys)); % mean value of the mean absolute amplitude ratios between systole period and S1 period in each heart beat
    sd_Amp_SysS1 = std(P_SysS1(indx_sys));  % SD value of the mean absolute amplitude ratios between systole period and S1 period in each heart beat
else
    m_Amp_SysS1  = 0;
    sd_Amp_SysS1 = 0;
end
indx_dia = find(P_DiaS2>0 & P_DiaS2<100);
if length(indx_dia)>1
    m_Amp_DiaS2  = mean(P_DiaS2(indx_dia)); % mean value of the mean absolute amplitude ratios between diastole period and S2 period in each heart beat
    sd_Amp_DiaS2 = std(P_DiaS2(indx_dia));  % SD value of the mean absolute amplitude ratios between diastole period and S2 period in each heart beat
else
    m_Amp_DiaS2  = 0;
    sd_Amp_DiaS2 = 0;
end
Tw = 5*1000;% analysis frame duration (ms)
        Ts = 10;                % analysis frame shift (ms)
        alpha = 0.97;           % preemphasis coefficient
        M = 20;                 % number of filterbank channels 
        C = 12;                 % number of cepstral coefficients
        L = 22;                 % cepstral sine lifter parameter
        LF = 5;                 % lower frequency limit (Hz)
        HF = 500;
        fs=2000;
totalbandpower=bandpower(PCG);
energy=calculate_energy(PCG);
meansignal=mean(PCG);
mediansignal=median(PCG);
stdsignal=std(PCG);
madsignal=mad(PCG);
iqrsignal=iqr(PCG);
onefourthquantile=quantile(PCG, 0.25);
threefourthquantile=quantile(PCG,0.75);
skewnesssignal=skewness(PCG);
kurtosissignal=kurtosis(PCG);
signalentropy=signal_entropy(PCG');
spectralentropy=spectral_entropy(PCG);

features = [totalbandpower spectralentropy signalentropy energy skewnesssignal  kurtosissignal meansignal stdsignal madsignal mediansignal onefourthquantile threefourthquantile iqrsignal m_RR sd_RR  mean_IntS1 sd_IntS1  mean_IntS2 sd_IntS2  mean_IntSys sd_IntSys  mean_IntDia sd_IntDia m_Ratio_SysRR sd_Ratio_SysRR m_Ratio_DiaRR sd_Ratio_DiaRR m_Ratio_SysDia sd_Ratio_SysDia m_Amp_SysS1 sd_Amp_SysS1 m_Amp_DiaS2 sd_Amp_DiaS2];




