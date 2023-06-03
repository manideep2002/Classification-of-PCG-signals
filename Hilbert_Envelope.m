function hilbert_envelope = Hilbert_Envelope(input_signal, sampling_frequency,figures)

if nargin <3,
    figures = 0;
end


hilbert_envelope = abs(hilbert(input_signal)); %find the envelope of the signal using the Hilbert transform

if(figures)
    figure('Name', 'Hilbert Envelope');
    plot(input_signal');
    hold on;
    plot(hilbert_envelope,'r');
    legend('Original Signal','Hilbert Envelope');
    pause();
end