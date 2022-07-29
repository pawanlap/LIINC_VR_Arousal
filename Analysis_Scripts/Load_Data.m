%% NiDyN Arousal Data Analysis - Load and Separate Data by Modality
% All data streams were recorded via LabStreamingLayer
% (https://github.com/sccn/labstreaminglayer).
% Once data is loaded, the script separates each data file into single
% modality file (eg. eeg, eyetracking, head movement and paradigm data).
% Each modality file contains the data stream (under _data) and time
% stream (under _time). The time stream can be used to sync data across
% modalitieis as they are recorded under the same global clock. The details
% for each data stream can be found below in their corresponding section.

%% Parameters
subject_number = 'ND1'; % Subject ID
condition = 'Low'; % Condition - Low = Easy, High = Hard
sPath = fullfile('C:\Users\pawan\Documents\NiDyN\Arousal Pilot Data - Varjo\',subject_number); % File path


%% Load Data
files = dir(sPath);
data = {};
run_counter = 0;
for file = 1:length(files)
    fn = files(file).name;
    if contains(fn,condition)
        data_file = load(fullfile(sPath,fn));
        if ~isempty(data_file)
            run_counter = run_counter + 1;
            data{run_counter} = data_file;
        end
    end
end
fprintf('Successfully loaded subject %s data %s condition with %i runs',subject_number,condition,run_counter);

%% Separate Out EEG Data
% Channel 1 = Time Counter
% Channel 2-65 = 64 EEG Channels
% Channel 66-67 = 2 ECG Channels
% Channel 68-89 = Noise
eeg_data = {};
eeg_time = {};
for i = 1:length(data)
    eeg_data{i} = data{i}.BioSemi{1};
    eeg_time{i} = data{i}.BioSemi{2};
end

%% Separate Out Gaze and Pupil Data
% Channel 1 = Left Pupil Diameter
% Channel 2 = Right Pupil Diameter
% Channel 3 = Left Gaze Direction X
% Channel 4 = Left Gaze Direction Y
% Channel 5 = Left Gaze Direction Z
% Channel 6 = Right Gaze Direction X
% Channel 7 = Right Gaze Direction Y
% Channel 8 = Right Gaze Direction Z
% Channel 9 = Left Gaze Origin X
% Channel 10 = Left Gaze Origin Y
% Channel 11 = Left Gaze Origin Z
% Channel 12 = Right Gaze Origin X
% Channel 13 = Right Gaze Origin Y
% Channel 14 = Right Gaze Origin Z
% Channel 15 = Gaze Combined Direction X
% Channel 16 = Gaze Combined Direction Y
% Channel 17 = Gaze Combined Direction Z
% Channel 18 = Gaze Combined Origin X
% Channel 19 = Gaze Combined Origin Y
% Channel 20 = Gaze Combined Origin Z
% Channel 21 = Focal Distance
% Channel 22 = Focal Stability
eye_data = {};
eye_time = {};
for i = 1:length(data)
    eye_data{i} = data{i}.Unity_VarjoEyeTracking{1};
    eye_time{i} = data{i}.Unity_VarjoEyeTracking{2};
end

%% Separate Out Unity Data
% Channel 1 = Image onset (1 = distractor, 2 = target)
% Channel 2 = Speed of vehicle in front
% Channel 3 = Speed of player's vehicle
% Channel 4 = Distance between player's vehicle and vehicle in front
% Channel 5 = Distance from to the next set of buildings
% Channel 6 = Is billboard in view?
% Channel 7 = Angle between gaze and billboard
% Channel 8 = Angle between gaze and center
unity_data = {};
unity_time = {};
for i = 1:length(data)
    unity_data{i} = data{i}.Unity_NEDE_EventMarkers{1};
    unity_time{i} = data{i}.Unity_NEDE_EventMarkers{2};
end

%% Separate Out Head Movement Data
% Channel 1 = Head Pitch
% Channel 2 = Head Yaw
% Channel 3 = Head Roll
% Channel 4 = Head Displacement X
% Channel 5 = Head Displacement Y
% Channel 6 = Head Displacement Z
% Channel 7 = Head Position X
% Channel 8 = Head Position Y
% Channel 9 = Head Position Z
head_data = {};
head_time = {};
for i = 1:length(data)
    head_data{i} = data{i}.Unity_HeadTracker{1};
    head_time{i} = data{i}.Unity_HeadTracker{2};
end

%% Save Data for Separate Analysis by Modality
% EEG
fn_EEG = sprintf('%s_%s_EEG_Raw.mat',subject_number,condition);
save(fn_EEG,'eeg_data','eeg_time')
% Eye data
fn_eye = sprintf('%s_%s_Eye_Raw.mat',subject_number,condition);
save(fn_eye,'eye_data','eye_time')
% Unity data
fn_unity = sprintf('%s_%s_Unity_Raw.mat',subject_number,condition);
save(fn_unity,'unity_data','unity_time')
% Head data
fn_head = sprintf('%s_%s_Head_Raw.mat',subject_number,condition);
save(fn_head,'head_data','head_time')
