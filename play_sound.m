function play_sound(obj,event,sound_library,f_samp,clock,status)
%% Alex Casson
%
% Versions
% 29.01.15 - v1 - initial script
%
% Aim
% Play output sound and record time
% -------------------------------------------------------------------------

%% Get object inputs/outputs
input = obj.UserData;
count = input.count;
time_played = input.time_played;
play_flag = input.play_flag;
marker_flag = input.marker_flag;
vl = input.vl;


%% Do sound generation
if strcmp(play_flag,'play')
    count = count + 1;
    
    % Play sound
    if strcmp(status,'online'); 
        %disp([datestr(now,'SS.FFF') ' ' num2str(input.data_count) ' Info. Sound played. Number: ' num2str(count)]); % debug info
        %figure(2); line([datenum(now) datenum(now)], ylim,'LineWidth',2,'Color','k','LineStyle','-.')
        if strcmp(marker_flag,'marker')
            outp(888,1); play_sound_function(vl,sound_library,count,f_samp); outp(888,0);
        elseif strcmp(marker_flag,'nomarker')
            play_sound_function(vl,sound_library,count,f_samp);
        else
            error('Incorrect marker flag. Not clear whether send Remlogic marker or not.');
        end
        time_played = toc(clock);
        disp([datestr(now,'dd-mmm-yyyy HH:MM:SS.FFF') ' Info. Sound played. Number: ' num2str(count)]); % debug info
        %figure(2); line([datenum(now) datenum(now)], ylim,'LineWidth',2,'Color','k','LineStyle','-.')
        %time_start = mod(str2double(datestr(now,'SS.FFF')),30); % note epoch length hard coded here
        %figure(3); line([time_start time_start], ylim,'LineWidth',2,'Color','k','LineStyle','-.')
        

        
    elseif strcmp(status,'offline'); 
        play_sound_function(vl,sound_library,count,f_samp);
        time_played = toc(clock);
        %disp([datestr(now,'SS.FFF') ' ' num2str(input.data_count) ' Info. Sound played.']); % debug info
    else
        error('Incorrect status flag. Not clear whether online or offline');
    end
else
    % Play empty sound - helps ensure consistent timing
    if strcmp(status,'online');
        c = size(sound_library,2);
        if strcmp(marker_flag,'marker')
            outp(888,1); play_sound_function(vl,sound_library,c,f_samp); outp(888,0);
        elseif strcmp(marker_flag,'nomarker')
            play_sound_function(vl,sound_library,c,f_samp);
        else
            error('Incorrect marker flag. Not clear whether send Remlogic marker or not.');
        end
        time_played = toc(clock);
        %disp([datestr(now) ' Info. No sound played, timing info only.']); % debug info
        %figure(2); line([datenum(now) datenum(now)], ylim,'LineWidth',2,'Color','k','LineStyle','-.')
        %time_start = mod(str2double(datestr(now,'SS.FFF')),30); % note epoch length hard coded here
        %figure(3); line([time_start time_start], ylim,'LineWidth',2,'Color','k','LineStyle','-.')
    elseif strcmp(status,'offline'); 
        play_sound_function(vl,sound_library,c,f_samp);
        time_played = toc(clock);
        %disp([datestr(now,'SS.FFF') ' ' num2str(input.data_count) ' Info. No sound played, timing info only.']); % debug info
    else
        error('Incorrect status flag. Not clear whether online or offline');
    end  
end



%% Set object inputs/outputs
output.count = count;
output.time_played = time_played;
output.play_flag = play_flag;
output.marker_flag = marker_flag;
output.vl = vl;
obj.UserData = output;
