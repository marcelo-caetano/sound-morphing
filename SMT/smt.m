function [sin_harm_morph] = smt(source_path,target_path,morph_factor)
%SMT Sound morphing toolbox
%   M = SMT(S,T,ALPHA) generates the morph M between the source S and the
%   target T according to the morphing factor ALPHA varying between 0 and
%   1. When ALPHA=0 M=S and when ALPHA=1 M=T. Intermediate values of ALPHA
%   generate M between S and T.

% 2019 M Caetano SMT 0.1.1
% 2020 MCaetano SMT 0.1.2 (Revised)
% 2021 M Caetano SMT
% 2022 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load source sound
[audio_source,fs_source] = audioread(source_path);

% Get total number of samples
nsample_source = length(audio_source);

% Downmix from stereo to mono
audio_source = tools.wav.stereo2mono(audio_source);

% Fundamental frequency of source sound
f0_source = swipep_mod(audio_source,fs_source,[75 500],1000/fs_source,[],1/20,0.5,0.2);

% Median f0 of source sound
ref0_source = tools.f0.reference_f0(f0_source);

% Number of fundamental periods
nT0 = 6;

% Frame size of source sound
framelen_source = tools.dsp.framesize(f0_source,fs_source,nT0);

% Frequency difference for peak matching (Hz)
freq_diff_source = tools.dsp.freq_diff4peak_matching(ref0_source);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load target sound
[audio_target,fs_target] = audioread(target_path);

% Get total number of samples
nsample_target = length(audio_target);

% Downmix from stereo to mono
audio_target = tools.wav.stereo2mono(audio_target);

% Fundamental frequency of target sound
f0_target = swipep_mod(audio_target,fs_target,[75 500],1000/fs_target,[],1/20,0.5,0.2);

% Median f0 of target sound
ref0_target = tools.f0.reference_f0(f0_target);

% Frame size of target sound
framelen_target = tools.dsp.framesize(f0_target,fs_target,nT0);

% Frequency difference for peak matching (Hz)
freq_diff_target = tools.dsp.freq_diff4peak_matching(ref0_target);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TIME SCALE MODIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Overlap
tsm_winoverlap = 220; % 5 ms @ 44.1kHz

% Synthesis hop size >= tsm_winoverlap (smallest == tsm_winoverlap)
tsm_synth_hopsize = 2*tsm_winoverlap;

% Window (frame) size (smallest 2*tsm_winoverlap)
tsm_winsize = 3*tsm_winoverlap;

% maxcorr >= T0
maxcorr = 600; % 13.6 ms @ 44.1kHz

% Interpolated duration
nsample_morph = fix((nsample_source + nsample_target)*morph_factor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TSM SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TSM factor source sound
tsmfactor_source = nsample_morph/nsample_source;

% TSM source sound
tsm_source = solafs(audio_source,tsm_winsize,tsm_synth_hopsize,maxcorr,tsmfactor_source,'causal');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TSM TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TSM factor target sound
tsmfactor_target = nsample_morph/nsample_target;

% TSM target sound
tsm_target = solafs(audio_target,tsm_winsize,tsm_synth_hopsize,maxcorr,tsmfactor_target,'causal');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRE-PROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zeropad shorter sound to duration of longer one
[tsm_source,tsm_target] = zp2max(tsm_source,tsm_target);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANALYSIS PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SPECTRAL ANALYSIS
% Analysis window
winflag = 6;
% Display name of analysis window in the terminal
fprintf(1,'%s analysis window\n',tools.dsp.infowin(winflag,'name'));
% Center first window at NON (for SM)
causalflag = 'non';
% Normalize analysis window
normflag = true;
% Use zero phase window
zphflag = true;

% PARAMETER ESTIMATION
paramestflag = 'pow';
% Maximum number of peaks to retrieve from analysis
maxnpeak = 150;
% Return MAXNPEAK frequency bins
npeakflag = false;

% PARTIAL TRACKING
ptrackflag = true;
% Partial tracking
ptrackalgflag = 'p2p';

% PEAK SELECTION
peakselflag = true;
% Peak shape threshold (normalized)
shapethres = 0.8;
% Peak range threshold (dB power)
rangethres = 10;
% Relative threshold (dB power)
relthres = -90;
% Absolute threshold (dB power)
absthres = -100;

% TRACK DURATION SELECTION
trackdurflag = true;
% Duration threshold (ms)
durthres = 50;
% Connect over (ms)
gapthres = 20;

% HARMONIC SELECTION
harmselflag = true;
tvarf0flag = false;
% Maximum harmonic deviation (cents)
max_harm_dev = 100;
harm_thresh = 0.8;
harmpartflag = 'count';

% VARIABLE PARAMETERS
% framelen = 3*T0
framelen = max(framelen_source,framelen_target);
% 50% overlap
hop = tools.dsp.hopsize(framelen,0.5);
% Spectral oversampling factor
osfac = 4;
% Size of the FFT
nfft = tools.dsp.fftsize(framelen,osfac);

% Display resynthesis info
dispflag = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp_source,freq_source,ph_source,cframe_source,npartial_source,nframe_source,nchannel_source,nsample_source,dc_source] =...
    sinusoidal_analysis(tsm_source,framelen,hop,nfft,fs_source,...
    winflag,causalflag,normflag,zphflag,paramestflag,maxnpeak,npeakflag,...
    ptrackflag,ptrackalgflag,freq_diff_source,...
    peakselflag,shapethres,rangethres,relthres,absthres,...
    trackdurflag,durthres,gapthres,...
    harmselflag,ref0_source,tvarf0flag,max_harm_dev,harm_thresh,harmpartflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp_target,freq_target,ph_target,cframe_target,npartial_target,nframe_target,nchannel_target,nsample_target,dc_target] =...
    sinusoidal_analysis(tsm_target,framelen,hop,nfft,fs_target,...
    winflag,causalflag,normflag,zphflag,paramestflag,maxnpeak,npeakflag,...
    ptrackflag,ptrackalgflag,freq_diff_target,...
    peakselflag,shapethres,rangethres,relthres,absthres,...
    trackdurflag,durthres,gapthres,...
    harmselflag,ref0_target,tvarf0flag,max_harm_dev,harm_thresh,harmpartflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INTERPOLATE HARMONICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nsample_morph = max(nsample_source,nsample_target);
cframe_morph = cframe_source;
nframe_morph = nframe_source;
nchannel_morph = nchannel_source;

[interp_amp,interp_freq] = partial_interpolation(amp_source,freq_source,ref0_source,npartial_source,...
    amp_target,freq_target,ref0_target,npartial_target,nframe_morph,nchannel_morph,morph_factor,'log');

npartial_morph = size(interp_freq,1);

nchannel_morph = nchannel_source;

interp_ph = zeros(size(interp_freq));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs_morph = 44100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRFI RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[sin_harm_morph,part_harm_morph,amp_part_morph,freq_part_morph] = ...
    sinusoidal_resynthesis(interp_amp,interp_freq,interp_ph,...
    framelen,hop,fs_morph,winflag,nsample_morph,cframe_morph,npartial_morph,nframe_morph,nchannel_morph,...
    durthres,gapthres,max_harm_dev,'non','PRFI',ptrackflag,trackdurflag,dispflag);

end
