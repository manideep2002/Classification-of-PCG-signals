fs=2000;
normal = {'b0008.wav', 'b0013.wav', 'b0016.wav', 'b0018.wav', 'b0022.wav', 'b0023.wav', 'b0030.wav', 'b0032.wav', 'b0033.wav', 'b0037.wav', 'b0040.wav', 'b0041.wav', 'b0043.wav', 'b0046.wav', 'b0048.wav', 'b0054.wav', 'b0057.wav', 'b0063.wav', 'b0068.wav', 'b0077.wav', 'b0081.wav', 'b0086.wav', 'b0096.wav', 'b0106.wav', 'b0117.wav', 'b0120.wav', 'b0130.wav', 'b0136.wav', 'b0137.wav', 'b0140.wav', 'b0148.wav', 'b0155.wav', 'b0159.wav', 'b0164.wav', 'b0171.wav', 'b0176.wav', 'b0190.wav', 'b0197.wav', 'b0208.wav', 'b0221.wav', 'b0224.wav', 'b0232.wav', 'b0233.wav', 'b0235.wav', 'b0238.wav', 'b0239.wav', 'b0242.wav', 'b0243.wav', 'b0248.wav', 'b0251.wav', 'b0253.wav', 'b0257.wav', 'b0262.wav', 'b0263.wav', 'b0265.wav', 'b0267.wav', 'b0271.wav', 'b0273.wav', 'b0278.wav', 'b0279.wav', 'b0280.wav', 'b0284.wav', 'b0292.wav', 'b0295.wav', 'b0299.wav', 'b0307.wav', 'b0318.wav', 'b0319.wav', 'b0327.wav', 'b0334.wav', 'b0335.wav', 'b0341.wav', 'b0342.wav', 'b0344.wav', 'b0349.wav', 'b0361.wav', 'b0365.wav', 'b0367.wav', 'b0369.wav', 'b0384.wav', 'b0385.wav', 'b0390.wav', 'b0395.wav', 'b0397.wav', 'b0408.wav', 'b0409.wav', 'b0413.wav', 'b0418.wav', 'b0422.wav', 'b0427.wav', 'b0428.wav', 'b0436.wav', 'b0437.wav', 'b0444.wav', 'b0446.wav', 'b0450.wav', 'b0455.wav', 'b0465.wav', 'b0467.wav','b0468.wav'};
springer_options=default_Springer_HSMM_options;
n1=100;
pcn=cell(n1,2);
for i=1:length(normal)
    recordName = normal{i};
    [wave1, Fs] = audioread(['..\MATLAB\Data\training\training-b\' recordName]);
    wave1 = butterworth_low_pass_filter(wave1,2,400,Fs, false);
    wave1 = butterworth_high_pass_filter(wave1,2,25,Fs);
    wave1 = schmidt_spike_removal(wave1,Fs);
    pcn{i,1} = resample(wave1, springer_options.audio_Fs, Fs);
end
for i=1:n1
    [maxfreq, maxval, maxratio] = dominant_frequency_features(pcn{i,1}, fs, 256, 0);
    pcn{i,2} =maxratio;
end
abnormal = {'b0001.wav', 'b0002.wav', 'b0003.wav', 'b0004.wav', 'b0005.wav', 'b0006.wav', 'b0007.wav', 'b0009.wav', 'b0010.wav', 'b0011.wav', 'b0012.wav', 'b0014.wav', 'b0015.wav', 'b0017.wav', 'b0019.wav', 'b0020.wav', 'b0021.wav', 'b0024.wav', 'b0025.wav', 'b0026.wav', 'b0027.wav', 'b0028.wav', 'b0029.wav', 'b0031.wav', 'b0034.wav', 'b0035.wav', 'b0036.wav', 'b0038.wav', 'b0039.wav', 'b0042.wav', 'b0044.wav', 'b0045.wav', 'b0047.wav', 'b0049.wav', 'b0050.wav', 'b0051.wav', 'b0052.wav', 'b0053.wav', 'b0055.wav', 'b0056.wav', 'b0058.wav', 'b0059.wav', 'b0060.wav', 'b0061.wav', 'b0062.wav', 'b0064.wav', 'b0065.wav', 'b0066.wav', 'b0067.wav', 'b0069.wav', 'b0070.wav', 'b0071.wav', 'b0072.wav', 'b0073.wav', 'b0074.wav', 'b0075.wav', 'b0076.wav', 'b0078.wav', 'b0079.wav', 'b0080.wav', 'b0082.wav', 'b0083.wav', 'b0084.wav', 'b0085.wav', 'b0087.wav', 'b0088.wav', 'b0089.wav', 'b0090.wav', 'b0091.wav', 'b0092.wav', 'b0093.wav', 'b0094.wav', 'b0095.wav', 'b0097.wav', 'b0098.wav', 'b0099.wav', 'b0100.wav', 'b0101.wav', 'b0102.wav', 'b0103.wav', 'b0104.wav', 'b0105.wav', 'b0107.wav', 'b0108.wav', 'b0109.wav', 'b0110.wav', 'b0111.wav', 'b0112.wav', 'b0113.wav', 'b0114.wav', 'b0115.wav', 'b0116.wav', 'b0118.wav', 'b0119.wav', 'b0121.wav', 'b0122.wav', 'b0123.wav', 'b0124.wav', 'b0125.wav', 'b0126.wav'};
pcab = cell(100, 2);
for i = 1:100
    recordName = abnormal{i};
    [wave2, Fs] = audioread(['..\MATLAB\Data\training\training-b\' recordName]);
    wave2 = butterworth_low_pass_filter(wave2,2,400,Fs, false);
    wave2 = butterworth_high_pass_filter(wave2,2,25,Fs);
    wave2 = schmidt_spike_removal(wave2,Fs);
    pcab{i, 1} = resample(wave2, springer_options.audio_Fs, Fs);
end
for i=1:100
    [maxfreqq, maxvall, maxratioo] = dominant_frequency_features(pcab{i,1}, fs, 256, 0);
    pcab{i,2} =maxratioo;
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