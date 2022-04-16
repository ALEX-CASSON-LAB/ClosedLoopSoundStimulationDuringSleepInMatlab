function play_sound_start_function(obj,event)
%% Alex Casson
%
% Versions
% 14.10.15 - v1 - initial script
%
% Aim
% Diaply debug information when starting the sound playing process
% -------------------------------------------------------------------------

input = obj.UserData;
%disp([datestr(now,'SS.FFF') ' ' num2str(input.data_count) ' Debug. Sound timer started.']);