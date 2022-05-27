function varargout = stim_gui(varargin)
%% Alex Casson
%
% Versions
% 22.06.15 - v1 - initial script
% 
% Aim
% Launch the stim GUI
% -------------------------------------------------------------------------

%% Initalise Matlab
close all
%clearvars -except varargin % not avaiable in Matlab 2007b
T = timerfind;
if ~isempty(T), stop(T); delete(T); end
warning('off','MATLAB:TIMER:STARTDELAYPRECISION');
warning('off','MATLAB:timer:deleterunning')
%rand('state',sum(100.*clock)); % fully random
rand('state',2.100768e5); % same on each go

%% Check RemLogic is set up this. 
start_up_check = questdlg('Has RemLogic been started and is streaming data?','Start up check','Yes','No','Yes');
switch start_up_check
    case 'No'
        warndlg('Please start RemLogic and start streaming data. Then re-run this script.','Start up check')
        return
    case 'Yes'
        % Do nothing. Contine on to rest of code
end


%% Initalise the GUI
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stim_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @stim_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


%% Populate the GUI. This is done in stim_gui_functions
function stim_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles = stim_gui_functions(hObject,handles);
guidata(hObject, handles);


%% Output functions when exit.
function varargout = stim_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
%T = timerfind;
%if ~isempty(T), stop(T); delete(T); end
