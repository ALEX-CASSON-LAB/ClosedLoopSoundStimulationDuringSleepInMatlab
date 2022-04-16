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
vl = input.vl;


%% Do sound generation
if strcmp(play_flag,'play')
    % Play sound
    if strcmp(status,'online'); 
        outp(888,1); sound(vl*sound_library(:,count+1),f_samp); outp(888,0);
        time_played = toc(clock);
        disp([datestr(now,'SS.FFF') ' ' num2str(input.data_count) ' Info. Sound played.']); % debug info
        %figure(2); line([datenum(now) datenum(now)], ylim,'LineWidth',2,'Color','k','LineStyle','-.')
        %time_start = mod(str2double(datestr(now,'SS.FFF')),30); % note epoch length hard coded here
        %figure(3); line([time_start time_start], ylim,'LineWidth',2,'Color','k','LineStyle','-.')
    elseif strcmp(status,'offline'); 
        sound(vl*sound_library(:,count+1),f_samp);
        time_played = toc(clock);
        %disp([datestr(now,'SS.FFF') ' ' num2str(input.data_count) ' Info. Sound played.']); % debug info
    else
        error('Incorrect status flag. Not clear whether online or offline');
    end
else
    % Play empty sound - helps ensure consistent timing
    if strcmp(status,'online');
        outp(888,1); sound(vl*sound_library(:,end),f_samp); outp(888,0);
        time_played = toc(clock);
        %disp([datestr(now,'SS.FFF') ' ' num2str(input.data_count) ' Info. No sound played, timing info only.']); % debug info
        %figure(2); line([datenum(now) datenum(now)], ylim,'LineWidth',2,'Color','k','LineStyle','-.')
        %time_start = mod(str2double(datestr(now,'SS.FFF')),30); % note epoch length hard coded here
        %figure(3); line([time_start time_start], ylim,'LineWidth',2,'Color','k','LineStyle','-.')
    elseif strcmp(status,'offline'); 
        sound(vl*sound_library(:,end),f_samp);
        time_played = toc(clock);
        %disp([datestr(now,'SS.FFF') ' ' num2str(input.data_count) ' Info. No sound played, timing info only.']); % debug info
    else
        error('Incorrect status flag. Not clear whether online or offline');
    end  
end



%% Set object inputs/outputs
output.count = count+1;
output.time_played = time_played;
output.play_flag = play_flag;
output.vl = vl;
obj.UserData = output;
