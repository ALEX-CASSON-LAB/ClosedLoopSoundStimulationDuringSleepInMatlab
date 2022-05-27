function [filename, begin, scale, fid] = get_data_source(status,channel)
%% Alex Casson
% 
% Versions
% 15.06.15 - v1 - initial script
%
% Aim
% Set up Matlab to load data from an online or offline .ebm file
% -------------------------------------------------------------------------

%% Set data source for online vs offline

% If online, probe the Remlogic results folder to see the currently active
% recording
if strcmp(status,'online'); 
    basedir = 'C:\RemLogic Recordings';
    ls = dir(basedir); ls(1) = []; ls(2) = [];
    [na,idx] = sort([ls.datenum]);
    folder = ls(idx(end)).name;
    filename{1} = [basedir '\' folder '\' channel{1} '.ebm'];
    filename{2} = [basedir '\' folder '\' channel{2} '.ebm'];
    filename{3} = [basedir '\' folder '\' channel{3} '.ebm'];
    
    config_io; % set up the Embla triggers
    outp(888,0);
    
% If offline, load the pre-saved data
elseif strcmp(status,'offline'); 
    filename{1} = '..\example_offline_data\C4.ebm';
    filename{2} = '..\example_offline_data\M1.ebm';
    filename{3} = '..\example_offline_data\M2.ebm';

% Error check
else
    error('Incorrect status flag. Not clear whether online or offline');
end    


%% Determine calibration required from header
header = ebm_header(filename{1});
begin  = header.header_end;
scale  = header.Cal * 1e6; % Embla stores in V so convert to muV for plot


%% Open file for processing
fid(1) = fopen(filename{1},'rb');
fid(2) = fopen(filename{2},'rb');
fid(3) = fopen(filename{3},'rb');