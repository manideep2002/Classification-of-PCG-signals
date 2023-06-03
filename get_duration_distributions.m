function [d_distributions, max_S1, min_S1, max_S2, min_S2, max_systole, min_systole, max_diastole, min_diastole] = get_duration_distributions(heartrate,systolic_time)

springer_options = default_Springer_HSMM_options;



mean_S1 = round(0.122*springer_options.audio_segmentation_Fs);
std_S1 = round(0.022*springer_options.audio_segmentation_Fs);
mean_S2 = round(0.094*springer_options.audio_segmentation_Fs);
std_S2 = round(0.022*springer_options.audio_segmentation_Fs);


mean_systole = round(systolic_time*springer_options.audio_segmentation_Fs) - mean_S1;
std_systole = (25/1000)*springer_options.audio_segmentation_Fs;


mean_diastole = ((60/heartrate) - systolic_time - 0.094)*springer_options.audio_segmentation_Fs;
std_diastole = 0.07*mean_diastole + (6/1000)*springer_options.audio_segmentation_Fs;



%% Cell array for the mean and covariance of the duration distributions:
d_distributions = cell(4,2);

%% Assign mean and covariance values to d_distributions:
d_distributions{1,1} = mean_S1;
d_distributions{1,2} = (std_S1)^2;

d_distributions{2,1} = mean_systole;
d_distributions{2,2} = (std_systole)^2;

d_distributions{3,1} = mean_S2;
d_distributions{3,2} = (std_S2)^2;

d_distributions{4,1} = mean_diastole;
d_distributions{4,2} = (std_diastole)^2;


%Min systole and diastole times
min_systole = mean_systole - 3*(std_systole+std_S1);
max_systole = mean_systole + 3*(std_systole+std_S1);

min_diastole = mean_diastole-3*std_diastole;
max_diastole = mean_diastole + 3*std_diastole;



%Setting the Min and Max values for the S1 and S2 sounds:
%If the minimum lengths are less than a 50th of the sampling frequency, set
%to a 50th of the sampling frequency:
min_S1 = (mean_S1 - 3*(std_S1));
if(min_S1<(springer_options.audio_segmentation_Fs/50))
    min_S1 = (springer_options.audio_segmentation_Fs/50);
end

min_S2 = (mean_S2 - 3*(std_S2));
if(min_S2<(springer_options.audio_segmentation_Fs/50))
    min_S2 = (springer_options.audio_segmentation_Fs/50);
end
max_S1 = (mean_S1 + 3*(std_S1));
max_S2 = (mean_S2 + 3*(std_S2));



