function output = db2mag_alex(input)
%% Alex Casson
% 
% Versions
% 05.02.15 - v1 - initial script
% Aim convert between magnitude and dB values
% -------------------------------------------------------------------------
output = 10^(input/20);