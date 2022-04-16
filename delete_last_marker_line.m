function delete_last_marker_line(axe,colour,start_time,real,epoch)
%% Alex Casson
%
% Versions
% 15.02.16 - v1 - initial script
%
% Aim
% Remove markers from real-time plot if they are not in the last 30s
% -------------------------------------------------------------------------
g = findall(axe,'type','line','color',colour);
if isempty(g) == 0;
    markers = get(g,'XData'); if iscell(markers); markers = cell2mat(markers); end
    markers = sort(markers,1);
    last_marker = markers(1);
    if real == 1
        if last_marker(end) <= start_time
            delete(g(end));
        end
    else
        if start_time + last_marker(end) >= epoch  
            delete(g(end));
        end
    end
end