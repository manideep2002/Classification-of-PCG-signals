function assigned_states = runSpringerSegmentationAlgorithm(audio_data, Fs, B_matrix, pi_vector, total_observation_distribution, figures)

%% Preliminary
if(nargin < 6)
    figures = false;
end

%% Get PCG Features:

[PCG_Features, featuresFs] = getSpringerPCGFeatures(audio_data, Fs);

%% Get PCG heart rate

[heartRate, systolicTimeInterval] = getHeartRateSchmidt(audio_data, Fs);

[~, ~, qt] = viterbiDecodePCG_Springer(PCG_Features, pi_vector, B_matrix, total_observation_distribution, heartRate, systolicTimeInterval, featuresFs);

assigned_states = expand_qt(qt, featuresFs, Fs, length(audio_data));

if(figures)
   figure('Name','Derived state sequence');
   t1 = (1:length(audio_data))./Fs;
   plot(t1,normalise_signal(audio_data),'k');
   hold on;
   plot(t1,assigned_states,'r--');
   legend('Audio data', 'Derived states');
end








