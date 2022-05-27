%% Alex Casson
%
% Versions
% 20.04.16 - v1 - initial script
% 
% Aim
% Fit sound calibration line to measured earphone volume
% ------------------------------------------------------

%% Initalise Matlab
clear
close all


%% Load data
data = xlsread('Sound calibration sleep lab.xlsx');

%% Room 1
dB = data(3:8,1);
measured = data(3:8,5);
figure(1); plot(dB,measured,'bx-'); hold all
title('Room 1'); xlabel('Sound volume set in dB'); ylabel('Measured sound volume')

% Basic fit line
f = fit(dB,measured,'smoothingspline','SmoothingParam',0.05);
mkpp(f.p.breaks,f.p.coefs);
pp = mkpp(f.p.breaks,f.p.coefs);
fittedX = linspace(min(dB), max(dB), 200);
fittedY = ppval(pp,fittedX);
plot(fittedX, fittedY, 'r-');

% Correct fit so that it always an overestimate of the true loudness
error = ppval(pp,dB) - measured;
correction = abs(min(error));
fittedYY = ppval(pp,fittedX) + correction;
plot(fittedX, fittedYY, 'g-');

% Make output
room1.pp = pp;
room1.correction = correction;


%% Room 2
dB = data(3:10,1);
measured = data(3:10,9);
figure(2); plot(dB,measured,'bx-'); hold all
title('Room 2'); xlabel('Sound volume set in dB'); ylabel('Measured sound volume')

% Basic fit line
f = fit(dB,measured,'smoothingspline','SmoothingParam',0.05);
mkpp(f.p.breaks,f.p.coefs);
pp = mkpp(f.p.breaks,f.p.coefs);
fittedX = linspace(min(dB), max(dB), 200);
fittedY = ppval(pp,fittedX);
plot(fittedX, fittedY, 'r-');

% Correct fit so that it always an overestimate of the true loudness
error = ppval(pp,dB) - measured;
correction = abs(min(error));
fittedYY = ppval(pp,fittedX) + correction;
plot(fittedX, fittedYY, 'g-');

% Make output
room2.pp = pp;
room2.correction = correction;


%% Save output
save('volume_fit.mat','room1','room2');