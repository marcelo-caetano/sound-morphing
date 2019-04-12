% TEST SOUND MORPHING TOOLBOX (SINUSOIDAL MODEL)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREAMBLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Path to save figures
savfigpath = makepath({'Users','mcaetano','Documents','Presentations','2018_Timbre','figs'});

% Path to save sounds
savsndpath = makepath({'Users','mcaetano','Documents','Presentations','2018_Timbre','sounds'});

figext = 'png';

soundext = '.wav';

% Flag for center of first window
cflag = {'nhalf','one','half'};

% Resynthesis flag
rflag = {'OLA','OLAWP','PI','ADDWP'};

alpha = 0.5;

% listsound = rsf(makepath({'Users','mcaetano','Documents','Sound Database','Misc Mus Instr','Sounds'}),'wav');
listsound = rsf(makepath({'Users','mcaetano','Documents','Sound Database','Vienna','Sounds'}),'wav');

% GOOD EXAMPLES
% 1: Accordion_C#3_f.wav
% 4: Alto_Flute_sV_na_f_C4.wav

% 1: Accordion_C#3_f.wav
% 40: Clavinet_C3_f.wav

% 5: Baritone_Sax_C3_f.wav
% 104: Wagner_Tuba_nA_f_C3.wav

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOUND 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Path to sound 1
% 1: Accordion_C#3_f.wav
% 2: Acoustic_Guitar_C3_f.wav
% 4: Alto_Flute_sV_na_f_C4.wav
% 5: Baritone_Sax_C3_f.wav
% 6: Bass_4-120_mf1_C3.wav
% 7: Bass_Clarinet_nA_4-120_f1_C3.wav
% 8: Bass_Clarinet_nA_4-120_p1_C3.wav
% 9: Bass_Clarinet_nA_4-120_pp1_C3.wav
% 10: Bass_Clarinet_nA_f_C3.wav
% 16: Bass_Trumpet_mV_nA_f_C3.wav
% 24: Cello_mV_f_C3.wav
% 32: Clarinet_Bb_nA_4-120_f1_C4.wav
% 40: Clavinet_C3_f.wav
% 44: Contrabass_Tuba_nA_f_C3.wav
% 80: Trumpet_C_oV_nA_f_C4.wav
% 100: Violin_f_C4.wav
% 104: Wagner_Tuba_nA_f_C3.wav
inds1 = 179;

% Info sound1
infos1 = audioinfo(listsound{inds1});

% Load sound 1
[sound1] = audioread(listsound{inds1});

% Downmix from stereo to mono
sound1 = stereo2mono(sound1,infos1.NumChannels);

% Get file name
[fpath,fname1,fext] = fileparts(listsound{inds1});

% Fundamental frequency of sound 1
f0s1 = swipep(sound1,infos1.SampleRate,[75 500],1000/infos1.SampleRate,[],1/20,0.5,0.2);

% Reference f0 of sound 1
ref0s1 = median(f0s1,'omitnan');

% Time samples for sound 1
ts1 = (0:infos1.TotalSamples-1)/infos1.SampleRate';

% ORIGINAL WAVEFORM SOUND 1
xlbl = {'Time (s)'};
ylbl = {'Amplitude'};
ttl = {strrep(fname1,'_',' ')};
tmin = ts1(1);
tmax = ts1(end);
% tmax = 1;
ampmin = min(sound1);
ampmax = max(sound1);
makefigonlywaveform(ts1,sound1,tmin,tmax,ampmin,ampmax,xlbl,ylbl,ttl,figext,[savfigpath,{[fname1 '.' figext]}])

a=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOUND 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Path to sound 2
% 1: Accordion_C#3_f.wav
% 2: Acoustic_Guitar_C3_f.wav
% 4: Alto_Flute_sV_na_f_C4.wav
% 5: Baritone_Sax_C3_f.wav
% 6: Bass_4-120_mf1_C3.wav
% 7: Bass_Clarinet_nA_4-120_f1_C3.wav
% 8: Bass_Clarinet_nA_4-120_p1_C3.wav
% 9: Bass_Clarinet_nA_4-120_pp1_C3.wav
% 10: Bass_Clarinet_nA_f_C3.wav
% 16: Bass_Trumpet_mV_nA_f_C3.wav
% 24: Cello_mV_f_C3.wav
% 32: Clarinet_Bb_nA_4-120_f1_C4.wav
% 40: Clavinet_C3_f.wav
% 44: Contrabass_Tuba_nA_f_C3.wav
% 80: Trumpet_C_oV_nA_f_C4.wav
% 100: Violin_f_C4.wav
% 104: Wagner_Tuba_nA_f_C3.wav
inds2 = 65;

% Info sound1
infos2 = audioinfo(listsound{inds2});

% Load sound 2
[sound2,sr] = audioread(listsound{inds2});

% Downmix from stereo to mon
sound2 = stereo2mono(sound2,infos2.NumChannels);

% Get file name
[fpath,fname2,fext] = fileparts(listsound{inds2});

% Fundamental frequency of sound 1
f0s2 = swipep(sound2,infos2.SampleRate,[75 500],1000/infos2.SampleRate,[],1/20,0.5,0.2);

% Reference f0 of sound 2
ref0s2 = median(f0s2,'omitnan');

% Time samples for sound 2
ts2 = (0:infos2.TotalSamples-1)/infos2.SampleRate';

% ORIGINAL WAVEFORM SOUND 2
xlbl = {'Time (s)'};
ylbl = {'Amplitude'};
ttl = {strrep(fname2,'_',' ')};
tmin = ts2(1);
tmax = ts2(end);
% tmax = 1;
ampmin = min(sound2);
ampmax = max(sound2);
makefigonlywaveform(ts2,sound2,tmin,tmax,ampmin,ampmax,xlbl,ylbl,ttl,figext,[savfigpath,{[fname2 '.' figext]}])

a=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TIME SCALE MODIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Overlap
Wov = 220; % 5 ms

% Synthesis hop size >= Wov (smallest == Wov)
shs = 2*Wov;

% Window (frame) size (smallest 2*Wov)
M = 3*Wov;

% Kmax >= T0
Kmax = 600; % 13.6 ms

% Interpolated duration
intdur = fix((infos1.TotalSamples + infos2.TotalSamples)/2);

% Center first window at HALF (for SOLA-FS)
cf = 3;

a=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOUND 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha1 = intdur/infos1.TotalSamples;

tsm1 = solafs(sound1,shs,M,cflag{cf},Kmax,alpha1);

% % Listen to time-scaled sound 1
% sound(tsm1,infos1.SampleRate)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOUND 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha2 = intdur/infos2.TotalSamples;

tsm2 = solafs(sound2,shs,M,cflag{cf},Kmax,alpha2);

% % Listen to time-scaled sound 2
% sound(tsm2,infos2.SampleRate)
a=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRE-PROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zeropad shorter sound to duration of longer one
[tsm1,tsm2] = zp2max(tsm1,tsm2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% winl = 3*T0
winl = max(fix(3*infos1.SampleRate/ref0s1),fix(3*infos2.SampleRate/ref0s2));

% 50% overlap
hopsize = fix(winl/2);

nfft = 2^nextpow2(winl);

bin = infos2.SampleRate/nfft;

frequency = 0:bin:infos2.SampleRate/2;

% Normalize window during analysis (sum(window)==1) and preserve energy upon resynthesis
normflag = 1;

% Use zero phase window
zphflag = 1;

% Hamming analysis window
wintype = 7;

% Frequency difference for peak matching (Hz)
delta = 10;

% Maximum number of spectral peaks
maxnpeak = 80;

% Magnitude spectrum scaling
magflag = {'lin','log','power'};
mf = 2;

% % Center first window at NHALF (for SM)
% cf = 1;

% Center first window at ONE (for SM)
cf = 2;

% Local threshold (inside frame)
% thresframe = inf(1);
% thresframe = infowin(wintype,'sll');
thresframe = 66;

% Global threshold (whole sound)
% threstotal = inf(1);
threstotal = 66;

a=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOUND 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp1,freq1,ph1,dur1,dc1,cfr1] = sinusoidal_analysis_test(tsm1,frequency,nfft,hopsize,winl,wintype,cflag{cf},normflag,zphflag,magflag{mf},maxnpeak,thresframe,threstotal);

nframe1 = length(cfr1);

time_frame1 = cfr1/infos1.SampleRate;

[amptrack1,freqtrack1,phasetrack1,ntrack1] = peak2track(amp1,freq1,ph1,nframe1,maxnpeak,nfft,infos1.SampleRate,fix(0.25*ref0s1));

dbtsm1 = rmsdb(tsm1);

[ampharm1,freqharm1,phaseharm1,isharm1] = track2harm(amptrack1,freqtrack1,phasetrack1,ntrack1,nframe1,ref0s1,delta);

% nharm1 = nnz(isharm1);

[amph1,freqh1,phaseh1] = track2peak(ampharm1,freqharm1,phaseharm1,nframe1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAKE FIG HARMONICS SPECTROGRAM 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_peak = repmat(time_frame1,ntrack1,1);

xlbl = {'Time (s)'};
ylbl = {'Frequency (Hz)'};
ttl = {strrep(fname1,'_',' ')};
magpeak = 20*log10(ampharm1);
tmin = time_frame1(2);
tmax = time_frame1(end-1);
% tmin = 0;
% tmax = 1;
freqmin = 0;
freqmax = 6000;
makefigspecpeakgram(magpeak,time_peak,freqharm1,tmin,tmax,freqmin,freqmax,xlbl,ylbl,ttl,figext,[savfigpath,{[fname1 '_spectralpeakgram.' figext]}])

rf = 4;

[sinh1] = sinusoidal_resynthesis_test(amph1,freqh1,phaseh1,delta,hopsize,winl,sr,dur1,wintype,cflag{cf},cfr1,rflag{rf},maxnpeak);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOUND 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp2,freq2,ph2,dur2,dc2,cfr2] = sinusoidal_analysis_test(tsm2,frequency,nfft,hopsize,winl,wintype,cflag{cf},normflag,zphflag,magflag{mf},maxnpeak,thresframe,threstotal);

[stft2,~,~,~] = stft(tsm2,hopsize,winl,wintype,cflag{cf},nfft,normflag,zphflag);

nframe2 = length(cfr2);

time_frame2 = cfr2/infos1.SampleRate;

[amptrack2,freqtrack2,phasetrack2,ntrack2] = peak2track(amp2,freq2,ph2,nframe2,maxnpeak,nfft,infos2.SampleRate,fix(0.25*ref0s2));

dbtsm2 = rmsdb(tsm2);

[ampharm2,freqharm2,phaseharm2,isharm2] = track2harm(amptrack2,freqtrack2,phasetrack2,ntrack2,nframe2,ref0s2,delta);

[amph2,freqh2,phaseh2] = track2peak(ampharm2,freqharm2,phaseharm2,nframe2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAKE FIG HARMONICS SPECTROGRAM 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_peak = repmat(time_frame2,ntrack2,1);

xlbl = {'Time (s)'};
ylbl = {'Frequency (Hz)'};
ttl = {strrep(fname2,'_',' ')};
magpeak = 20*log10(ampharm2);
tmin = time_frame2(2);
tmax = time_frame2(end-1);
% tmin = 0;
% tmax = 1;
freqmin = 0;
freqmax = 6000;
makefigspecpeakgram(magpeak,time_peak,freqharm2,tmin,tmax,freqmin,freqmax,xlbl,ylbl,ttl,figext,[savfigpath,{[fname2 '_spectralpeakgram.' figext]}])

rf = 4;

[sinh2] = sinusoidal_resynthesis_test(amph2,freqh2,phaseh2,delta,hopsize,winl,sr,dur2,wintype,cflag{cf},cfr1,rflag{rf},maxnpeak);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INTERPOLATE PARTIALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[interp_amp,interp_freq] = interp_sin(ampharm1,freqharm1,ref0s1,ntrack1,ampharm2,freqharm2,ref0s2,ntrack2,nframe2,alpha);

interp_phase = zeros(size(interp_freq));

[amph,freqh,phaseh] = track2peak(interp_amp,interp_freq,interp_phase,nframe2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAKE FIG PEAKS INTERP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_peak = repmat(time_frame2,max(ntrack1,ntrack2),1);

xlbl = {'Time (s)'};
ylbl = {'Frequency (Hz)'};
ttl = {[strrep(fname1,'_',' ') ' + ' strrep(fname2,'_',' ')]};
magpeak = 20*log10(interp_amp);
tmin = time_frame2(2);
tmax = time_frame2(end-1);
% tmin = 0;
% tmax = 1;
freqmin = 0;
freqmax = 6000;
makefigspecpeakgram(magpeak,time_peak,interp_freq,tmin,tmax,freqmin,freqmax,xlbl,ylbl,ttl,figext,[savfigpath,{[fname1 ' ' fname2 '_morph_spec.' figext]}])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[sinusoidal,partials,amp_partials,freq_partials] = sinusoidal_resynthesis_test(amph,freqh,phaseh,delta,hopsize,winl,sr,dur2,wintype,cflag{cf},cfr1,rflag{rf},maxnpeak);

% FIGURE WAVEFORM MORPH
% Time samples for sound 2
tsmorph = (0:length(sinusoidal)-1)/infos2.SampleRate';

% ORIGINAL WAVEFORM SOUND 2
xlbl = {'Time (s)'};
ylbl = {'Amplitude'};
ttl = {[strrep(fname1,'_',' ') ' + ' strrep(fname2,'_',' ')]};
tmin = tsmorph(1);
tmax = tsmorph(end);
% tmax = 1;
ampmin = min(sinusoidal);
ampmax = max(sinusoidal);
makefigonlywaveform(tsmorph,sinusoidal,tmin,tmax,ampmin,ampmax,xlbl,ylbl,ttl,figext,[savfigpath,{[fname1 '_' fname2 '_morph.' figext]}])

% Original 1
% LISTEN TO ORIGINAL, SINUSOIDAL, RESIDUAL
audiowrite([savsndpath filesep fname1 soundext],sound1,infos1.SampleRate);
audiowrite([savsndpath filesep fname2 soundext],sound2,infos1.SampleRate);

audiowrite([savsndpath filesep fname1 '_tsm' soundext],tsm1,infos1.SampleRate);
audiowrite([savsndpath filesep fname2 '_tsm' soundext],tsm2,infos1.SampleRate);

audiowrite([savsndpath filesep fname1 '_sinh' soundext],sinh1,infos1.SampleRate);
audiowrite([savsndpath filesep fname2 '_sinh' soundext],sinh2,infos1.SampleRate);

audiowrite([savsndpath filesep fname1 '_' fname2 '_morph' soundext],sinusoidal,infos1.SampleRate);

sound(sound1,sr)
pause(ts1(end)+0.5)

sound(sound2,sr)
pause(ts2(end)+0.5)

sound(tsm1,sr)
pause(ts2(end)+0.5)

sound(sinh1,sr)
pause(ts2(end)+0.5)

sound(tsm2,sr)
pause(ts2(end)+0.5)

sound(sinh2,sr)
pause(ts2(end)+0.5)

sound(sinusoidal,sr)