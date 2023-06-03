
function high_pass_filtered_signal = butterworth_high_pass_filter(original_signal,order,cutoff,sampling_frequency, figures)

if nargin < 5,
    figures = 0;
end

%Get the butterworth filter coefficients
[B_high,A_high] = butter(order,2*cutoff/sampling_frequency,'high');

%Forward-backward filter the original signal using the butterworth
%coefficients, ensuring zero phase distortion
high_pass_filtered_signal = filtfilt(B_high,A_high,original_signal);

if(figures)
    
    figure('Name','High-pass filter frequency response');
    [sos,g] = zp2sos(B_high,A_high,1);	     % Convert to SOS form
    Hd = dfilt.df2tsos(sos,g);   % Create a dfilt object
    h = fvtool(Hd);	             % Plot magnitude response
    set(h,'Analysis','freq')	     % Display frequency response
    
    figure('Name','Original vs. high-pass filtered signal');
    plot(original_signal);
    hold on;
    plot(high_pass_filtered_signal,'r');
    legend('Original Signal', 'High-pass filtered signal');
    pause();
end

