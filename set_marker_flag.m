function set_marker_flag(s,flag)
%% Alex Casson
% 
% Versions
% 20.04.116 - v1 - initial script
%
% Aim
% Determine whether a marker is sent to Remlogic when an SO is detected
% -------------------------------------------------------------------------

sparam = s.UserData;
switch flag
    case 'marker'
        sparam.marker_flag = 'marker'; 
    case 'nomarker'
        sparam.marker_flag = 'nomarker';
    otherwise
        error('Incorrect marker flag. Not clear whether send Remlogic marker or not.');
end
s.UserData = sparam;