function [final, fs] = generate_sounds
%% Alex Casson
%
% Versions
% 05.15.15 - v5 - Modified to make all output waveforms have a range -1 to 1
% 30.01.15 - v4 - Modified to use for generation of auditory stim sounds
% 18.06.10 - v3 - Tidyied up to demonstrate effect of sampling frequency on noise generation
% 28.05.10 - v2 - updated to take the average of 10 runs
% 03/09/08 - v1 - initial script
%
% Aim
% Matlab script to produce flicker noise using the 03.09.08 flicker noise
% model. This version investigates how the noise varies with sampling
% frequency, demonstrating that the same noise is not produced in all
% cases. This is corrected for in the latest noise model. 
%
% Note
% This version is sampling frequency dependent. PSD amplitude will change
% if the wav sampling frequency does. 
% -------------------------------------------------------------------------


%% Run settings1
fs = 44100;
dur = 150; % seconds. Allows for >2,600 50ms stims
duration = 50e-3; % seconds. Length of each stim
ramp = 5e-3;
cut_off = 20; % Hz, Lower bound for validity of noise shaping filter
Vnoise = 1; % Noise amplitude to investigate  
n = fs * dur; % number of data points


%% Generate shaping filter
num_taps = round(fs/(cut_off*2*pi));
gain = 1;
a = zeros(1,num_taps);
a(1) = 1;
for ii = 2:num_taps
  a(ii) = (ii - 2.5) * a(ii-1) / (ii-1);
end
%f = tf(gain,a,1/fs,'variable','z^-1'); % for visualisation



%% Generate noise

% Generate the starting wgn signal
%R = 1; P = Vnoise^2; wgn_noise = wgn(n,1,P,R,'linear'); % with communications toolbox
wgn_noise = Vnoise * randn(n,1);
wgn_noise = wgn_noise - mean(wgn_noise);

% Filter to get 1/f noise. (Both lsim and filter produce the same noise signal)
f_noise = filter(gain,a,wgn_noise);


%% Plotting / monitoring functions
%     
%     % Plot options
%     p = bodeoptions; % Bode settings
%     p.FreqUnits = 'Hz';
%     
%     % Time domain
%     time = 0:1/fs:n/fs-1/fs;
%     figure; plot(time,wgn_noise); grid on; xlabel('Time / s'); ylabel('Amplitude / \muV'); hold all 
%     plot(time,f_noise); grid on; xlabel('Time / s'); ylabel('Amplitude / \muV'); hold all
%     
%     
%     % Frequency domain
%     N = 2^12;
%     [wgn_pwelch,     wgn_pwelch_f]     = pwelch(wgn_noise,10000,0,N,fs);
%     [flicker_pwelch, flicker_pwelch_f] = pwelch(f_noise,10000,0,N,fs);
%     wgn_pwelch_db     = 10*log10(wgn_pwelch);
%     flicker_pwelch_db = 10*log10(flicker_pwelch);
%     figure; semilogx(wgn_pwelch_f,    wgn_pwelch_db);     grid on; hold all; xlabel('Frequency / Hz'); ylabel('PSD / dBV/Hz')
%     figure; semilogx(flicker_pwelch_f,flicker_pwelch_db); grid on; hold all; xlabel('Frequency / Hz'); ylabel('PSD / dBV/Hz')
% 
%     % Print out the resulting RMS values
%     rms_flicker = norm(f_noise)/sqrt(n)


%% Reformat data
crop = 5; % seconds to remove from each end
f_noise_crop = f_noise((fs*crop+1):(end-fs*crop));
f_noise_runs = reshape(f_noise_crop,duration*fs,[]);
window = [linspace(0,1,ramp*fs) ones(1,1+fs*(duration-(2*ramp))) linspace(1,0,ramp*fs)]';
windows = repmat(window,1,size(f_noise_runs,2));
sounds = f_noise_runs .* windows;


%% Normalise dynamic range so all signals are -1 to 1
ma = max(sounds);
mi = min(sounds);
pe = max(ma,abs(mi)); 
final = bsxfun(@rdivide,sounds,pe);

%% Add final noise case which is all zeros, i.e. silent
final(:,end+1) = zeros(size(final,1),1); 

