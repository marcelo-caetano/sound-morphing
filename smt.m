function [sin_harm_morph] = smt(source_path,target_path,morph_factor)
%SMT Sound morphing toolbox
%   M = SMT(S,T,ALPHA) generates the morph M between the source S and the
%   target T according to the morphing factor ALPHA. ALPHA is between 0 and
%   1. When ALPHA=0 M=S and when ALPHA=1 M=T. Intermediate values of ALPHA
%   generate M between S and T.

% 2019 M Caetano

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load source sound
[audio_source,sr_source] = audioread(source_path);

% Get total number of samples
nsample_source = length(audio_source);

% Downmix from stereo to mono
audio_source = stereo2mono(audio_source);

% Fundamental frequency of source sound
f0_source = swipep_mod(audio_source,sr_source,[75 500],...
    1000/sr_source,[],1/20,0.5,0.2);

% Reference f0 of source sound
ref0_source = median(f0_source(not(isnan(f0_source))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load target sound
[audio_target,sr_target] = audioread(target_path);

% Get total number of samples
nsample_target = length(audio_target);

% Downmix from stereo to mono
audio_target = stereo2mono(audio_target);

% Fundamental frequency of target sound
f0_target = swipep_mod(audio_target,sr_target,[75 500],1000/sr_target,[],1/20,0.5,0.2);

% Reference f0 of target sound
ref0_target = median(f0_target(not(isnan(f0_target))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TIME SCALE MODIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Overlap
tsm_winoverlap = 220; % 5 ms

% Synthesis hop size >= tsm_winoverlap (smallest == tsm_winoverlap)
tsm_synth_hopsize = 2*tsm_winoverlap;

% Window (frame) size (smallest 2*tsm_winoverlap)
tsm_winsize = 3*tsm_winoverlap;

% Kmax >= T0
Kmax = 600; % 13.6 ms

% Interpolated duration
nsample_morph = fix((nsample_source + nsample_target)/2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TSM SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TSM factor source sound
tsmfactor_source = nsample_morph/nsample_source;

% TSM source sound
tsm_source = solafs(audio_source,tsm_synth_hopsize,tsm_winsize,'half',Kmax,tsmfactor_source);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TSM TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TSM factor target sound
tsmfactor_target = nsample_morph/nsample_target;

% TSM target sound
tsm_target = solafs(audio_target,tsm_synth_hopsize,tsm_winsize,'half',Kmax,tsmfactor_target);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRE-PROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zeropad shorter sound to duration of longer one
[tsm_source,tsm_target] = zp2max(tsm_source,tsm_target);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHORT-TIME FOURIER TRANSFORM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% winsize = 3*T0
winsize = max(fix(3*sr_source/ref0_source),fix(3*sr_target/ref0_target));

% 50% overlap
hopsize = fix(winsize/2);

% Size of the FFT
nfft = 2^nextpow2(winsize);

% Normalize window during analysis (sum(window)==1) and preserve energy upon resynthesis
normflag = 1;

% Use zero phase window
zphflag = 1;

% Hamming analysis window
wintype = 3;

% Frequency difference for peak matching (Hz)
freq_diff_peak_match = 10;

% Maximum number of spectral peaks
maxnpeak = 80;

% Local threshold (inside frame)
thresframe = 66;

% Global threshold (whole sound)
threstotal = 66;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sin_harm_morph ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sin_harm_morph ANALYSIS SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[amp_source,freq_source,ph_source,dur_source,dcval_source,cframe_source] = ...
    sinusoidal_analysis(tsm_source,hopsize,winsize,wintype,nfft,...
    sr_source,'one',normflag,zphflag,'log',maxnpeak,thresframe,threstotal);

% Number of frames source
nframe_source = length(cframe_source);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIAL TRACKING SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp_track_source,freq_track_source,ph_track_source,ntrack_source] = ...
    peak2track(amp_source,freq_source,ph_source,nframe_source,maxnpeak,...
    nfft,sr_source,fix(0.25*ref0_source));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HARMONICS SOURCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp_harm_source,freq_harm_source,ph_harm_source,isharm_source] = ...
    track2harm(amp_track_source,freq_track_source,ph_track_source,...
    ntrack_source,nframe_source,ref0_source,freq_diff_peak_match);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sin_harm_morph ANALYSIS TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp_target,freq_target,ph_target,dur_target,dcval_target,cframe_target] = ...
    sinusoidal_analysis(tsm_target,hopsize,winsize,wintype,nfft,...
    sr_target,'one',normflag,zphflag,'log',maxnpeak,thresframe,threstotal);

% Number of frames
nframe_target = length(cframe_target);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIAL TRACKING TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[amp_track_target,freq_track_target,ph_track_target,ntrack_target] = ...
    peak2track(amp_target,freq_target,ph_target,nframe_target,maxnpeak,nfft,...
    sr_target,fix(0.25*ref0_target));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HARMONICS TARGET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp_harm_target,freq_harm_target,ph_harm_target,isharm_target] = ...
    track2harm(amp_track_target,freq_track_target,ph_track_target,...
    ntrack_target,nframe_target,ref0_target,freq_diff_peak_match);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INTERPOLATE part_harm_morph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[interp_amp,interp_freq] = interp_sin(amp_harm_source,freq_harm_source,...
    ref0_source,ntrack_source,amp_harm_target,freq_harm_target,ref0_target,...
    ntrack_target,nframe_target,morph_factor);

interp_phase = zeros(size(interp_freq));

[amp_harm_morph,freq_harm_morph,ph_harm_morph] = ...
    track2peak(interp_amp,interp_freq,interp_phase,nframe_target);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sin_harm_morph RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sr_morph = 44100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRFI RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[sin_harm_morph,part_harm_morph,amp_part_morph,freq_part_morph] = ...
    sinusoidal_resynthesis(amp_harm_morph,freq_harm_morph,ph_harm_morph,...
    freq_diff_peak_match,hopsize,winsize,wintype,sr_morph,dur_target,cframe_source,'one','PRFI',maxnpeak);

end