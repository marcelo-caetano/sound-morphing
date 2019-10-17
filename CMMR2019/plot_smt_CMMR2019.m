% FIGURE PLOT SOUND MORPHING TOOLBOX (SINUSOIDAL MODEL)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREAMBLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

soundext = 'wav';

% Flag for center of first window
cflag = {'nhalf','one','half'};

% Resynthesis flag
rflag = {'OLA','PI','PRFI'};

% Morphing factor
alpha = 0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Path relative to CURREXFILE
sourcePath = fullfile('.','audio','Accordion_C#3_f.wav');

% Info source sound
infos1 = audioinfo(listsound{inds1});

% Load source sound
[sound1] = audioread(listsound{inds1});

% Downmix from stereo to mono
sound1 = stereo2mono(sound1);

% Get file name
[fpath,fname1,fext] = fileparts(listsound{inds1});

% Fundamental frequency of source sound
f0s1 = swipep_mod(sound1,infos1.SampleRate,[75 500],1000/infos1.SampleRate,[],1/20,0.5,0.2);

% Reference f0 of source sound
ref0s1 = median(f0s1(not(isnan(f0s1))));

% Time samples for source sound
ts1 = gentime(infos1.TotalSamples,infos1.SampleRate);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 2.A) SOURCE WAVEFORM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Amplitude'};
ttl = {'Source Waveform'};
tmin = ts1(1);
tmax = ts1(end);
ampmin = min(sound1);
ampmax = max(sound1);
CMMR2019_makefigonlywaveform(ts1,sound1,tmin,tmax,ampmin,ampmax,xlbl,ylbl,ttl)

% Play source sound
sound(sound1,sr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

targetPath = fullfile('.','audio','Tuba_oV_hA_2-120_ff_C3.wav');

% Info target sound
infos2 = audioinfo(listsound{inds2});

% Load target sound
[sound2,sr] = audioread(listsound{inds2});

% Downmix from stereo to mono
sound2 = stereo2mono(sound2);

% Get file name
[fpath,fname2,fext] = fileparts(listsound{inds2});

% Fundamental frequency of target sound
f0s2 = swipep_mod(sound2,infos2.SampleRate,[75 500],1000/infos2.SampleRate,[],1/20,0.5,0.2);

% Reference f0 of target sound
ref0s2 = median(f0s2(not(isnan(f0s2))));

% Time vector for target sound
ts2 = gentime(infos2.TotalSamples,infos2.SampleRate);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 2.B) TARGET WAVEFORM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Amplitude'};
ttl = {'Target Waveform'};
tmin = ts2(1);
tmax = ts2(end);
ampmin = min(sound2);
ampmax = max(sound2);
CMMR2019_makefigonlywaveform(ts2,sound2,tmin,tmax,ampmin,ampmax,xlbl,ylbl,ttl)

% Play target sound
sound(sound2,sr)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TSM SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TSM factor source sound
alpha1 = intdur/infos1.TotalSamples;

% TSM source sound
tsm1 = solafs(sound1,shs,M,cflag{cf},Kmax,alpha1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 2.C) SOURCE TSM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_samples1 = gentime(length(tsm1),sr);

xlbl = {'Time (s)'};
ylbl = {'Amplitude'};
ttl = {'Source TSM'};
tmin = time_samples1(1);
tmax = time_samples1(end);
ampmin = min(tsm1);
ampmax = max(tsm1);
CMMR2019_makefigonlywaveform(time_samples1,tsm1,tmin,tmax,ampmin,ampmax,xlbl,ylbl,ttl)

% Play TSM source sound
sound(tsm1,sr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TSM TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TSM factor target sound
alpha2 = intdur/infos2.TotalSamples;

% TSM target sound
tsm2 = solafs(sound2,shs,M,cflag{cf},Kmax,alpha2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 2.D) TARGET TSM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_samples2 = gentime(length(tsm2),sr);
xlbl = {'Time (s)'};
ylbl = {'Amplitude'};
ttl = {'Target TSM'};
tmin = time_samples2(1);
tmax = time_samples2(end);
ampmin = min(tsm2);
ampmax = max(tsm2);
CMMR2019_makefigonlywaveform(time_samples2,tsm2,tmin,tmax,ampmin,ampmax,xlbl,ylbl,ttl)

% Play TSM target sound
sound(tsm2,sr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRE-PROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zeropad shorter sound to duration of longer one
[tsm1,tsm2] = zp2max(tsm1,tsm2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHORT-TIME FOURIER TRANSFORM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% winl = 3*T0
winl = max(fix(3*infos1.SampleRate/ref0s1),fix(3*infos2.SampleRate/ref0s2));

% 50% overlap
hopsize = fix(winl/2);

% Size of the FFT
nfft = 2^nextpow2(winl);

% Normalize window during analysis (sum(window)==1) and preserve energy upon resynthesis
normflag = 1;

% Use zero phase window
zphflag = 1;

% Hamming analysis window
wintype = 3;

% Frequency difference for peak matching (Hz)
delta = 10;

% Maximum number of spectral peaks
maxnpeak = 80;

% Magnitude spectrum scaling
scaleflag = {'nne','lin','log','power'};
sf = 3;

% Center first window at ONE (for SM)
cf = 2;

% Local threshold (inside frame)
thresframe = 66;

% Global threshold (whole sound)
threstotal = 66;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STFT SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[stft_tsm1,dur,dc,cfr1] = stft(tsm1,hopsize,winl,wintype,nfft,cflag{cf},normflag,zphflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 3.A) SOURCE SPECTROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make frequency vector in kHz
frequency = genfreq(nfft,sr,'pos',true);

xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Source Spectrogram'};
magspec_tsm1 = 20*log10(abs(stft_tsm1(1:nfft/2+1,:)));
time_frame1 = cfr1/sr;
tmin = time_frame1(2);
tmax = time_frame1(end-1);
freqmin = 0;
freqmax = 6;
CMMR2019_makefigonlyspecgram(magspec_tsm1,time_frame1,frequency/1000,tmin,tmax,...
    freqmin,freqmax,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STFT TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[stft_tsm2,dur,dc,cfr2] = stft(tsm2,hopsize,winl,wintype,nfft,cflag{cf},normflag,zphflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 3.B) TARGET SPECTROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Target Spectrogram'};
magspec_tsm2 = 20*log10(abs(stft_tsm2(1:nfft/2+1,:)));
time_frame2 = cfr2/sr;
tmin = time_frame2(2);
freqmin = 0;
freqmax = 6;
CMMR2019_makefigonlyspecgram(magspec_tsm2,time_frame2,frequency/1000,tmin,tmax,...
    freqmin,freqmax,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[amp1,freq1,ph1,dur1,dc1,cfr1] = sinusoidal_analysis(tsm1,hopsize,winl,wintype,...
    nfft,infos1.SampleRate,maxnpeak,thresframe,threstotal,cflag{cf},normflag,zphflag,scaleflag{sf});

% Number of frames source
nframe1 = length(cfr1);

% Time vector for source
time_samples1 = gentime(dur1,sr);

% Initialize
ampsin1 = nan(maxnpeak,nframe1);
freqsin1 = nan(maxnpeak,nframe1);
npeak1 = cellfun('size',amp1,1);

for iframe = 1:nframe1
    
    ampsin1(1:npeak1(iframe),iframe) = amp1{iframe};
    freqsin1(1:npeak1(iframe),iframe) = freq1{iframe};
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 3.C) SOURCE SPECTRAL PEAK POSITION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Source Spectral Peak Position'};
time_frame1 = cfr1/sr;
tmin = time_frame1(2);
tmax = time_frame1(end-1);
freqmin = 0;
freqmax = 6;
CMMR2019_makefigsinspecgram(magspec_tsm1,time_frame1,frequency/1000,freqsin1/1000,...
    tmin,tmax,freqmin,freqmax,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 3.E) SOURCE SPECTRAL PEAK AMPLITUDE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_peak1 = repmat(time_frame1,maxnpeak,1);
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Source Spectral Peak Amplitude'};
magpeak1 = 20*log10(ampsin1);
tmin = time_frame1(2);
tmax = time_frame1(end-1);
freqmin = 0;
freqmax = 6;
CMMR2019_makefigspecpeakgram(magpeak1,time_peak1,freqsin1/1000,tmin,tmax,freqmin,...
    freqmax,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 4.A) SOURCE SPECTRAL PEAK CONTINUATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Source Spectral Peak Continuation'};
tmin = time_frame1(2);
tmax = time_frame1(end-1);
freqmin = 0;
freqmax = 6;
markers = 6;
CMMR2019_makefigpeaktrack(freqsin1/1000,time_frame1,tmin,tmax,freqmin,freqmax,...
    markers,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 4.C) SOURCE PEAK CONTINUATION (ZOOM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Source Peak Continuation (Zoom)'};
tmin = time_frame1(2);
tmax = time_frame1(end-1);
freqmin = 0;
freqmax = 1;
markers = 10;
CMMR2019_makefigpeaktrack(freqsin1/1000,time_frame1,tmin,tmax,freqmin,freqmax,...
    markers,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIAL TRACKING SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amptrack1,freqtrack1,phasetrack1,ntrack1] = peak2track(amp1,freq1,ph1,nframe1,maxnpeak,nfft,infos1.SampleRate,fix(0.25*ref0s1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 5.A) SOURCE PARTIAL TRACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Source Partial Tracks'};
tmin = time_frame1(2);
tmax = time_frame1(end-1);
freqmin = 0;
freqmax = 6;
markers = 6;
CMMR2019_makefigpeaktrack(freqtrack1/1000,time_frame1,tmin,tmax,freqmin,freqmax,...
    markers,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 5.C) SOURCE PARTIAL TRACKS (ZOOM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Source Partial Tracks (Zoom)'};
tmin = time_frame1(2);
tmax = time_frame1(end-1);
freqmin = 0;
freqmax = 1;
markers = 10;
CMMR2019_makefigpeaktrack(freqtrack1/1000,time_frame1,tmin,tmax,freqmin,freqmax,...
    markers,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESYNTHESIS PARTIALS SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PI RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PI Resynthesis
rf = 2;

% Source PI resynthesis partials
[sinpart1_ph] = sinusoidal_resynthesis(amp1,freq1,ph1,delta,hopsize,winl,...
    wintype,sr,dur1,cfr1,maxnpeak,cflag{cf},rflag{rf});

% Play source PI resynthesis partials
sound(sinpart1,sr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRFI RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRFI Resynthesis
rf = 3;

% Source PRFI resynthesis partials
[sinpart1_noph] = sinusoidal_resynthesis(amp1,freq1,ph1,delta,hopsize,winl,...
    wintype,sr,dur1,cfr1,maxnpeak,cflag{cf},rflag{rf});

% Play source PRFI resynthesis partials
sound(sinpart1_noph,sr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 7A) SOURCE PARTIALS & RECONSTRUCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (ms)'};
ylbl = {'Amplitude'};
ttl = {'Source Partials & Reconstruction'};
tmin = time_samples1(1);
tmax = time_samples1(end);
ampmin = min(min(sinpart1_ph),min(sinpart1_noph));
ampmax = max(max(sinpart1_ph),max(sinpart1_noph));
leg = {'Orig Phase','Reconstruct'};
CMMR2019_makefigsinres(time_samples1,sinpart1_ph,sinpart1_noph,tmin,tmax,ampmin,ampmax,...
    xlbl,ylbl,ttl,leg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HARMONICS SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ampharm1,freqharm1,phaseharm1,isharm1] = track2harm(amptrack1,freqtrack1,phasetrack1,ntrack1,nframe1,ref0s1,delta);

[amph1,freqh1,phaseh1] = track2peak(ampharm1,freqharm1,phaseharm1,nframe1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 6.A) SOURCE HARMONICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_peak1 = repmat(time_frame1,ntrack1,1);

xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Source Harmonics'};
tmin = time_frame1(2);
tmax = time_frame1(end-1);
freqmin = 0;
freqmax = 6;
markers = 6;
CMMR2019_makefigpeaktrack(freqharm1/1000,time_frame1,tmin,tmax,freqmin,freqmax,...
    markers,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 6.C) SOURCE HARMONICS (ZOOM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Source Harmonics (Zoom)'};
tmin = time_frame1(2);
tmax = time_frame1(end-1);
freqmin = 0;
freqmax = 1;
markers = 10;
CMMR2019_makefigpeaktrack(freqharm1/1000,time_frame1,tmin,tmax,freqmin,freqmax,...
    markers,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESYNTHESIS HARMONICS SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PI RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PI Resynthesis
rf = 2;

% Source PI resynthesis harmonics
[sinh1_ph] = sinusoidal_resynthesis(amph1,freqh1,phaseh1,delta,hopsize,winl,...
    wintype,sr,dur1,cfr1,maxnpeak,cflag{cf},rflag{rf});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRFI RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRFI Resynthesis
rf = 3;

% Source PI resynthesis harmonics
[sinh1_noph] = sinusoidal_resynthesis(amph1,freqh1,phaseh1,delta,hopsize,winl,...
    wintype,sr,dur1,cfr1,maxnpeak,cflag{cf},rflag{rf});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 7B) SOURCE HARMONICS & RECONSTRUCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (ms)'};
ylbl = {'Amplitude'};
ttl = {'Source Harmonics & Reconstruction'};
tmin = time_samples1(1);
tmax = time_samples1(end);
ampmin = min(min(sinh1_ph),min(sinh1_noph));
ampmax = max(max(sinh1_ph),max(sinh1_noph));
leg = {'Orig Phase','Reconstruct'};
CMMR2019_makefigsinres(time_samples1,sinh1_ph,sinh1_noph,tmin,tmax,ampmin,ampmax,...
    xlbl,ylbl,ttl,leg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp2,freq2,ph2,dur2,dc2,cfr2] = sinusoidal_analysis(tsm2,hopsize,winl,wintype,...
    nfft,infos2.SampleRate,maxnpeak,thresframe,threstotal,cflag{cf},normflag,zphflag,scaleflag{sf});

% Number of frames
nframe2 = length(cfr2);

% Time vector for target
time_samples2 = gentime(dur2,sr);

% Initialize
ampsin2 = nan(maxnpeak,nframe2);
freqsin2 = nan(maxnpeak,nframe2);
npeak2 = cellfun('size',amp2,1);

for iframe = 1:nframe2
    
    ampsin2(1:npeak2(iframe),iframe) = amp2{iframe};
    freqsin2(1:npeak2(iframe),iframe) = freq2{iframe};
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 3.D) TARGET SPECTRAL PEAK POSITION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Target Spectral Peak Position'};
% magspec_tsm2 = 20*log10(abs(stft_tsm2(1:nfft/2+1,:)));
time_frame2 = cfr2/sr;
tmin = time_frame2(2);
tmax = time_frame2(end-1);
freqmin = 0;
freqmax = 6;
CMMR2019_makefigsinspecgram(magspec_tsm2,time_frame2,frequency/1000,freqsin2/1000,...
    tmin,tmax,freqmin,freqmax,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 3.E) TARGET SPECTRAL PEAK AMPLITUDE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_peak2 = repmat(time_frame2,maxnpeak,1);
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Target Spectral Peak Amplitude'};
magpeak2 = 20*log10(ampsin2);
tmin = time_frame2(2);
tmax = time_frame2(end-1);
freqmin = 0;
freqmax = 6;
CMMR2019_makefigspecpeakgram(magpeak2,time_peak2,freqsin2/1000,tmin,tmax,freqmin,...
    freqmax,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 4.B) TARGET SPECTRAL PEAK CONTINUATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Target Spectral Peak Continuation'};
tmin = time_frame2(2);
tmax = time_frame2(end-1);
freqmin = 0;
freqmax = 6;
markers = 6;
CMMR2019_makefigpeaktrack(freqsin2/1000,time_frame2,tmin,tmax,freqmin,freqmax,...
    markers,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 4.D) TARGET PEAK CONTINUATION (ZOOM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Target Peak Continuation (Zoom)'};
tmin = time_frame2(2);
tmax = time_frame2(end-1);
freqmin = 0;
freqmax = 1;
markers = 10;
CMMR2019_makefigpeaktrack(freqsin2/1000,time_frame2,tmin,tmax,freqmin,freqmax,...
    markers,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIAL TRACKING TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[amptrack2,freqtrack2,phasetrack2,ntrack2] = peak2track(amp2,freq2,ph2,nframe2,maxnpeak,nfft,infos2.SampleRate,fix(0.25*ref0s2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 5.B) TARGET PARTIAL TRACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Target Partial Tracks'};
tmin = time_frame2(2);
tmax = time_frame2(end-1);
freqmin = 0;
freqmax = 6;
markers = 6;
CMMR2019_makefigpeaktrack(freqtrack2/1000,time_frame2,tmin,tmax,freqmin,freqmax,...
    markers,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 5.D) TARGET PARTIAL TRACKS (ZOOM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Target Partial Tracks (Zoom)'};
tmin = time_frame2(2);
tmax = time_frame2(end-1);
freqmin = 0;
freqmax = 1;
markers = 10;
CMMR2019_makefigpeaktrack(freqtrack2/1000,time_frame2,tmin,tmax,freqmin,freqmax,...
    markers,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESYNTHESIS PARTIALS TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PI RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PI Resynthesis
rf = 2;

% Target PI resynthesis partials
[sinpart2_ph] = sinusoidal_resynthesis(amp2,freq2,ph2,delta,hopsize,winl,...
    wintype,sr,dur2,cfr2,maxnpeak,cflag{cf},rflag{rf});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRFI RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRFI Resynthesis
rf = 3;

% Source PI resynthesis partials
[sinpart2_noph] = sinusoidal_resynthesis(amp2,freq2,ph2,delta,hopsize,winl,...
    wintype,sr,dur2,cfr2,maxnpeak,cflag{cf},rflag{rf});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 7B) TARGET PARTIALS & RECONSTRUCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (ms)'};
ylbl = {'Amplitude'};
ttl = {'Target Partials & Reconstruction'};
tmin = time_samples2(1);
tmax = time_samples2(end);
ampmin = min(min(sinpart2_ph),min(sinpart2_noph));
ampmax = max(max(sinpart2_ph),max(sinpart2_noph));
leg = {'Orig Phase','Reconstruct'};
CMMR2019_makefigsinres(time_samples2,sinpart2_ph,sinpart2_noph,tmin,tmax,ampmin,ampmax,...
    xlbl,ylbl,ttl,leg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HARMONICS TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ampharm2,freqharm2,phaseharm2,isharm2] = track2harm(amptrack2,freqtrack2,phasetrack2,ntrack2,nframe2,ref0s2,delta);

[amph2,freqh2,phaseh2] = track2peak(ampharm2,freqharm2,phaseharm2,nframe2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 6.B) TARGET HARMONICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_peak2 = repmat(time_frame2,ntrack1,1);

xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Target Harmonics'};
tmin = time_frame2(2);
tmax = time_frame2(end-1);
freqmin = 0;
freqmax = 6;
markers = 6;
CMMR2019_makefigpeaktrack(freqharm2/1000,time_frame2,tmin,tmax,freqmin,freqmax,...
    markers,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 6.D) TARGET HARMONICS (ZOOM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (s)'};
ylbl = {'Frequency (kHz)'};
ttl = {'Target Harmonics (Zoom)'};
tmin = time_frame2(2);
tmax = time_frame2(end-1);
freqmin = 0;
freqmax = 1;
markers = 10;
CMMR2019_makefigpeaktrack(freqharm2/1000,time_frame2,tmin,tmax,freqmin,freqmax,...
    markers,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESYNTHESIS HARMONICS TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PI RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PI Resynthesis
rf = 2;

% Source PI resynthesis harmonics
[sinh2_ph] = sinusoidal_resynthesis(amph2,freqh2,phaseh2,delta,hopsize,winl,...
    wintype,sr,dur2,cfr2,maxnpeak,cflag{cf},rflag{rf});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRFI RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRFI Resynthesis
rf = 3;

% Source PI resynthesis harmonics
[sinh2_noph] = sinusoidal_resynthesis(amph2,freqh2,phaseh2,delta,hopsize,winl,...
    wintype,sr,dur2,cfr2,maxnpeak,cflag{cf},rflag{rf});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 7B) TARGET HARMONICS & RECONSTRUCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlbl = {'Time (ms)'};
ylbl = {'Amplitude'};
ttl = {'Target Harmonics & Reconstruction'};
tmin = time_samples2(1);
tmax = time_samples2(end);
ampmin = min(min(sinh2_ph),min(sinh2_noph));
ampmax = max(max(sinh2_ph),max(sinh2_noph));
leg = {'Orig Phase','Reconstruct'};
CMMR2019_makefigsinres(time_samples2,sinh2_ph,sinh2_noph,tmin,tmax,ampmin,ampmax,...
    xlbl,ylbl,ttl,leg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INTERPOLATE PARTIALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[interp_amp,interp_freq] = interp_sin(ampharm1,freqharm1,ref0s1,ntrack1,ampharm2,freqharm2,ref0s2,ntrack2,nframe2,alpha,'log');

interp_phase = zeros(size(interp_freq));

[amph,freqh,phaseh] = track2peak(interp_amp,interp_freq,interp_phase,nframe2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 8.B) MORPH SPECTRO-PEAKGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_peak = repmat(time_frame2,max(ntrack1,ntrack2),1);

xlbl = {'Time (s)'};
ylbl = {'Frequency (Hz)'};
ttl = {'Morph Spectral Peak Amplitude'};
magpeak = 20*log10(interp_amp);
tmin = time_frame2(2);
tmax = time_frame2(end-1);
freqmin = 0;
freqmax = 6000;
CMMR2019_makefigspecpeakgram(magpeak,time_peak,interp_freq,tmin,tmax,freqmin,freqmax,xlbl,ylbl,ttl)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[sinusoidal,partials,amp_partials,freq_partials] = sinusoidal_resynthesis(amph,freqh,phaseh,delta,hopsize,winl,wintype,sr,dur2,cfr1,maxnpeak,cflag{cf},rflag{rf});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG 8.A) MORPH WAVEFORM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time samples for target sound
tsmorph = gentime(length(sinusoidal),infos2.SampleRate);
xlbl = {'Time (s)'};
ylbl = {'Amplitude'};
ttl = {'Morph Waveform'};
tmin = tsmorph(1);
tmax = tsmorph(end);
ampmin = min(sinusoidal);
ampmax = max(sinusoidal);
CMMR2019_makefigonlywaveform(tsmorph,sinusoidal,tmin,tmax,ampmin,ampmax,xlbl,ylbl,ttl)

% Play morph
sound(tsmorph,sr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLAY SOUNDS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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