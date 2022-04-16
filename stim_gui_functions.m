function handles = stim_gui_functions(hObject,handles)
%% Alex Casson
%
% Versions
% 18.06.15 - v1 - initial script
%
% Aim
% Setup the stimulation night GUI
% -------------------------------------------------------------------------

%% Initalisation

% Set volume to max
vol_max = 65535; vol_min = 0;
system(['.\nircmd setsysvolume ' num2str(vol_max)]);


%% Set default values

% User controllable
handles.param.ac = 'X1';
handles.param.rc = 'M1';
handles.param.fs = 200;
handles.param.dt = -80;
handles.param.fd = 0.55;
handles.param.sd = 1.075;
handles.param.vl = 1; % note values are stored as magnitudes, displayed as dB

% Non-user controllable
handles.param.td = 10.;
handles.param.state = 0; % start with the algorithm running
handles.param.night = 'Sham';
handles.param.an    = 'Off';
handles.param.ax    = handles.axes1;
handles.param.plot_data = NaN;
handles.param.align = 0.5;
buffer = 1;
handles.param.plot_avg  = [100, handles.param.fd+handles.param.sd+handles.param.td+buffer, 1]; % [number of averages to use, number of seconds to plot + 1, internal counter]
handles.param.sp = 'Off';
handles.param.loops = 9; % loops + 1 tones are played in the state 6 case
handles.param.counter = 1; % internal counter
handles.param.shuffle = [1 zeros(1,handles.param.loops)]; % 1=looped clicks, 0=single click
handles.param.h = actxserver('WScript.Shell');
handles.param.app_name = ('RemLogic');


% Update
guidata(hObject,handles);


%% Set up the timers
t = stim_main(handles.param);
handles.timer = t;
guidata(hObject,handles);


%% Window control
set(hObject,'Name','NaPS lab closed loop stimulator');
set(hObject,'Toolbar','figure');

% Remove toolbar buttons
a = findall(hObject);
b = findall(a,'ToolTipString','New Figure'); set(b,'Visible','Off');
b = findall(a,'ToolTipString','Open File'); set(b,'Visible','Off');
b = findall(a,'ToolTipString','Save Figure'); set(b,'Visible','Off');
b = findall(a,'ToolTipString','Print Figure'); set(b,'Visible','Off');
b = findall(a,'ToolTipString','Link Plot'); set(b,'Visible','Off');
b = findall(a,'ToolTipString','Insert Colorbar'); set(b,'Visible','Off');
b = findall(a,'ToolTipString','Insert Legend'); set(b,'Visible','Off');


% Make note of GUI size
top = 610;


%% Night
nt_options = {'Sham','Stim','Adapt'};
position = [20 top-20 100 50];
nt_txt   = uicontrol('Style','text','Position',position,'String','Night','HorizontalAlignment','Right');
position = [position(1)+position(3)+5 position(2)+3 100 50];
[v, default] = max(strcmp(handles.param.night,nt_options));
nt_popup = uicontrol('Style','popup','String',nt_options,'Position',position,'Value',default,'Callback',@nt_Callback); 
    function nt_Callback(source,eventdata) 
        val = get(source,'Value');
        nt = nt_options{val};
        h = guidata(gcbo);
        h.param.night = nt;
        guidata(gcbo,h)
        
        % Turn adpat night sound on and off
        if strcmpi(nt,'Adapt')
            set(an_txt,'Visible','On');
            set(an_check,'Visible','On');
        else
            set(an_txt,'Visible','Off');
            set(an_check,'Visible','Off');
        end
    end


%% Active channel
ac_options = {'X1'};
position = [20 top-70 100 50];
ac_txt   = uicontrol('Style','text','Position',position,'String','Channel','HorizontalAlignment','Right');
position = [position(1)+position(3)+5 position(2)+3 100 50];
[v, default] = max(strcmp(handles.param.ac,ac_options));
ac_popup = uicontrol('Style','popup','String',ac_options,'Position',position,'Value',default,'Callback',@ac_Callback); 
    function ac_Callback(source,eventdata) 
        val = get(source,'Value');
        ac = ac_options{val};
        h = guidata(gcbo);
        h.param.ac = ac;
        guidata(gcbo,h)
    end


%% Reference channel
rc_options = {'M1'};
position = [20 top-120 100 50];
rc_txt   = uicontrol('Style','text','Position',position,'String','Reference','HorizontalAlignment','right');
position = [position(1)+position(3)+5 position(2)+3 100 50];
[v, default] = max(strcmp(handles.param.rc,rc_options));
rc_popup = uicontrol('Style','popup','String',rc_options,'Position',position,'Value',default,'Callback',@rc_Callback); 
    function rc_Callback(source,eventdata) 
        val = get(source,'Value');
        rc = rc_options{val};
        h = guidata(gcbo);
        h.param.rc = rc;
        guidata(gcbo,h)
    end


%% Sampling frequency
fs_options = {'200'};
position = [20 top-170 100 50];
fs_txt   = uicontrol('Style','text','Position',position,'String','Sampling frequency','HorizontalAlignment','right');
position = [position(1)+position(3)+5 position(2)+3 100 50];
[v, default] = max(strcmp(handles.param.fs,fs_options));
fs_popup = uicontrol('Style','popup','String',fs_options,'Position',position,'Value',default,'Callback',@fs_Callback); 
position = [position(1)+position(3)+5 position(2)-3 100 50];
fs_txt   = uicontrol('Style','text','Position',position,'String','Hz','HorizontalAlignment','left');
    function fs_Callback(source,eventdata) 
        val = get(source,'Value');
        fs = str2double((fs_options(val)));
        h = guidata(gcbo);
        h.param.fs = fs;
        guidata(gcbo,h)
    end


%% Adpat night sound
position = [260 top-20 100 50];
an_txt   = uicontrol('Style','text','Position',position,'String','Adapt night sounds','HorizontalAlignment','Right','Visible','Off');
position = [position(1)+position(3)+5 position(2)+29 100 25];
an_check = uicontrol('Style','checkbox','Position',position,'Value',0,'Callback',@an_Callback,'Visible','Off');
    function an_Callback(source,eventdata) 
        val = get(source,'Value');
        if val == 0
            an = 'Off';
        else
            an = 'On';
        end
        h = guidata(gcbo);
        h.param.an = an;
        guidata(gcbo,h)
    end


%% Detection threshold
position = [260 top-70 100 50];
dt_txt   = uicontrol('Style','text','Position',position,'String','Detection threshold','HorizontalAlignment','right');
position = [position(1)+position(3)+5 position(2)+29 100 25];
dt_edit  = uicontrol('Style','edit','String',num2str(handles.param.dt),'Position',position,'Callback',@dt_Callback); 
position = [position(1)+position(3)+5 position(2)-29 100 50];
dt_txt   = uicontrol('Style','text','Position',position,'String','uV','HorizontalAlignment','left');
    function dt_Callback(source,eventdata) 
        val = get(source,'String');
        dt = str2double(val);
        if isnan(dt); dt = -80; warndlg('Non-numeric value entered. Value displayed may not be accurate. Please re-enter.','Detection threshold'); end;
        h = guidata(gcbo);
        h.param.dt = dt;
        guidata(gcbo,h)
    end


%% First delay
position = [260 top-120 100 50];
fd_txt   = uicontrol('Style','text','Position',position,'String','First delay','HorizontalAlignment','right');
position = [position(1)+position(3)+5 position(2)+29 100 25];
fd_edit  = uicontrol('Style','edit','String',num2str(handles.param.fd),'Position',position,'Callback',@fd_Callback); 
position = [position(1)+position(3)+5 position(2)-29 100 50];
fd_txt   = uicontrol('Style','text','Position',position,'String','s','HorizontalAlignment','left');
    function fd_Callback(source,eventdata) 
        val = get(source,'String');
        fd = str2double(val);
        if isnan(fd); fd = 0.55; warndlg('Non-numeric value entered. Value displayed may not be accurate. Please re-enter.','First delay'); end;
        h = guidata(gcbo);
        h.param.fd = fd;
        h.param.plot_avg(2)  = h.param.fd+h.param.sd+h.param.td+buffer;
        guidata(gcbo,h)
    end


%% Second delay
position = [260 top-170 100 50];
sd_txt   = uicontrol('Style','text','Position',position,'String','Second delay','HorizontalAlignment','right');
position = [position(1)+position(3)+5 position(2)+29 100 25];
sd_edit  = uicontrol('Style','edit','String',num2str(handles.param.sd),'Position',position,'Callback',@sd_Callback); 
position = [position(1)+position(3)+5 position(2)-29 100 50];
sd_txt   = uicontrol('Style','text','Position',position,'String','s','HorizontalAlignment','left');
    function sd_Callback(source,eventdata) 
        val = get(source,'String');
        sd = str2double(val);
        if isnan(sd); sd = 1.075; warndlg('Non-numeric value entered. Value displayed may not be accurate. Please re-enter.','Second delay'); end;
        h = guidata(gcbo);
        h.param.sd = sd;
        h.param.plot_avg(2)  = h.param.fd+h.param.sd+h.param.td+buffer;
        guidata(gcbo,h)
    end


%% Save plot
position = [260 top-220 100 25];
sp_txt   = uicontrol('Style','text','Position',position,'String','Save plot data','HorizontalAlignment','Right');
position = [position(1)+position(3)+5 position(2)+30-25 100 25];
sp_check = uicontrol('Style','checkbox','Position',position,'Value',0,'Callback',@sp_Callback);
    function sp_Callback(source,eventdata) 
        val = get(source,'Value');
        if val == 0
            sp = 'Off';
        else
            sp = 'On';
        end
        h = guidata(gcbo);
        h.param.sp = sp;
        guidata(gcbo,h)
    end


%% Volume slider
vol_step = [0.01 0.03]; % 1% (1dB) minor change, 3% (3dB) major change

position = [20 top-220 100 50];
vol_txt   = uicontrol('Style','text','Position',position,'String','Volume','HorizontalAlignment','right');
position = [position(1)+position(3)+5 position(2)+33 340 20];
vol_slide = uicontrol('Style','slider','Min',-100,'Max',0,'Value',mag2db_alex(handles.param.vl),'SliderStep',vol_step,'Position',position,'Callback',@vol_Callback);
position = [position(1)+position(3)+5 position(2)-33 100 50];
vol_out   = uicontrol('Style','text','Position',position,'String',[num2str(mag2db_alex(handles.param.vl)) ' dB'],'HorizontalAlignment','left');    
    function vol_Callback(source,eventdata)
        vl = get(source,'Value');
        set(vol_out,'String',[num2str(vl) ' dB']);
        disp([datestr(now) ' Info. Volume changed. Now: ' num2str(vl) ' dB']);
        h = guidata(gcbo);
        h.param.vl = db2mag_alex(vl);
        guidata(gcbo,h)
    end


%% Format axes
grid(handles.param.ax,'on');
xlabel(handles.param.ax,'Time / s');
ylabel(handles.param.ax,'SO / \muV')


%% Start button
play_icon = imread('play_button.png');
position = [10 20 100 50];
play_button = uicontrol('Style','pushbutton','Position',position,'String','Start','FontSize',14,'FontWeight','Bold','cdata',play_icon,'Callback',@start_Callback);
    function start_Callback(source,eventdata)
            h = guidata(gcbo);
            
            % Set up functions - could be moved to timer start function
            h.param.state = 0;
            h.param.plot_data = nan(h.param.plot_avg(1),h.param.plot_avg(2)*h.param.fs);
            h.param.plot_avg(3) = 1;
            h.timer.UserData = h.param;
            cla(h.param.ax,'reset');
            hold(h.param.ax,'on');
            grid(h.param.ax,'on');
            xlabel(h.param.ax,'Time / s');
            ylabel(h.param.ax,'SO / \muV');
            
            % Start timer
            start(h.timer);
            disp([datestr(now) ' Info. Algorithm started.']);
            
            % Prevent GUI changes while running
            set(nt_popup,'Enable','Off');
            set(ac_popup,'Enable','Off');
            set(rc_popup,'Enable','Off');
            set(fs_popup,'Enable','Off');
            set(an_check,'Enable','Off');
            set(dt_edit,'Enable','Off');
            set(fd_edit,'Enable','Off');
            set(sd_edit,'Enable','Off');
            set(vol_slide,'Enable','Off');
            set(play_button,'Enable','Off');
            guidata(gcbo,h)
    end


%% Stop button
stop_icon = imread('stop_button.png');
position = [120 20 100 50];
stop_button = uicontrol('Style','pushbutton','Position',position,'String','Stop','FontSize',14,'FontWeight','Bold','cdata',stop_icon,'Callback',@stop_Callback);
    function stop_Callback(source,eventdata)
            h = guidata(gcbo);
            stop(h.timer);
            disp([datestr(now) ' Info. Algorithm stopped.']);

            % Save plot data
            if strcmp(h.param.sp,'On')
                
                % Select variables to save
                d = h.timer.UserData;
                plot_data = d.plot_data;
                
                % Save variables
                [filename, pathname] = uiputfile('average_so.mat','Save plot data file');
                if isequal(filename,0) || isequal(pathname,0)
                    % User selected Cancel, do nothing
                else
                    save(fullfile(pathname,filename),'plot_data');
                end
            end
            
            % Enable GUI changes while running
            set(nt_popup,'Enable','On');
            set(ac_popup,'Enable','On');
            set(rc_popup,'Enable','On');
            set(fs_popup,'Enable','On');
            set(an_check,'Enable','On');
            set(dt_edit,'Enable','On');
            set(fd_edit,'Enable','On');
            set(sd_edit,'Enable','On');
            set(vol_slide,'Enable','On');
            set(play_button,'Enable','On');
            guidata(gcbo,h)
    end


%% Save variables
position = [230 20 100 50];
save_button = uicontrol('Style','pushbutton','Position',position,'String','Save','FontWeight','Bold','Callback',@save_Callback);
    function save_Callback(source,eventdata)
        h = guidata(gcbo);
        
        % Select variables to save
        variables.ac = h.param.ac;
        variables.rc = h.param.rc;
        variables.fs = h.param.fs;
        variables.dt = h.param.dt;
        variables.fd = h.param.fd;
        variables.sd = h.param.sd;
        variables.vl = h.param.vl;
        
        % Save variables
        [filename, pathname] = uiputfile('stim_settings.mat','Save settings file');
        if isequal(filename,0) || isequal(pathname,0)
            % User selected Cancel, do nothing
        else
            save(fullfile(pathname,filename),'variables');
        end
    end


%% Load variables
position = [340 20 100 50];
load_button = uicontrol('Style','pushbutton','Position',position,'String','Load','FontWeight','Bold','Callback',@load_Callback);
    function load_Callback(source,eventdata)
        h = guidata(gcbo);
        
        [filename, pathname] = uigetfile('*.mat','Select settings file');
        if isequal(filename,0)
            % User selected Cancel, do nothing
        else
            % Load the 7 user settable values
            load(fullfile(pathname,filename),'variables');
            h.param.ac = variables.ac;
            h.param.rc = variables.rc;
            h.param.fs = variables.fs;
            h.param.dt = variables.dt;
            h.param.fd = variables.fd;
            h.param.sd = variables.sd;
            h.param.vl = variables.vl;
            guidata(gcbo,h);
            
            % Force GUI update
            [w, value] = max(strcmp(h.param.ac,ac_options)); set(ac_popup,'Value',value);
            [w, value] = max(strcmp(h.param.rc,rc_options)); set(rc_popup,'Value',value);
            [w, value] = max(strcmp(num2str(variables.fs),fs_options)); set(fs_popup,'Value',value);     
            set(dt_edit,'String',num2str(h.param.dt));
            set(fd_edit,'String',num2str(h.param.fd));
            set(sd_edit,'String',num2str(h.param.sd));
            set(vol_slide,'Value',mag2db_alex(h.param.vl)); set(vol_out,'String',[num2str(mag2db_alex(h.param.vl)) ' dB']);
            
        end
    end


%% Check variables
position = [450 20 100 50];
stop_button = uicontrol('Style','pushbutton','Position',position,'String','Check variables','FontWeight','Bold','Callback',@check_Callback);
    function check_Callback(source,eventdata)
        h = guidata(gcbo);
        disp(h.param)
    end


end