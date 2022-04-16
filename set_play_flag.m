function set_play_flag(s,flag)
%% Alex Casson
% 
% Versions
% 30.06.15 - v1 - initial script
%
% Aim
% Determine whether a sound is actually played when an SO is detected
% -------------------------------------------------------------------------

sparam = s.UserData;
switch flag
    case 'play'
        sparam.play_flag = 'play'; 
    case 'noplay'
        sparam.play_flag = 'noplay';
    otherwise
        error('Incorrect play flag. Not clear whether to play sound or not.');
end
s.UserData = sparam;

