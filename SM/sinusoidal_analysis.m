function [amp,freq,ph,center_frame,npartial,nframe,nchannel,nsample,dc] = sinusoidal_analysis(wav,framelen,hop,nfft,fs,...
    winflag,causalflag,normflag,zphflag,...
    paramestflag,maxnpeak,npeakflag,...
    ptrackflag,ptrackalgflag,freqdiff,...
    peakselflag,shapethres,rangethres,relthres,absthres,...
    trackdurflag,durthres,gapthres,...
    harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag)
%SINUSOIDAL_ANALYSIS Perform sinusoidal analysis [1].
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs) splits the input sound S
%   into overlapping frames of length M with a hop size of H, calculates
%   the short-time Fourier transform of S using N as the size of the FFT,
%   and returns the amplitudes A, frequencies F, and phases P of the
%   underlying sinusoids in S. Fs is the sampling frequency of S, which has
%   L samples per channel. A, F, and P are arrays of size NBIN x NFRAME x
%   NCHANNEL, where NBIN is the number of positive frequency bins, NFRAME
%   is the number of frames and NCHANNEL is the number of channels. NBIN is
%   obtained as NBIN = tools.spec.pos_freq_band(N). NOTE: The actual number
%   of rows in A, F, and P will be the number of partials NPART after
%   partial tracking. See below how to control partial tracking with the
%   flag PTRACKFLAG.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG) uses the numeric flag
%   WINFLAG to select the window function used for spectral analysis. Type
%   'help tools.dsp.whichwin' to see the windows available and their
%   corresponding values. The default is WINFLAG = 3, which uses the Hann
%   window.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL) uses the
%   text flag CAUSALFLAG to control the placement of the first analysis
%   window. CAUSALFLAG = 'ANTI' places the first analysis window just
%   before the first sample of the waveform being analyzed, so the
%   rightmost window sample must be shifted by one position to the right
%   to overlap with the first sample of the waveform. CAUSALFLAG = 'NON'
%   places the center of the first analysis window at the first sample
%   of the waveform, so the left half of the window is outside the
%   signal range and the right half of the window overlaps with the
%   waveform. CAUSALFLAG = 'CAUSAL' places the first analysis window
%   entirely overlapping with the waveform being analyzed, so the
%   analysis window starts at the first sample of the waveform. The
%   default is CAUSALFLAG = 'CAUSAL'.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM) uses
%   the logical flag NORMFLAG to normalize the analysis window.
%   NORMFLAG = TRUE normalizes the analysis window and NORMFLAG = FALSE
%   does not. The default is NORMFLAG = TRUE.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH) uses
%   the logical flag ZPHFLAG to specify whether the analysis window has
%   linear phase or zero phase. ZPHFLAG = TRUE uses a zero phase analysis
%   window and ZPHFLAG = FALSE uses a linear phase analysis window. The
%   default is ZPHFLAG = TRUE.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG) uses the text flag PARAMESTFLAG to control the sinusoidal
%   parameter estimation method. PARAMESTFLAG = 'NNE' uses nearest neighbor
%   estimation, PARAMESTFLAG = 'LIN' uses parabolic interpolation over
%   linear scaling of the magnitude spectrum, PARAMESTFLAG = 'LOG' uses
%   parabolic interpolation over log scaling of the magnitude spectrum, and
%   PARAMESTFLAG = 'POW' uses parabolic interpolation over power scaling of
%   the magnitude spectrum. The default is PARAMESTFLAG = 'POW'.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK) returns only the MAXNPEAK peaks with highest
%   spectral energy found in each frame of the STFT as sinusoids in A, F,
%   and P, which are arrays of size MAXNPEAK x NFRAME x NCHANNEL. Note
%   that some frames might have fewer values than MAXNPEAK depending on
%   how many spectral peaks were found in the frame. For example, a frame
%   where S is silence will simply contain MAXNPEAK NaN in A, F, and P.
%   The default is MAXNPEAK = 200. Set MAXNPEAK = Inf to return all the
%   peaks found, which internally sets MAXNPEAK = NBIN.
%   WARNING! MAXNPEAK = Inf causes the analysis to take very long.
%   Typical values for MAXNPEAK are in the range 100-200.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG) uses the logical flag NPEAKFLAG to
%   specify whether to output MAXNPEAK rows instead of NBIN rows for A, F,
%   and P. NPEAKFLAG = TRUE sets MAXNPEAK rows and NPEAKFLAG = FALSE sets
%   NBIN rows. The default is NPEAKFLAG = TRUE. NOTE: MAXNPEAK applies even
%   when NPEAKFLAG = FALSE. In this case, A, F, and P still have NBIN rows
%   with at most MAXNPEAK values per frame (the rest being NaN).
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG) uses the logical flag
%   PTRACKFLAG to enable partial tracking. PTRACKFLAG = TRUE enables it and
%   PTRACKFLAG = FALSE disables it. The default is PTRACKFLAG = TRUE.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG) uses the
%   text flag PTRACKALGFLAG to select the partial tracking algorithm.
%   PTRACKALGFLAG = 'P2P' uses peak-to-peak partial tracking (as described
%   in [1]). The default is PTRACKALGFLAG = 'P2P'.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF) uses
%   FREQDIFF as the maximum frequency interval in Hz around each spectral
%   peak used in the peak-to-peak continuation algorithm. FREQDIFF varies
%   between 0 and Inf Hz. FREQDIFF = 0 does not connect peaks across frames
%   and FREQDIFF = Inf will potentially search for a candidate match across
%   the entire frequency range. The default is FREQDIFF = 20Hz.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG) uses the logical flag PEAKSELFLAG to enable peak selection.
%   PEAKSEKFLAG = TRUE enables peak selection and PEAKSEL = FALSE disables
%   peak selection. The default is PEAKSELFLAG = TRUE. To control each
%   peak selection criterion individually, set their values appropriately
%   and use PEAKSELFLAG = TRUE.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE) uses SHAPE as the threshold for the peak selection
%   by main-lobe shape criterion, which compares the shape of each
%   spectral peak found with the main lobe of the spectral window used
%   modulated by a stationary sinusoid whose frequency is the center
%   frequency of the corresponding spectral peak. SHAPE varies between
%   0 and 1, where 0 means no similarity and 1 strict similarity. The
%   default is SHAPE = 0.8, which works well for sinusoids that are
%   relatively stationary inside each analysis window (e.g., musical
%   instrument sounds). Lower values (0.6 <= SHAPE <= 0.75) might be
%   required for highly nonstationary sinusoids (speech). SHAPE = 0 will
%   retain all spectral peaks. SHAPE = 1 can be used to reject sidelobes
%   in purely synthetic sinusoids when there is no additive noise and the
%   sinusoids are always entirely contained inside the analysis window (to
%   avoid a distorted spectral image). Set SHAPE = 0.9 and MAXNPEAK to the
%   expected number of sinusoids for best results with synthetic sinusoids.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE,RANGE) uses RANGE as the threshold for the peak
%   selection by amplitude range criterion, which measures the difference
%   in amplitude between the peak maximum and each neighboring trough
%   (local minimum) to the left and right of the peak. RANGE varies between
%   0 and Inf dBp (20log10), where RANGE = 0 rejects all peaks and
%   RANGE = Inf ignores the RANGE threshold. The default is RANGE = 20dBp.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE,RANGE,REL) uses REL as the relative threshold for
%   peak selection. The relative threshold compares the maximum of each
%   peak with the maximum of the frame and rejects peaks with relative
%   amplitudes lower than REL, which varies between 0 and -Inf dBp.
%   REL = 0 only keeps the maximum for each frame and REL = -Inf ignores
%   the REL threshold. The default is REL = -100dBp, which rejects
%   sidelobes for the Blackman-Harris window in the absence of additive
%   noise.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE,RANGE,REL,ABS) uses ABS as the absolute threshold
%   for peak selection. The absolute threshold rejects peaks whose
%   amplitudes are below ABS, which varies between 0 and -InfdBp.
%   ABS = 0 only keeps peaks with maximum amplitude and ABS = -Inf ignores
%   the ABS threshold. The default is ABS = -120dBp.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE,RANGE,REL,ABS,TRACKDURFLAG) uses the logical flag
%   TRACKDURFLAG to enable the selection of segments of partials using
%   their time duration as criterion. TRACKDURFLAG = TRUE enables track
%   duration selection and TRACKDURFLAG = FALSE disables it. The default
%   is TRACKDURFLAG = TRUE. To control each track duration criterion
%   individually, set their values appropriately and use
%   TRACKDURFLAG = TRUE.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE,RANGE,REL,ABS,TRACKDURFLAG,DUR) uses DUR as the
%   threshold for the minimum duration of segments of partial tracks.
%   After partial tracking, any segments whose total duration is below
%   DUR will be discarded. DUR varies between 0 and Inf ms. DUR = 0 ignores
%   the duration threshold and DUR = Inf rejects all peaks. The default is
%   DUR = 50ms.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE,RANGE,REL,ABS,TRACKDURFLAG,DUR,GAP) uses GAP as the
%   threshold for the duration of the gaps between segments of partial
%   tracks to connect over. After partial tracking, any segments with gaps
%   whose duration is below GAP before and after will be kept,
%   independently of the duration of the segment (that is, even if the
%   duration of the segment is below DUR). GAP varies between 0 and Inf
%   ms. GAP = 0 does not allow any gaps between segments of partials and
%   GAP = Inf causes DUR to be ignored. The default is GAP = 20ms.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE,RANGE,REL,ABS,TRACKDURFLAG,DUR,GAP,HARMSELFLAG) uses
%   the logical flag HARMSELFLAG to enable harmonic selection of partials.
%   HARMSELFLAG = TRUE enables harmonic selection and HARMSELFLAG = FALSE
%   disables it. The default is HARMSELFLAG = TRUE.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE,RANGE,REL,ABS,TRACKDURFLAG,DUR,GAP,HARMSELFLAG,F0)
%   uses F0 as the fundamental frequency of the harmonic template used in
%   harmonic selection. Set F0 = [] (empty) to force estimation of F0 with
%   SWIPEP [2].
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE,RANGE,REL,ABS,TRACKDURFLAG,DUR,GAP,HARMSELFLAG,F0,
%   TVARF0FLAG) uses the logical flag TVARF0FLAG to enable use of
%   time-varying harmonic template. TVARF0FLAG = TRUE enables it and
%   TVARF0FLAG = FALSE disables it. The default is TVARF0FLAG = FALSE.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE,RANGE,REL,ABS,TRACKDURFLAG,DUR,GAP,HARMSELFLAG,F0,
%   TVARF0FLAG,MAXHARMDEV) uses MAXHARMDEV to set the maximum harmonic
%   deviation from the harmonic template in harmonic selection. MAXHARMDEV
%   is a frequency interval in cents. The default is MAXHARMDEV = 100
%   cents, corresponding to 1 semitone.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE,RANGE,REL,ABS,TRACKDURFLAG,DUR,GAP,HARMSELFLAG,F0,
%   TVARF0FLAG,MAXHARMDEV,HARMTHRESH) uses HARMTHRESH as the harmonic
%   threshold in harmonic selection _after_ partial tracking. HARMTHRESH is
%   ignored if PTRACKFLAG = FALSE. HARMTHRESH varies between 0 and 1, where
%   HARMTHRESH = 0 means that _no_ peaks in a partial must be below
%   MAXHARMDEV to select that partial, and HARMTHRESH = 1 means that _all_
%   peaks in a partial must be below MAXHARMDEV to select that partial. The
%   default is HARMTHRESH = 0.8.
%
%   [A,F,P] = SINUSOIDAL_ANALYSIS(S,M,H,N,Fs,WINFLAG,CAUSAL,NORM,ZPH,
%   PARAMESTFLAG,MAXNPEAK,NPEAKFLAG,PTRACKFLAG,PTRACKALGFLAG,FREQDIFF,
%   PEAKSELFLAG,SHAPE,RANGE,REL,ABS,TRACKDURFLAG,DUR,GAP,HARMSELFLAG,F0,
%   TVARF0FLAG,MAXHARMDEV,HARMTHRESH,HARMALG,HARMPARTFLAG) uses the text
%   flag HARMPARTFLAG to select the algorithm to resolve conflicts in
%   harmonic selection _after_ partial tracking. HARMPARTFLAG is ignored
%   if PTRACKFLAG = FALSE. HARMPARTFLAG = 'COUNT' selects the partials
%   with the highest relative number of harmonic peaks across all frames
%   and HARMPARTFLAG = 'MEAN' selects the partials with the smallest
%   average harmonic distance across all frames. The default is
%   HARMPARTFLAG = 'COUNT'
%
%   [A,F,P,CFR,NPART,NFRAME,NCHANNEL,L,DC] = SINUSOIDAL_ANALYSIS(...) with
%   any of the syntaxes above also returns the array CFR containing the
%   positions of the center of the analysis window (so CFR/Fs is the time
%   vector), the final number of partials (after partial tracking) NPART,
%   the number of frames NFRAME, the number of audio channels NCHANNEL, the
%   total number of samples per channel L, and the DC value of S.
%
%   See also SINUSOIDAL_RESYNTHESIS
%
% [1] McAulay and Quatieri (1986) Speech Analysis/Synthesis Based on a
% Sinusoidal Representation, IEEE TRANSACTIONS ON ACOUSTICS, SPEECH,
% AND SIGNAL PROCESSING, VOL. ASSP-34, NO. 4.
%
% [2] Camacho and Harris (2008) A sawtooth waveform inspired pitch estimator
% for speech and music. J Acoust Soc Am. 124(3), pp. 1638-1652.

% 2016 M Caetano;
% Revised 2019 SMT 0.1.1
% 2020 MCaetano SMT 0.1.2 (Revised)
% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT (Revised)
% 2022 M Caetano
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(5,29);

% Check number of output arguments
nargoutchk(0,9);

defaults = {3, 'causal', true, true,...
    'pow', 200, true,...
    true, 'p2p', 20,...
    true, 0.8, 10, -90, -120,...
    true, 50, 20,...
    false, [], false, 100, 0.8, 'count'};

if nargin == 5
    
    [winflag,causalflag,normflag,zphflag,...
        paramestflag,maxnpeak,npeakflag,...
        ptrackflag,ptrackalgflag,freqdiff,...
        peakselflag,shapethres,rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{1:end};
    
elseif nargin == 6
    
    [causalflag,normflag,zphflag,...
        paramestflag,maxnpeak,npeakflag,...
        ptrackflag,ptrackalgflag,freqdiff,...
        peakselflag,shapethres,rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{2:end};
    
elseif nargin == 7
    
    [normflag,zphflag,...
        paramestflag,maxnpeak,npeakflag,...
        ptrackflag,ptrackalgflag,freqdiff,...
        peakselflag,shapethres,rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{3:end};
    
elseif nargin == 8
    
    [zphflag,...
        paramestflag,maxnpeak,npeakflag,...
        ptrackflag,ptrackalgflag,freqdiff,...
        peakselflag,shapethres,rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{4:end};
    
elseif nargin == 9
    
    [paramestflag,maxnpeak,npeakflag,...
        ptrackflag,ptrackalgflag,freqdiff,...
        peakselflag,shapethres,rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{5:end};
    
elseif nargin == 10
    
    [maxnpeak,npeakflag,...
        ptrackflag,ptrackalgflag,freqdiff,...
        peakselflag,shapethres,rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{6:end};
    
elseif nargin == 11
    
    [npeakflag,...
        ptrackflag,ptrackalgflag,freqdiff,...
        peakselflag,shapethres,rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{7:end};
    
elseif nargin == 12
    
    [ptrackflag,ptrackalgflag,freqdiff,...
        peakselflag,shapethres,rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{8:end};
    
elseif nargin == 13
    
    [ptrackalgflag,freqdiff,...
        peakselflag,shapethres,rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{9:end};
    
elseif nargin == 14
    
    [freqdiff,...
        peakselflag,shapethres,rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{10:end};
    
elseif nargin == 15
    
    [peakselflag,shapethres,rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{11:end};
    
elseif nargin == 16
    
    [shapethres,rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{12:end};
    
elseif nargin == 17
    
    [rangethres,relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{13:end};
    
elseif nargin == 18
    
    [relthres,absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{14:end};
    
elseif nargin == 19
    
    [absthres,...
        trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{15:end};
    
elseif nargin == 20
    
    [trackdurflag,durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{16:end};
    
elseif nargin == 21
    
    [durthres,gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{17:end};
    
elseif nargin == 22
    
    [gapthres,...
        harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{18:end};
    
elseif nargin == 23
    
    [harmselflag,ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{19:end};
    
elseif nargin == 24
    
    [ref0,tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{20:end};
    
elseif nargin == 25
    
    [tvarf0flag,maxharmdev,harmthresh,harmpartflag] =...
        defaults{21:end};
    
elseif nargin == 26
    
    [maxharmdev,harmthresh,harmpartflag] =...
        defaults{22:end};
    
elseif nargin == 27
    
    [harmthresh,harmpartflag] = defaults{23:end};
    
elseif nargin == 28
    
    [harmpartflag] = defaults{24:end};
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Sinusoidal Analysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHORT-TIME FOURIER TRANSFORM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Short-Time Fourier Transform from namespace STFT
[fft_frame,center_frame,nsample,nframe,nchannel,dc] = tools.stft.stft(wav,framelen,hop,nfft,winflag,causalflag,normflag,zphflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL PARAMETER ESTIMATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Estimate frequencies in Hz
frequnitflag = true;

% Estimation of parameters of sinusoids
[amplitude,frequency,phase,indmaxnpeak] = sinusoidal_parameter_estimation(fft_frame,framelen,nfft,fs,nframe,nchannel,maxnpeak,winflag,paramestflag,frequnitflag,npeakflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PEAK SELECTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if peakselflag
    
    disp('Peak selection')
    
    [amplitude,frequency,phase] = sinusoidal_peak_selection(fft_frame,amplitude,frequency,phase,indmaxnpeak,...
        framelen,nfft,fs,nframe,nchannel,winflag,maxnpeak,shapethres,rangethres,relthres,absthres,normflag,zphflag,npeakflag);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIAL TRACKING & MINIMUM DURATION & HARMONIC SELECTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if harmselflag && isempty(ref0)
    
    f0 = swipep_mod(wav,fs,[75 500],1000/fs,[],1/20,0.5,0.2);
    
    % Reference f0
    ref0 = tools.f0.reference_f0(f0);
    
end

% Handle partial tracking
if ptrackflag && ~trackdurflag && ~harmselflag
    
    disp('Partial tracking')
    
    [amp,freq,ph,npartial] = partial_tracking(amplitude,frequency,phase,freqdiff,hop,fs,nframe,ptrackalgflag);
    
elseif ptrackflag && ~trackdurflag && harmselflag
    
    disp('Partial tracking')
    
    [amplitude,frequency,phase,npartial] = partial_tracking(amplitude,frequency,phase,freqdiff,hop,fs,nframe,ptrackalgflag);
    
    disp('Harmonic Selection')
    
    [amp,freq,ph,npartial] = harmonic_selection(amplitude,frequency,phase,...
        npartial,nframe,nchannel,ref0,maxharmdev,harmthresh,'part',harmpartflag,tvarf0flag);
    
elseif ptrackflag && trackdurflag && ~harmselflag
    
    disp('Partial tracking')
    
    [amplitude,frequency,phase,npartial] = partial_tracking(amplitude,frequency,phase,freqdiff,hop,fs,nframe,ptrackalgflag);
    
    disp('Minimum duration')
    
    [amp,freq,ph] = partial_track_duration(amplitude,frequency,phase,hop,fs,npartial,nframe,nchannel,durthres,gapthres,'ms');
    
elseif ptrackflag && trackdurflag && harmselflag
    
    disp('Partial tracking')
    
    [amplitude,frequency,phase,npartial] = partial_tracking(amplitude,frequency,phase,freqdiff,hop,fs,nframe,ptrackalgflag);
    
    disp('Minimum duration')
    
    [amplitude,frequency,phase] = partial_track_duration(amplitude,frequency,phase,hop,fs,npartial,nframe,nchannel,durthres,gapthres,'ms');
    
    disp('Harmonic Selection')
    
    [amp,freq,ph,npartial] = harmonic_selection(amplitude,frequency,phase,...
        npartial,nframe,nchannel,ref0,maxharmdev,harmthresh,'part',harmpartflag,tvarf0flag);
    
elseif ~ptrackflag && harmselflag
    
    disp('Harmonic Selection')
    
    [amp,freq,ph,npartial] = harmonic_selection(amplitude,frequency,phase,...
        maxnpeak,nframe,nchannel,ref0,maxharmdev,harmthresh,'peak',harmpartflag,tvarf0flag);
    
else
    
    % Spectral peaks
    amp = amplitude;
    freq = frequency;
    ph = phase;
    npartial = maxnpeak;
    
end

end
