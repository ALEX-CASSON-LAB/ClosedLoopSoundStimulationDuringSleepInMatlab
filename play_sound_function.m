function play_sound_function(vl,sound_library,count,f_samp)
%% Alex Casson
%
% Versions
% 20.04.16 - v1 - initial script
% 
% Aim
% Script to actually call the sound function
% -------------------------------------------------------------------------
sound(vl*sound_library(:,count),f_samp)