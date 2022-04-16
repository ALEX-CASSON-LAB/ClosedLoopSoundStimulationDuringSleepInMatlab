function scrolling_data_plot(f,x,y,yy,real,epoch)
%% Alex Casson
%
% Versions
% 15.02.16 - v1 - initial script
%
% Aim
% Plot the last 30s of data, only displying relevant marker lines
% -------------------------------------------------------------------------

% Setup 
axe = figure(f);

% Plot raw data line
h = findall(axe,'type','line','color','c'); delete(h);
plot(x,y,'c'); drawnow; hold on

% Plot alg in data line
h = findall(axe,'type','line','color','b'); delete(h);
plot(x,yy,'b'); drawnow; hold on

% Remove out of date markers
start_time = x(1);
end_time = x(end);
delete_last_marker_line(axe,'k',start_time,real,epoch);
delete_last_marker_line(axe,'r',start_time,real,epoch);
delete_last_marker_line(axe,'g',start_time,real,epoch);
