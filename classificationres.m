na=409;
nb=490;
nc=31;
nd=55;
ne=2141;
nf=114;
pcg_index = 1;
pcg=cell(3240,2);
springer_options=default_Springer_HSMM_options;
for fileNum=1:na
    recordName=sprintf('a%04d.wav',fileNum);
    [wave, Fs]=audioread(['..\MATLAB\Data\training\training-a\' recordName]);
    pcg{pcg_index,1}=resample(wave,springer_options.audio_Fs,Fs);
    pcg_index = pcg_index + 1;
end
for fileNum=1:nb
    recordName=sprintf('b%04d.wav',fileNum);
    [wave, Fs]=audioread(['..\MATLAB\Data\training\training-b\' recordName]);
    pcg{pcg_index,1}=resample(wave,springer_options.audio_Fs,Fs);
    pcg_index = pcg_index + 1;
end
for fileNum=1:nc
    recordName=sprintf('c%04d.wav',fileNum);
    [wave, Fs]=audioread(['..\MATLAB\Data\training\training-c\' recordName]);
    pcg{pcg_index,1}=resample(wave,springer_options.audio_Fs,Fs);
    pcg_index = pcg_index + 1;
end
for fileNum=1:nd
    recordName=sprintf('d%04d.wav',fileNum);
    [wave, Fs]=audioread(['..\MATLAB\Data\training\training-d\' recordName]);
    pcg{pcg_index,1}=resample(wave,springer_options.audio_Fs,Fs);
    pcg_index = pcg_index + 1;
end
for fileNum=1:ne
    recordName=sprintf('e%05d.wav',fileNum);
    [wave, Fs]=audioread(['..\MATLAB\Data\training\training-e\' recordName]);
    pcg{pcg_index,1}=resample(wave,springer_options.audio_Fs,Fs);
    pcg_index = pcg_index + 1;
end
for fileNum=1:nf
    recordName=sprintf('f%04d.wav',fileNum);
    [wave, Fs]=audioread(['..\MATLAB\Data\training\training-f\' recordName]);
    pcg{pcg_index,1}=resample(wave,springer_options.audio_Fs,Fs);
    pcg_index = pcg_index + 1;
end
filename = 'reference_table.csv';
Y=xlsread(filename,'B:B');
for fileNum=1:3240
    pcg{fileNum,2}=runSpringerSegmentationAlgorithm(pcg{fileNum,1},springer_options.audio_Fs,Springer_B_matrix,Springer_pi_vector,Springer_total_obs_distribution,false);
end
X=table;
for idx=1:3240
    X{idx, :}=extractFeaturesFromHsIntervals(pcg{idx,2},pcg{idx,1});
end
X.classification=Y;
disp(X(1:10,:));
% model=fitcsvm(X,'classification','KernelFunction','gaussian','Standardize',true);
% partitionedmodel=crossval(model,'KFold',5);
% validationaccuracy=1-kfoldLoss(partitionedmodel,'LossFun','ClassifError');