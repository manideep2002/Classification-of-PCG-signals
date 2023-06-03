function spectralEntropy=spectral_entropy(pcg)
window = hamming(length(pcg));
windowedSignal = pcg .* window;
powerSpectrum = abs(fft(windowedSignal)).^2;
pdf = powerSpectrum / sum(powerSpectrum);
spectralEntropy = -sum(pdf .* log2(pdf));
end