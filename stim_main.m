function t = stim_main(param,sound_library,f_samp)
%% Alex Casson
% 
% Versions
% 22.12.14 - v1 - initial script
%
% Aim
% Matlab script to load .ebm files in real-time
%
% Notes
% Assumes Matlab 2007a without the signal processing toolbox.
% (For online) assumess computer has cogent2000 config_io function installed for Embla triggers
% To play a sound in the offline mode the delay needs to be set to 900ms or longer
% -------------------------------------------------------------------------


%% Internal settings
status = 'online'; % 'offline' for testing or 'online' for use
epoch   = 30;  % seconds


%% Set up data source
channel{1} = param.ac;
channel{2} = param.rc;
channel{3} = param.rc2;
[filename, begin, scale, fid] = get_data_source(status,channel);


%% Make 0.25 - 4 Hz filter for isolating SOs
% Gererateded using >> fl = 0.25; fh = 4; n  = 2; f_samp = 200; [b,a] = butter(2,[fl fh]./(f_samp/2),'bandpass'); save('butterworth_coefficients.mat','b','a');
load('butterworth_coefficients.mat');


%% Make timer to trigger stimulation
clock = tic;
s = sound_control(param.fd,param.vl,sound_library,f_samp,clock,status);


%% Make timer to access data periodically
t = data_control(fid,a,b,scale,epoch,s,clock,status,param);

