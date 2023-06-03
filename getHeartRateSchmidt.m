
function [heartRate, systolicTimeInterval] = getHeartRateSchmidt(audio_data, Fs, figures)

if nargin < 3
    figures = false;
end

%% Get heatrate:
% From Schmidt:
% "The duration of the heart cycle is estimated as the time from lag zero
% to the highest peaks between 500 and 2000 ms in the resulting
% autocorrelation"
% This is performed after filtering and spike removal:

%% 25-400Hz 4th order Butterworth band pass
audio_data = butterworth_low_pass_filter(audio_data,2,400,Fs, false);
audio_data = butterworth_high_pass_filter(audio_data,2,25,Fs);

%% Spike removal from the original paper:
audio_data = schmidt_spike_removal(audio_data,Fs);

%% Find the homomorphic envelope
homomorphic_envelope = Homomorphic_Envelope_with_Hilbert(audio_data, Fs);

%% autocorrelation:
y=homomorphic_envelope-mean(homomorphic_envelope);
[c] = xcorr(y,'coeff');
signal_autocorrelation = c(length(homomorphic_envelope)+1:end);

min_index = 0.5*Fs;
max_index = 2*Fs;

[~, index] = max(signal_autocorrelation(min_index:max_index));
true_index = index+min_index-1;

heartRate = 60/(true_index/Fs);


%% Find the systolic time interval:
% From Schmidt: "The systolic duration is defined as the time from lag zero
% to the highest peak in the interval between 200 ms and half of the heart
% cycle duration"


max_sys_duration = round(((60/heartRate)*Fs)/2);
min_sys_duration = round(0.2*Fs);

[~, pos] = max(signal_autocorrelation(min_sys_duration:max_sys_duration));
systolicTimeInterval = (min_sys_duration+pos)/Fs;


if(figures)
    figure('Name', 'Heart rate calculation figure');
    plot(signal_autocorrelation);
    hold on;
    plot(true_index, signal_autocorrelation(true_index),'ro');
    plot((min_sys_duration+pos), signal_autocorrelation((min_sys_duration+pos)), 'mo');
    xlabel('Samples');
    legend('Autocorrelation', 'Position of max peak used to calculate HR', 'Position of max peak within systolic interval');
end



