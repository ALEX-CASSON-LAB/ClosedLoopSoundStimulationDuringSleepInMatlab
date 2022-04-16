function [param] = state_machine(alg_in,time_vector,delay,s,clock,data_count,param,y,time)
%% Alex Casson
%
% Versions
% 16.06.15 - v1 - initial script
%
% Aim
% Run state machine that controls data collection
% -------------------------------------------------------------------------


%% Run through state machine
%disp(param.state) debug info

measured_correction_fd = 0;
measured_correction_sd = 0;
measured_correction_td = 0;

measured_correction_fd = 120e-3;
%measured_correction_sd = 20e-3;
%measured_correction_td = 24e-3;

%% Background EEG. Run detection algorithm to determine whether SO trough present
if param.state == 0
    
    % Run algorithm
    [peaks, locations] = so_detection_algorithm(alg_in,param);
    %figure(4); plot(time,alg_in); hold on; drawnow
    %figure(4); plot(time(locations),(peaks-0.05),'k^','MarkerFaceColor',[1 0 0]); drawnow; hold off
    %disp(locations)

    % Check whether any detections are made
    if isempty(locations) % no trough detected
        param.state = 0;
        return
    else
        location = locations(end);
        time_from_end = (length(alg_in) - location) / param.fs;
        peak = peaks(end);
    end
    
    % Check that this is a new detection 
    if (time_from_end < param.fd) && strcmp(s.Running,'off')
        
        %disp(num2str(data_count))
%         figure(2);
%         detect_time = time_vector(location);
%         disp([datestr(time_vector(location),'SS.FFF') ' ' num2str(data_count) ' Info. Detect time.']);
%         play_time = detect_time + (param.fd / (24 * 60 * 60)); 
%         line([detect_time detect_time], ylim,'LineWidth',2,'Color','g','LineStyle','-.');
%         line([play_time play_time], ylim,'LineWidth',1,'Color','r','LineStyle','-');
%         play_time = detect_time + (0.55 / (24 * 60 * 60)); 
%         line([play_time play_time], ylim,'LineWidth',1,'Color','r','LineStyle','-');
%         
%         figure(3);
%         detect_time = time(location);
%         play_time = detect_time + param.fd; 
%         line([detect_time detect_time], ylim,'LineWidth',2,'Color','g','LineStyle','-.');
%         line([play_time play_time], ylim,'LineWidth',1,'Color','r','LineStyle','-');
%         play_time = detect_time + 0.55; 
%         line([play_time play_time], ylim,'LineWidth',1,'Color','r','LineStyle','-');
        
        % Set sound to play if needed
        if strcmpi(param.night,'Stim') || (strcmpi(param.night,'Adapt') && strcmpi(param.an,'On'))
            set_play_flag(s,'play');
        elseif strcmpi(param.night,'Sham') || (strcmpi(param.night,'Adapt') && strcmpi(param.an,'Off'))
            set_play_flag(s,'noplay');
        else
            error('Incorrect play flag. Not clear whether to play sound or not.');
        end
        
        % Set volume
        sparam = s.UserData; sparam.vl = param.vl; s.UserData = sparam;
        
        % Set record of which data load trigged the sound call
        sparam = s.UserData; sparam.data_count = data_count; s.UserData = sparam;
        
        % Adjust start duration
        delay_duration = toc(clock) - delay;
        start_time = param.fd - time_from_end - delay_duration - measured_correction_fd;
        %[param.fd time_from_end delay_duration start_time] % debug info
        if start_time <= 0; start_time = 0; disp([datestr(now,'HH:MM:SS.FFF') ' Warning. Delay 1 may not be accurate.']); end
        s.StartDelay = start_time;
        
        %disp([datestr(now,'SS.FFF') ' ' num2str(data_count) ' Info. Sound playing process started.']);
        start(s);
        
        %figure(4); plot(time,alg_in); hold all; plot(locations/param.fs,peaks,'x')
        %figure(4); plot(time,alg_in); hold all; plot(time(end)-time_from_end,peak,'x')
        %figure(1); plot(y); drawnow
        
        % Loop
        param.state = 1; 
    else 
        param.state = 0;
    end
    
    
%% Pause before first stim
elseif param.state == 1;
    
    if strcmp(s.Running,'on')
        % Do nothing. Waiting for sound to play
        param.state = 1;
        return
    else
        param.state = 2;
    end
    
    
%% Play sound
elseif param.state == 2;
    % dummy state inherited from previous code which was switching from 1
    % to 4 clicks. Here we jsut forward to net state
    param.state = 3;
    
    % Old deprecated code
    % play_sound function is called automatically by the timer s and deals
    % with the actions for this state so just move automatically on to the
    % next. Pick which state randomly to play one or four clicks
    
%     % Generate bounded random number
%     x = round((length(param.shuffle) - 1) .* rand(1,1) + 1);
%     
%     % Pick play state
%     if param.shuffle(x) == 0 % one click
%         param.state = 4;
%         % Comment out line below to stop RemLogic marker
%         %param.h.AppActivate(param.app_name); param.h.SendKeys('f');
%         disp([datestr(now) ' Info. One click stimulation case. Sound was just played']);
%     elseif param.shuffle(x) == 1 % four click
%         param.state = 3; 
%         % Comment out line below to stop RemLogic marker
%         %param.h.AppActivate(param.app_name); param.h.SendKeys('t');
%         disp([datestr(now) ' Info. Four click stimulation case. First sound was just played. There will be three more after this message']);
%     else
%         error('Incorrect one click or four click selection.');
%     end
%     
%     % Remove choice from next play iteration to sample without replacement
%     param.shuffle(x) = [];
%     if isempty(param.shuffle)
%         param.shuffle = [1 zeros(1,param.loops)]; % note this must match the definition in stim_function.m
%     end
    
    
%% Pause before second, third and fourth stim    
elseif param.state == 3;
    
    % Check this is the first time in this state
    if strcmp(s.Running,'off')

        if strcmpi(param.night,'Stim') || (strcmpi(param.night,'Adapt') && strcmpi(param.an,'On'))
            set_play_flag(s,'play');
        elseif strcmpi(param.night,'Sham') || (strcmpi(param.night,'Adapt') && strcmpi(param.an,'Off'))
            set_play_flag(s,'noplay');
        else
            error('Incorrect play flag. Not clear whether to play sound or not.');
        end

        % Set volume
        sparam = s.UserData; sparam.vl = param.vl; s.UserData = sparam;
        
        % Set record of which data load trigged the sound call
        sparam = s.UserData; sparam.data_count = data_count; s.UserData = sparam;
        
        % Set start delay
        sparam = s.UserData; time_played = sparam.time_played; s.UserData = sparam;
        nw = toc(clock);
        delay_duration = nw - time_played;
        start_time = param.sd - delay_duration - measured_correction_sd;
        %[time_played nw delay_duration start_time] % debug info
        if start_time <= 0; start_time = 0; disp([datestr(now,'HH:MM:SS.FFF') ' Warning. Delay 2 may not be accurate.']); end
        s.StartDelay = start_time;
        start(s);
        
        % Loop or exit
        if param.counter >= param.loops
            param.state = 4;
            param.counter = 1;
        else
            param.state = 3;
            param.counter = param.counter + 1;
        end
        
    else
        % In pause so don't need to do anything
        param.state = 3;
        return
    end
    
    
%% Play sound
elseif param.state == 4;
    % Wait until sound finished playing
    if strcmp(s.Running,'off')
        set_play_flag(s,'noplay');
        
        % Set volume
        sparam = s.UserData; sparam.vl = param.vl; s.UserData = sparam;
        
        % Set record of which data load trigged the sound call
        sparam = s.UserData; sparam.data_count = data_count; s.UserData = sparam;
        
        % Set start delay
        sparam = s.UserData; time_played = sparam.time_played; s.UserData = sparam;
        nw = toc(clock);
        delay_duration = nw - time_played;
        start_time = param.td - delay_duration - measured_correction_td;
        %[time_played nw delay_duration start_time] % debug info
        if start_time <= 0; start_time = 0; disp([datestr(now,'HH:MM:SS.FFF') ' Warning. Delay 3 may not be accurate.']); end
        s.StartDelay = start_time;
        
        start(s);
        param.state = 5;
    else
        param.state = 4;
    end  

    
%% Pause for 2.5 s
elseif param.state == 5;
    % Wait until sound finished playing then loop round
    if strcmp(s.Running,'off')

        % Extract current SO
        pd = alg_in(end-size(param.plot_data,2)+1:end);
        [peaks, locations] = so_detection_algorithm(pd,param);
        [locations, ind] = sort(locations);
        peaks = peaks(ind);
        marker = locations(1);
        %plot(pd); hold on; plot(marker,peaks(1),'x','MarkerSize',10);
        
        % Align the SO detections
        align_pos = param.align * param.fs;
        shift = align_pos - marker;
        p = circshift(pd,shift);
        if shift < 0
            p(end-abs(shift)+1:end) = NaN;
        elseif shift > 0
            p(1:abs(shift)) = NaN;
        end
        m = (marker + shift)/param.fs - param.align;
        
        % Store current SO
        index = param.plot_avg(3);
        param.plot_data(index,:) = p;
        param.plot_avg(3) = mod(index,param.plot_avg(1)) + 1;
        
        % Plot current SO
        t = (0:1/param.fs:((length(p)/param.fs) - 1/param.fs)) - param.align;   
        plot(param.ax,t,p,':');
        %plot(param.ax,m/param.fs,peaks(1),'x','MarkerSize',10);
        
        % Plot average SO
        f = findobj(param.ax,'Color','r');
        if ~isempty(f)
            delete(f)
        end
        plot(param.ax,t,nanmean(param.plot_data),'r');
        
        % Plot stimulation line
        plot(param.ax,[param.fd param.fd], ylim(param.ax),'g--','LineWidth',2);
        
        % Loop
        param.state = 0;
    else
        param.state = 5;
    end  
    
    
%% Error case
else
    error('State machine in undefined state')
end

