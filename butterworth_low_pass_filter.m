
function low_pass_filtered_signal = butterworth_low_pass_filter(original_signal,order,cutoff,sampling_frequency, figures)

if nargin < 5,
    figures = 0;
end

%Get the butterworth filter coefficients
[B_low,A_low] = butter(order,2*cutoff/sampling_frequency,'low');

if(figures)
    figure('Name','Low-pass filter frequency response');
    [sos,g] = zp2sos(B_low,A_low,1);	     % Convert to SOS form
    Hd = dfilt.df2tsos(sos,g);   % Create a dfilt object
    h = fvtool(Hd);	             % Plot magnitude response
    set(h,'Analysis','freq')	     % Display frequency response
end


%Forward-backward filter the original signal using the butterworth
%coefficients, ensuring zero phase distortion
low_pass_filtered_signal = filtfilt(B_low,A_low,original_signal);

if(figures)
    figure('Name','Original vs. low-pass filtered signal');
    plot(original_signal);
    hold on;
    plot(low_pass_filtered_signal,'r');
    legend('Original Signal', 'Low-pass filtered signal');
    pause();
end