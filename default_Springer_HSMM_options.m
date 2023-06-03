
function springer_options = default_Springer_HSMM_options()

%% The sampling frequency at which to extract signal features:
springer_options.audio_Fs = 1000;

%% The downsampled frequency
%Set to 50 in Springer paper
springer_options.audio_segmentation_Fs = 50;


%% Tolerance for S1 and S2 localization
springer_options.segmentation_tolerance = 0.1;%seconds

%% Whether to use the mex code or not:
% The mex code currently has a bug. This will be fixed asap.
springer_options.use_mex = true;

%% Whether to use the wavelet function or not:
springer_options.include_wavelet_feature = true;

