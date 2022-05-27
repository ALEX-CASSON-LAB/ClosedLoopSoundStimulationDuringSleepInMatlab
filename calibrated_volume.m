function db_calibrated = calibrated_volume(vl_in_computer_db,vl_fit)
%% Alex Casson
% 
% Versions
% 20.04.16 - v1 - initial script
% 
% Aim convert multiplier type volumes into calibrated dB as measured for
% each of the computers
% -------------------------------------------------------------------------

db_calibrated = ppval(vl_fit.pp,vl_in_computer_db) + vl_fit.correction;