function t = data_control(fid,a,b,scale,epoch,s,clock,status,param)
%% Alex Casson
% 
% Versions
% 15.06.15 - v1 - initial script
%
% Aim
% Control how data is collected
% -------------------------------------------------------------------------

%% Settings
period = 100e-3; % 4Hz is 250ms so need to update more often than this


%% Timer properties
t = timer;
t.BusyMode = 'drop';
t.ErrorFcn = @(obj,event) disp([datestr(now) ' Warning. Data update rate is low SOs may not be accurately detected.']);
t.ExecutionMode = 'FixedRate';
t.Name = 'Data control';
t.Period = period;
t.TasksToExecute = Inf;
t.TimerFcn = {@get_and_process_data,fid,a,b,scale,epoch,s,clock,status};
t.UserData = param;
