% function [despiked_signal] = schmidt_spike_removal(original_signal, fs)
%
% The spike removal process works as follows:
% (1) The recording is divided into 500 ms windows.
% (2) The maximum absolute amplitude (MAA) in each window is found.
% (3) If at least one MAA exceeds three times the median value of the MAA's,
% the following steps were carried out. If not continue to point 4.
%   (a) The window with the highest MAA was chosen.
%   (b) In the chosen window, the location of the MAA point was identified as the top of the noise spike.
%   (c) The beginning of the noise spike was defined as the last zero-crossing point before theMAA point.
%   (d) The end of the spike was defined as the first zero-crossing point after the maximum point.
%   (e) The defined noise spike was replaced by zeroes.
%   (f) Resume at step 2.
% (4) Procedure completed.
%
%% Inputs:
% original_signal: The original (1D) audio signal array
% fs: the sampling frequency (Hz)
%
%% Outputs:
% despiked_signal: the audio signal with any spikes removed.

function [despiked_signal] = schmidt_spike_removal(original_signal, fs)

%% Find the window size
% (500 ms)
windowsize = round(fs/2);

%% Find any samples outside of a integer number of windows:
trailingsamples = mod(length(original_signal), windowsize);

%% Reshape the signal into a number of windows:
sampleframes = reshape( original_signal(1:end-trailingsamples), windowsize, []);

%% Find the MAAs:
MAAs = max(abs(sampleframes));


% While there are still samples greater than 3* the median value of the
% MAAs, then remove those spikes:
while(~isempty(find((MAAs>median(MAAs)*3))))
    
    %Find the window with the max MAA:
    [val window_num] = max(MAAs);
    if(numel(window_num)>1)
        window_num = window_num(1);
    end
    
    %Find the postion of the spike within that window:
    [val spike_position] = max(abs(sampleframes(:,window_num)));
    
    if(numel(spike_position)>1)
        spike_position = spike_position(1);
    end
    
    
    % Finding zero crossings (where there may not be actual 0 values, just a change from positive to negative):
    zero_crossings = [abs(diff(sign(sampleframes(:,window_num))))>1; 0];
    
    %Find the start of the spike, finding the last zero crossing before
    %spike position. If that is empty, take the start of the window:
    spike_start = max([1 find(zero_crossings(1:spike_position),1,'last')]);
    
    %Find the end of the spike, finding the first zero crossing after
    %spike position. If that is empty, take the end of the window:
    zero_crossings(1:spike_position) = 0;
    spike_end = min([(find(zero_crossings,1,'first')) windowsize]);
    
    %Set to Zero
    sampleframes(spike_start:spike_end,window_num) = 0.0001;

    %Recaclulate MAAs
    MAAs = max(abs(sampleframes));
end

despiked_signal = reshape(sampleframes, [],1);

% Add the trailing samples back to the signal:
despiked_signal = [despiked_signal; original_signal(length(despiked_signal)+1:end)];





