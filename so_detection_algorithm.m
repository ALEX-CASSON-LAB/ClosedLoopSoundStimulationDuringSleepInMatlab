function [peaks, locations] = so_detection_algorithm(alg_in,param)
%% Alex Casson
%
% Versions
% 16.06.15 - v1 - initial script
%
% Aim
% Run SO minimum detection algorithm
% -------------------------------------------------------------------------

% Main algorithm
[xmax,imax,xmin,imin] = extrema(alg_in);
peaks_raw = xmin(xmin<param.dt);
locations_raw = imin(xmin<param.dt);

% Checks to remove incorrect locations
if isempty(locations_raw) == 0 % only run checks if detections are made
    
    % Sort detections
    [locations_sorted, d] = sort(locations_raw);
    peaks_sorted = peaks_raw(d); 
    
    % Remove detections in last sample which can't be detected as a minimum
    if locations_sorted(end) == length(alg_in)
        locations_sorted(end) = []; 
        peaks_sorted(end) = [];
    end
    
    % Final value assignment
    locations = locations_sorted;
    peaks = peaks_sorted;
    
else % no detections
    locations = [];
    peaks = [];
end