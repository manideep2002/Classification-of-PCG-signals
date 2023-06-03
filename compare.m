Tw = 5*1000;% analysis frame duration (ms)
        Ts = 10;                % analysis frame shift (ms)
        alpha = 0.97;           % preemphasis coefficient
        M = 20;                 % number of filterbank channels 
        C = 12;                 % number of cepstral coefficients
        L = 22;                 % cepstral sine lifter parameter
        LF = 5;                 % lower frequency limit (Hz)
        HF = 500;
normal = {'a0001.wav', 'a0002.wav', 'a0003.wav', 'a0004.wav', 'a0005.wav', 'a0006.wav', 'a0008.wav', 'a0010.wav', 'a0013.wav', 'a0014.wav', 'a0015.wav', 'a0017.wav', 'a0018.wav', 'a0020.wav', 'a0021.wav', 'a0022.wav', 'a0023.wav', 'a0024.wav', 'a0026.wav', 'a0030.wav', 'a0031.wav', 'a0033.wav', 'a0034.wav', 'a0036.wav', 'a0037.wav', 'a0039.wav', 'a0040.wav', 'a0041.wav', 'a0042.wav', 'a0043.wav', 'a0044.wav', 'a0045.wav', 'a0046.wav', 'a0047.wav', 'a0048.wav', 'a0051.wav', 'a0052.wav', 'a0054.wav', 'a0056.wav', 'a0057.wav', 'a0058.wav', 'a0059.wav', 'a0060.wav', 'a0061.wav', 'a0062.wav', 'a0063.wav', 'a0064.wav', 'a0065.wav', 'a0066.wav', 'a0067.wav', 'a0072.wav', 'a0073.wav', 'a0074.wav', 'a0075.wav', 'a0076.wav', 'a0077.wav', 'a0078.wav', 'a0079.wav', 'a0082.wav', 'a0083.wav', 'a0084.wav', 'a0087.wav', 'a0089.wav', 'a0090.wav', 'a0092.wav', 'a0095.wav', 'a0096.wav', 'a0097.wav', 'a0098.wav', 'a0099.wav', 'a0100.wav', 'a0101.wav', 'a0103.wav', 'a0104.wav', 'a0107.wav', 'a0110.wav', 'a0111.wav', 'a0112.wav', 'a0113.wav', 'a0114.wav', 'a0115.wav', 'a0116.wav', 'a0117.wav', 'a0119.wav', 'a0120.wav', 'a0121.wav', 'a0122.wav', 'a0123.wav', 'a0124.wav', 'a0126.wav', 'a0128.wav', 'a0130.wav', 'a0131.wav', 'a0132.wav', 'a0133.wav', 'a0134.wav', 'a0135.wav', 'a0137.wav', 'a0138.wav', 'a0142.wav'};
springer_options=default_Springer_HSMM_options;
n1=100;
pcn=cell(n1,2);
for i=1:length(normal)
    recordName = normal{i};
    [wave1, Fs] = audioread(['..\MATLAB\Data\training\training-a\' recordName]);
    wave1 = butterworth_low_pass_filter(wave1,2,400,Fs, false);
    wave1 = butterworth_high_pass_filter(wave1,2,25,Fs);
    wave1 = schmidt_spike_removal(wave1,Fs);
    pcn{i,1} = resample(wave1, springer_options.audio_Fs, Fs);
end
for i=1:n1
    [PCG_Features, featuresFs] = getSpringerPCGFeatures(pcn{i,1}, Fs);
    pcn{i,2} =PCG_Features;
end
abnormal = {'a0007', 'a0009', 'a0011', 'a0012', 'a0016', 'a0019', 'a0025', 'a0027', 'a0028', 'a0029', 'a0032', 'a0035', 'a0038', 'a0049', 'a0050', 'a0053', 'a0055', 'a0068', 'a0069', 'a0070', 'a0071', 'a0080', 'a0081', 'a0085', 'a0086', 'a0088', 'a0091', 'a0093', 'a0094', 'a0102', 'a0105', 'a0106', 'a0108', 'a0109', 'a0118', 'a0125', 'a0127', 'a0129', 'a0136', 'a0139', 'a0140', 'a0141', 'a0153', 'a0154', 'a0155', 'a0161', 'a0165', 'a0171', 'a0178', 'a0179', 'a0181', 'a0184', 'a0185', 'a0189', 'a0193', 'a0195', 'a0196', 'a0199', 'a0204', 'a0208', 'a0210', 'a0211', 'a0212', 'a0227', 'a0229', 'a0231', 'a0235', 'a0238', 'a0241', 'a0243', 'a0250', 'a0253', 'a0264', 'a0266', 'a0270', 'a0271', 'a0274', 'a0283', 'a0285', 'a0287', 'a0289', 'a0290', 'a0293', 'a0294', 'a0298', 'a0299', 'a0301', 'a0302', 'a0304', 'a0309', 'a0310', 'a0311', 'a0323', 'a0325', 'a0328', 'a0329', 'a0330', 'a0332', 'a0334', 'a0337'};

n2 = length(abnormal);

pcab = cell(n2, 2);
for fileNum = 1:n2
    recordName = sprintf('%s.wav', abnormal{fileNum});
    [wave2, Fs] = audioread(['..\MATLAB\Data\training\training-a\' recordName]);
    wave2 = butterworth_low_pass_filter(wave2,2,400,Fs, false);
    wave2 = butterworth_high_pass_filter(wave2,2,25,Fs);
    wave2 = schmidt_spike_removal(wave2,Fs);
    pcab{fileNum, 1} = resample(wave2, springer_options.audio_Fs, Fs);
end
for i=1:n2
    [PCG_Features, featuresFs] = getSpringerPCGFeatures(pcab{i,1}, Fs);
    pcn{i,2} =PCG_Features;
end
sumn=0;
for i=1:100
    sumn=sumn+pcn{i,2};
end
sumn=sumn/100;
sumab=0;
for i=1:100
    sumab=sumab+pcab{i,2};
end
sumab=sumab/100;
ratio=sumab/sumn;
ratioinverse=1/ratio;
% testn=pcn{1,2};
% for i=2:100
% testn=testn+pcn{i,2};
% end
% testab=pcab{1,2};
% for i=2:100
% testab=testab+pcab{i,2};
% end
% allr=testn./testab;
% invalle=testab./testn;