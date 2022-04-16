function get_and_process_data(obj,event,fid,a,b,scale,epoch,s,clock,status)
%% Alex Casson
%
% Versions
% 23.12.14 - v1 - initial script
%
% Aim
% Run the slow wave detection algorithm at a fixed rate
% -------------------------------------------------------------------------

%% Inputs
param = obj.UserData;
data_count = obj.TasksExecuted;


%% Load data
delay = toc(clock);
%disp([datestr(now,'SS.FFF') ' ' num2str(data_count) ' Debug. Data loaded.']);

% Embla reserves memory in chunks, 131072 samples big. This is filled
% with zeros until actual EEG data is written to it. Load just ~the last 2
% chunks of data. Also, files aren't always the same size so need to use
% the smaller one to set how much data to load
fseek(fid(1),0,'eof'); fseek(fid(2),0,'eof');
si = ftell(fid(1)); sj = ftell(fid(2)); sk = min(si,sj);
if sk>2^18
    sk=2^18;  
    if strcmp(status,'online')
        fsk = -(1.5*sk)+1; 
    elseif strcmp(status,'offline')
        fsk = -(sk); 
    else error('Incorrect status flag. Not clear whether online or offline')
    end
else
    fsk = -(sk)+1;
end
s1 = fseek(fid(1),fsk,'eof'); % seek value must be even to read the file correctly online, odd to read file offline
s2 = fseek(fid(2),fsk,'eof');
%[ferror(fid(1)) ferror(fid(2))] % debug info

% Load data
inn = fread(fid(1),'int16');
ref = fread(fid(2),'int16');
y = scale * (inn - ref);
%figure(1); plot(y); drawnow

% Find the end of the actual data/where the zero padding starts
z = flipud(y);
z = cumsum(abs(z));
i = find(z>0);
i = length(z)-i(1);
data = y(i-(epoch*param.fs)+1:i);


% Calculate current timebase
plot_epoch = epoch / (24 * 60 * 60); % assumes epoch in seconds
interval = (1/param.fs) / (24 * 60 * 60);
end_time = datenum(now);
start_time = end_time - plot_epoch + interval;
time_vector = start_time:interval:end_time;
%time = 0:1/param.fs:(length(data)/param.fs - 1/param.fs); % not used anymore
time_start = str2double(datestr(now,'SS.FFF'));
time = mod(time_start:1/param.fs:time_start+epoch-(1/param.fs),epoch);


%% Filtering for SO

% Do filtering
data_padded   = [data; flipud(data)]; % remove edge effect - isn't necessary, can remove
alg_in_padded = filter(b,a,data_padded);
alg_in = alg_in_padded(1:length(data));


%% Plot data
% scrolling_data_plot(2,time_vector,data,alg_in,1,epoch);
% datetick('x','keeplimits'); axis([start_time end_time -500 500]);
% scrolling_data_plot(3,time,data,alg_in,0,epoch);
% axis([0 epoch -500 500]);


%% Run detection and sound algorithm
[param] = state_machine(alg_in,time_vector,delay,s,clock,data_count,param,y,time);


%% Outputs
obj.UserData = param;


%% Timing / debug print
%[toc(clock) state]
