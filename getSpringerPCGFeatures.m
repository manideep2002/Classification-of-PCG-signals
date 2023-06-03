function [PCG_Features, featuresFs] = getSpringerPCGFeatures(audio_data, Fs, figures)
% function PCG_Features = getSpringerPCGFeatures(audio, Fs)
% Get the features used in the Springer segmentation algorithm.


if(nargin < 3)
    figures = false;
end

springer_options = default_Springer_HSMM_options;


% Check to see if the Wavelet toolbox is available on the machine:
include_wavelet = springer_options.include_wavelet_feature;
featuresFs = springer_options.audio_segmentation_Fs; % Downsampled feature sampling frequency

%% 25-400Hz 4th order Butterworth band pass
audio_data = butterworth_low_pass_filter(audio_data,2,400,Fs, false);
audio_data = butterworth_high_pass_filter(audio_data,2,25,Fs);

%% Spike removal from the original paper:
audio_data = schmidt_spike_removal(audio_data,Fs);



%% Find the homomorphic envelope
homomorphic_envelope = Homomorphic_Envelope_with_Hilbert(audio_data, Fs);
% Downsample the envelope:
downsampled_homomorphic_envelope = resample(homomorphic_envelope,featuresFs, Fs);
% normalise the envelope:
downsampled_homomorphic_envelope = normalise_signal(downsampled_homomorphic_envelope);


%% Hilbert Envelope
hilbert_envelope = Hilbert_Envelope(audio_data, Fs);
downsampled_hilbert_envelope = resample(hilbert_envelope, featuresFs, Fs);
downsampled_hilbert_envelope = normalise_signal(downsampled_hilbert_envelope);

%% Power spectral density feature:

psd = get_PSD_feature_Springer_HMM(audio_data, Fs, 40,60)';
psd = resample(psd, length(downsampled_homomorphic_envelope), length(psd));
psd = normalise_signal(psd);

%% Wavelet features:

if(include_wavelet)
    wavelet_level = 3;
    wavelet_name ='rbio3.9';
    
    % Audio needs to be longer than 1 second for getDWT to work:
    if(length(audio_data)< Fs*1.025)
        audio_data = [audio_data; zeros(round(0.025*Fs),1)];
    end
    
    [cD, cA] = getDWT(audio_data,wavelet_level,wavelet_name);
    
    wavelet_feature = abs(cD(wavelet_level,:));
    wavelet_feature = wavelet_feature(1:length(homomorphic_envelope));
    downsampled_wavelet = resample(wavelet_feature, featuresFs, Fs);
    downsampled_wavelet =  normalise_signal(downsampled_wavelet)';
end

%%

if(include_wavelet)
    PCG_Features = [downsampled_homomorphic_envelope, downsampled_hilbert_envelope, psd, downsampled_wavelet];
else
    PCG_Features = [downsampled_homomorphic_envelope, downsampled_hilbert_envelope, psd];
end

%% Plotting figures
if(figures)
    figure('Name', 'PCG features');
    t1 = (1:length(audio_data))./Fs;
    plot(t1,audio_data);
    hold on;
    t2 = (1:length(PCG_Features))./featuresFs;
    plot(t2,PCG_Features);
    pause();
end