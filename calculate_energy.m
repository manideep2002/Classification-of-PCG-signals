function [energy_total,spen] =calculate_energy(audio_data)
sampling_frequency=2000;
[S,F,~] = spectrogram(audio_data,sampling_frequency/40,round(sampling_frequency/80),1:1:round(sampling_frequency/2),sampling_frequency);
P = abs(S).^2;
freq_band = [0, 1000]; % specify the frequency band of interest
idx_band = find(F>=freq_band(1) & F<=freq_band(2)); % find the indices of frequency bins within the frequency band
energy_band = sum(P(idx_band,:),1); % sum the power spectrum over the frequency band for each time frame
energy_total = sum(energy_band);
spen=spectralEntropy(audio_data,2000);
