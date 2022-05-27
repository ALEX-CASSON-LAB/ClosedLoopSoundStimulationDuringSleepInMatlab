function s = sound_control(stimulation_delay,volume,sound_library,f_samp,clock,status)
%% Alex Casson
% 
% Versions
% 15.06.15 - v1 - initial script
%
% Aim
% Control how sounds are played when triggered
% s is a timer to control the first tone, p is a timer to control the
% second tone
% -------------------------------------------------------------------------

%% Intialisation
param.count = 0;
param.data_count = 0;
param.time_played = NaN;
param.play_flag = 'noplay';
param.marker_flag = 'marker';
param.vl = volume;


%% Timer settings
s = timer;
s.BusyMode = 'drop';
s.ErrorFcn = @(obj,event) disp([datestr(now) ' Warning. Sound may not have been played at correct time.']);
s.ExecutionMode = 'SingleShot';
s.Name = 'Sound control';
s.StartDelay = stimulation_delay;
s.StartFcn = @play_sound_start_function;
s.TasksToExecute = 1;
s.TimerFcn = {@play_sound,sound_library,f_samp,clock,status};
s.UserData = param;