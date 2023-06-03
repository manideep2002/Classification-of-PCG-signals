function [normalised_signal] = normalise_signal(signal)

mean_of_signal = mean(signal);

standard_deviation = std(signal);

normalised_signal = (signal - mean_of_signal)./standard_deviation;

