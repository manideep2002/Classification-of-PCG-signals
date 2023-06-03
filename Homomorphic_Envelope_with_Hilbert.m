function homomorphic_envelope = Homomorphic_Envelope_with_Hilbert(input_signal, sampling_frequency,lpf_frequency,figures)

if nargin <4
    figures = 0;
end
if nargin <3
    figures = 0;
    lpf_frequency = 8;
end

%8Hz, 1st order, Butterworth LPF
[B_low,A_low] = butter(1,2*lpf_frequency/sampling_frequency,'low');
homomorphic_envelope = exp(filtfilt(B_low,A_low,log(abs(hilbert(input_signal)))));

% Remove spurious spikes in first sample:
homomorphic_envelope(1) = [homomorphic_envelope(2)];

if(figures)
    figure('Name', 'Homomorphic Envelope');
    plot(input_signal);
    hold on;
    plot(homomorphic_envelope,'r');
    legend('Original Signal','Homomorphic Envelope')
end