function [sin_harm_morph] = smt(source_path,target_path,morph_factor)
%SMT Sound morphing toolbox
%   M = SMT(S,T,ALPHA) generates the morph M between the source S and the
%   target T according to the morphing factor ALPHA varying between 0 and
%   1. When ALPHA=0 M=S and when ALPHA=1 M=T. Intermediate values of ALPHA
%   generate M between S and T.

% 2019 M Caetano SMT 0.1.1
% 2020 MCaetano SMT 0.1.2 (Revised)
% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


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

% Frame size of source sound
framelen_source = tools.dsp.framesize(f0_source,fs_source,3);

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
framelen_target = tools.dsp.framesize(f0_target,fs_target,3);

% Frequency difference for peak matching (Hz)
freq_diff_target = tools.dsp.freq_diff4peak_matching(ref0_target);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TIME SCALE MODIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Overlap
tsm_winoverlap = 220; % 5 ms

% Synthesis hop size >= tsm_winoverlap (smallest == tsm_winoverlap)
tsm_synth_hopsize = 2*tsm_winoverlap;

% Window (frame) size (smallest 2*tsm_winoverlap)
tsm_winsize = 3*tsm_winoverlap;

% maxcorr >= T0
maxcorr = 600; % 13.6 ms

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

% framelen = 3*T0
framelen = max(framelen_source,framelen_target);

% 50% overlap
hop = tools.dsp.hopsize(framelen,0.5);

% Size of the FFT
nfft = tools.dsp.fftsize(framelen);

% Blackman-Harris analysis window
winflag = 6;

% Frequency difference for harmonic selection (Hz)
delta_harm = 20;

% Maximum number of spectral peaks
maxnpeak = 80;

% Local threshold (inside frame)
relthres = -100;

% Global threshold (whole sound)
absthres = -120;

paramestflag = 'pow';

causalflag = 'non';

% Partial tracking
ptrackflag = 'p2p';

% Normalize window during analysis (sum(window)==1) and preserve energy upon resynthesis
normflag = true;

% Use zero phase window
zphflag = true;

frequnitflag = true;

npeakflag = false;

% Display
dispflag = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[amp_source,freq_source,ph_source,cframe_source,npartial_source,nsample_source,nframe_source,nchannel_source,dc_source] = ...
    sinusoidal_analysis(tsm_source,framelen,hop,nfft,fs_source,maxnpeak,relthres,absthres,freq_diff_source,winflag,causalflag,paramestflag,ptrackflag,...
    normflag,zphflag,frequnitflag,npeakflag);

% resynth_sin_source = sinusoidal_resynthesis(amp_source,freq_source,ph_source,...
%     framelen,hop,fs_source,nsample_source,cframe_source,npartial_source,nframe_source,delta_harm,...
%     winflag,'non','PI',ptrackflag,dispflag);
%
% tools.wav.srer(tsm_source,tsm_source-resynth_sin_source)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HARMONICS SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp_harm_source,freq_harm_source,ph_harm_source,isharm_source] = ...
    track2harm(amp_source,freq_source,ph_source,npartial_source,...
    nframe_source,ref0_source,delta_harm);

% resynth_harm_source = sinusoidal_resynthesis(amp_harm_source,freq_harm_source,ph_harm_source,...
%     framelen,hop,fs_source,nsample_source,cframe_source,npartial_source,nframe_source,delta_harm,...
%     winflag,'non','PI',ptrackflag,dispflag);
%
% tools.wav.srer(tsm_source,tsm_source-resynth_harm_source)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp_target,freq_target,ph_target,cframe_target,npartial_target,nsample_target,nframe_target,nchannel_target,dc_target] = ...
    sinusoidal_analysis(tsm_target,framelen,hop,nfft,fs_target,maxnpeak,relthres,absthres,freq_diff_target,winflag,causalflag,paramestflag,ptrackflag,...
    normflag,zphflag,frequnitflag,npeakflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HARMONICS TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp_harm_target,freq_harm_target,ph_harm_target,isharm_target] = ...
    track2harm(amp_target,freq_target,ph_target,npartial_target,...
    nframe_target,ref0_target,delta_harm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INTERPOLATE HARMONICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nsample_morph = max(nsample_source,nsample_target);
cframe_morph = cframe_source;
nframe_morph = nframe_source;

[interp_amp,interp_freq] = interp_sin(amp_harm_source,freq_harm_source,...
    ref0_source,npartial_source,amp_harm_target,freq_harm_target,ref0_target,...
    npartial_target,nframe_target,morph_factor,'log');

npartial_morph = size(interp_freq,1);

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
    framelen,hop,fs_morph,nsample_morph,cframe_morph,npartial_morph,nframe_morph,delta_harm,...
    winflag,'non','PRFI',ptrackflag,dispflag);

end
