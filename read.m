directory = 'C:\Users\bhupa\OneDrive\Documents\MATLAB\validation';

% get a list of all WAV files in the directory
fileList = dir(fullfile(directory, '*.wav'));

% iterate through each WAV file and read its contents
for i = 1:length(fileList)
    % create the full file path
    recordName= fullfile(directory, fileList(i).name);
    
    % read the audio data from the file
    [PCG, Fs1] = audioread(recordName);
    
    % do something with the audio data, such as processing or analysis
    % ...
end
challenge(recordName)