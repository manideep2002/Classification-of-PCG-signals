

function [psd] = get_PSD_feature_Springer_HMM(data, sampling_frequency, frequency_limit_low, frequency_limit_high, figures)

if nargin < 5
    figures = 0;
end

% Find the spectrogram of the signal:
[~,F,T,P] = spectrogram(data,sampling_frequency/40,round(sampling_frequency/80),1:1:round(sampling_frequency/2),sampling_frequency);

if(figures)
    figure();
    surf(T,F,10*log(P),'edgecolor','none'); axis tight;
    view(0,90);
    xlabel('Time (Seconds)'); ylabel('Hz');
    pause();
end

[~, low_limit_position] = min(abs(F - frequency_limit_low));
[~, high_limit_position] = min(abs(F - frequency_limit_high));


% Find the mean PSD over the frequency range of interest:
psd = mean(P(low_limit_position:high_limit_position,:));


if(figures)
    t4  = (1:length(psd))./sampling_frequency;
    t3  = (1:length(data))./sampling_frequency;
    figure('Name', 'PSD Feature');
    
    plot(t3,(data - mean(data))./std(data),'c');
    hold on;
    
    plot(t4, (psd - mean(psd))./std(psd),'k');
    
    pause();
end