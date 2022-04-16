function [final, fs] = generate_sounds
%% Alex Casson and Mathieu
%
% Versions
% 15.03.16 - v6 - Creation of sequence of 10 sounds
% 05.15.15 - v5 - Modified to make all output waveforms have a range -1 to 1
% 30.01.15 - v4 - Modified to use for generation of auditory stim sounds
% 18.06.10 - v3 - Tidyied up to demonstrate effect of sampling frequency on noise generation
% 28.05.10 - v2 - updated to take the average of 10 runs
% 03/09/08 - v1 - initial script
%
% Aim
% Produce a table gathering the different sounds for Edens pilot on
% habituation. The main pattern is
% 10 pink noises (identical)
% 10 silences
% 10 vowels a
% 10 silences
% 10 pink noises (different)
% 10 silences
% 10 different sounds
% 10 silences
% This pattern loops 10 times.
%
%
% Note
% This version is sampling frequency dependent. PSD amplitude will change
% if the wav sampling frequency does.
% -------------------------------------------------------------------------

%% Run settings1
%fs = 44100;
%dur = 60; % seconds. Allows for >1000 50ms stims
%duration = 50e-3; % seconds. Length of each stim
%ramp = 5e-3;
%cut_off = 20; % Hz, Lower bound for validity of noise shaping filter
%Vnoise = 1; % Noise amplitude to investigate
%n = fs * dur; % number of data points

%% Generate shaping filter
%gain = 1;
%a = zeros(1,num_taps);
%a(1) = 1;
%for ii = 2:num_taps
%  a(ii) = (ii - 2.5) * a(ii-1) / (ii-1);
%end
%f = tf(gain,a,1/fs,'variable','z^-1'); % for visualisation



%% Generate noise

% Generate the starting wgn signal
% This is a long signal which we later cut in pieces
%R = 1; P = Vnoise^2; wgn_noise = wgn(n,1,P,R,'linear'); % with communications toolbox
%wgn_noise = Vnoise * randn(n,1);
%wgn_noise = wgn_noise - mean(wgn_noise);

% Filter to get 1/f noise. (Both lsim and filter produce the same noise signal)
%f_noise = filter(gain,a,wgn_noise);

%crop = 5; % seconds to remove from each end
%f_noise_crop = f_noise((fs*crop+1):(end-fs*crop));
%f_noise_runs = reshape(f_noise_crop,duration*fs,[]);

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

% Create a sequence of 10 identical pink noise
%pink = f_noise_runs(:,1);
%pink = normalize(pink);
%pink_10 = repmat(pink,1,10);

% Create a sequence of 10 different pink noise
%pink_10_diff = f_noise_runs(:,2:11);
%pink_10_diff = normalize(pink_10_diff);

%% Import and format sound from wav

% adress of files
addr='C:\Users\student\Desktop\Eden\Sounds4\';

% Create a sequence of 10 B sounds
%[B, fs] = audioread(strcat(addr,'B_note.wav'));% recent matlab
[B, fs, bits] = wavread(strcat(addr,'B_note.wav'));% old matlab
%B = normalize(B);
B_10 = repmat(B,1,10);

% Create a sequence of 10 D sounds
%[D, fs] = audioread(strcat(addr,'D_note.wav'));% recent matlab
[D, fs, bits] = wavread(strcat(addr,'D_note.wav'));% old matlab
%D = normalize(D);
D_10 = repmat(D,1,10);

% Import various sounds
%[D, fs] = audioread(strcat(addr,'D_note.wav'));% recent matlab
%[D, fs, bits] = wavread(strcat(addr,'D_note.wav'));% old matlab
%D = normalize(D);
%[B, fs] = audioread(strcat(addr,'B_note.wav'));% recent matlab
%[B, fs, bits] = wavread(strcat(addr,'B_note.wav'));% old matlab
%B = normalize (B);
%[E, fs] = audioread(strcat(addr,'E_note.wav'));% recent matlab
% [E, fs, bits] = wavread(strcat(addr,'E_note.wav'));% old matlab
% E = normalize (E);
% 
% % Manually create 10 random sequences of 10 random sounds
% seq_rand_1 = [D B E pink D B E pink D B];
% seq_rand_2 = [D D B B E E pink pink D D];
% seq_rand_3 = [B E pink B E D pink E D B];
% seq_rand_4 = [pink B E pink D D B E pink B];
% seq_rand_5 = [B B D E pink pink D E B pink];
% seq_rand_6 = [pink B E D D B pink E B D];
% seq_rand_7 = [D B B E E B E pink pink D];
% seq_rand_8 = [D B E pink D E B pink B D];
% seq_rand_9 = [D D D E E E pink pink pink B];
% seq_rand_10 = [E pink B pink D pink E pink D pink];
% 
% %% Create a sequence of 10 silences
% silence_10 = zeros(fs * duration ,10);
% 
% %% Gather everything in a big matrix representing the pattern
% big_mat = [pink_10 B_10 silence_10 seq_rand_1 D_10];
% big_mat = [big_mat pink_10 B_10 silence_10 seq_rand_2 D_10];
% big_mat = [big_mat pink_10 B_10 silence_10 seq_rand_3 D_10];
% big_mat = [big_mat pink_10 B_10 silence_10 seq_rand_4 D_10];
% big_mat = [big_mat pink_10 B_10 silence_10 seq_rand_5 D_10];
% big_mat = [big_mat pink_10 B_10 silence_10 seq_rand_6 D_10];
% big_mat = [big_mat pink_10 B_10 silence_10 seq_rand_7 D_10];
% big_mat = [big_mat pink_10 B_10 silence_10 seq_rand_8 D_10];
% big_mat = [big_mat pink_10 B_10 silence_10 seq_rand_9 D_10];
% big_mat = [big_mat pink_10 B_10 silence_10 seq_rand_10 D_10];
% 
% % Repeat many times
% big_mat = [big_mat big_mat]; % 1000 sounds
% big_mat = [big_mat big_mat big_mat big_mat big_mat]; % 5000 sounds
% 
% %% Reformat data
% window = [linspace(0,1,ramp*fs) ones(1,1+fs*(duration-(2*ramp))) linspace(1,0,ramp*fs)]';
% windows = repmat(window,1,size(big_mat,2));
% final = big_mat .* windows;
final= [B_10 D_10];
% 
% %% Add final noise case which is all zeros, i.e. silent
final(:,end+1) = zeros(size(final,1),1);
% 
% function vecout = normalize(vecin)
% % Normalise dynamic range so all signals are -1 to 1
%     ma = max(vecin);
%     mi = min(vecin);
%     pe = max(ma,abs(mi));
%     vecout = bsxfun(@rdivide,vecin,pe);
