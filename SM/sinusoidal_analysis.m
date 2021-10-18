function [amp,freq,ph,center_frame,npartial,nsample,nframe,nchannel,dc] = sinusoidal_analysis(wav,framelen,hop,nfft,fs,maxnpeak,relthres,absthres,delta,...
    winflag,causalflag,paramestflag,ptrackflag,normflag,zphflag,frequnitflag,npeakflag)
%SINUSOIDAL_ANALYSIS Perform sinusoidal analysis [1].
%   [A,F,P,CFR,NPART,NSAMPLE,NFRAME,NCHANNEL,DC] = SINUSOIDAL_ANALYSIS(S,M,
%   H,NFFT,FS,MAXNPEAK,RELTHRES,ABSTHRES,DELTA,WINFLAG,CAUSALFLAG,
%   PARAMESTFLAG) splits the input sound S into overlapping frames of length
%   M with a hop size H and returns the amplitudes A, frequencies F, and
%   phases P of the partials assumed to be the MAXNPEAK peaks with maximum
%   power spectral amplitude. NFFT is the size of the FFT used for stectral
%   analysis and Fs is the sampling frequency.
%
%   RELTHRES is a numeric value in dB that sets the minumum spectral energy
%   of a peak (relative to the maximum energy inside the frame) to be
%   included among the output spectral peaks. Spectral peaks whose relative
%   energy is lower than RELTHRES dB are discarded. Set RELTHRES = -Inf to
%   turn off the relative threshold RELTHRES.
%
%   ABSTHRES is a numeric value in dB that sets the minumum spectral energy
%   of a peak (relative to the maximum energy of the entire waveform) to be
%   included among the output spectral peaks. Spectral peaks whose absolute
%   energy is lower than ABSTHRES dB are discarded. Set ABSTHRES = -Inf to
%   turn off the absolute threshold ABSTHRES.
%
%   DELTA sets the frequency interval in Hz around each spectral peak used
%   in the peak-to-peak continuation algorithm (also P2P partial tracking).
%
%   WINFLAG is a numerical flag that controls the window used. Type HELP
%   WHICHWIN to see the possibilities.
%
%   CAUSALFLAG controls the placement of the first analysis window
%   CAUSALFLAG = 'NCAUSAL' places the first analysis window just before the
%   first sample of the waveform being analyzed, so the rightmost window
%   sample must be shifted by one position to the right to overlap with the
%   first sample of the waveform.
%   CAUSALFLAG = 'NON' places the sample at the center of the first analysis
%   window at the first sample of the waveform, so the left half of the
%   window is outside the signal range and the right half of the window
%   overlaps with the waveform.
%   CAUSALFLAG = 'CAUSAL' places the first analysis window entirely
%   overlapping with the waveform being analyzed, so the leftmost window
%   sample coincides with the first sample of the waveform.
%
%   PARAMESTFLAG controls the scaling of the magnitude spectrum for
%   parameter estimation.
%   PARAMESTFLAG = 'NNE' uses nearest neighbor estimation
%   PARAMESTFLAG = 'LIN' uses parabolic interpolation over linear scaling
%   PARAMESTFLAG = 'LOG' uses parabolic interpolation over log scaling
%   PARAMESTFLAG = 'POW' uses parabolic interpolation over power scaling
%
%   [A,F,P,CFR,NPART,NSAMPLE,NFRAME,NCHANNEL,DC] = SINUSOIDAL_ANALYSIS(S,M,
%   H,NFFT,FS,MAXNPEAK,RELTHRES,ABSTHRES,DELTA,WINFLAG,CAUSALFLAG,
%   PARAMESTFLAG,PTRACKFLAG) uses the text flag PTRACKFLAG to control
%   partial tracking. PTRACKFLAG = 'P2P' uses peak-to-peak partial
%   tracking and PTRACKFLAG = '' (empty string) specifies no partial
%   tracking. The default is PTRACKFLAG = '' for no partial tracking.
%
%   [A,F,P,CFR,NPART,NSAMPLE,NFRAME,NCHANNEL,DC] = SINUSOIDAL_ANALYSIS(S,M,
%   H,NFFT,FS,MAXNPEAK,RELTHRES,ABSTHRES,DELTA,WINFLAG,CAUSALFLAG,
%   PARAMESTFLAG,PTRACKFLAG,NORMFLAG) uses the logical flag NORMFLAG to
%   control normalization of the analysis window. NORMFLAG = TRUE
%   normalizes the analysis window and NORMFLAG = FALSE does not. The
%   default is NORMFLAG = TRUE.
%
%   [A,F,P,CFR,NPART,NSAMPLE,NFRAME,NCHANNEL,DC] = SINUSOIDAL_ANALYSIS(S,M,
%   H,NFFT,FS,MAXNPEAK,RELTHRES,ABSTHRES,DELTA,WINFLAG,CAUSALFLAG,
%   PARAMESTFLAG,PTRACKFLAG,NORMFLAG,ZPHFLAG) uses the logical flag ZPHFLAG
%   to specify whether the analysis window has linear phase or zero phase.
%   ZPHFLAG = TRUE uses a zero phase analysis window and ZPHFLAG = FALSE
%   uses a linear phase analysis window. The default is ZPHFLAG = TRUE.
%
%   [A,F,P,CFR,NPART,NSAMPLE,NFRAME,NCHANNEL,DC] = SINUSOIDAL_ANALYSIS(S,M,
%   H,NFFT,FS,MAXNPEAK,RELTHRES,ABSTHRES,DELTA,WINFLAG,CAUSALFLAG,
%   PARAMESTFLAG,PTRACKFLAG,NORMFLAG,ZPHFLAG,FREQUNITFLAG) uses the logical
%   flag FREQUNITFLAG to control the unit of the frequency estimates.
%   FREQUNITFLAG = TRUE estimates frequencies in Hz directly and
%   FREQUNITFLAG = FALSE estimates in frequency bin number prior to
%   conversion to Hz. The default is FREQUNITFLAG = TRUE.
%
%   [A,F,P,CFR,NPART,NSAMPLE,NFRAME,NCHANNEL,DC] = SINUSOIDAL_ANALYSIS(S,M,
%   H,NFFT,FS,MAXNPEAK,RELTHRES,ABSTHRES,DELTA,WINFLAG,CAUSALFLAG,
%   PARAMESTFLAG,PTRACKFLAG,NORMFLAG,ZPHFLAG,FREQUNITFLAG,NPEAKFLAG) uses
%   the logical flag NPEAKFLAG to specify whether the estimation of
%   parameters should output MAXNPEAK rows instead of NBIN rows, where NBIN
%   is the number of positive frequency bins. NPEAKFLAG = TRUE sets
%   MAXNPEAK and NPEAKFLAG = FALSE sets NBIN rows. The default is
%   NPEAKFLAG = FALSE.
%
%   See also SINUSOIDAL_RESYNTHESIS
%
% [1] McAulay and Quatieri (1986) Speech Analysis/Synthesis Based on a
% Sinusoidal Representation, IEEE TRANSACTIONS ON ACOUSTICS, SPEECH,
% AND SIGNAL PROCESSING, VOL. ASSP-34, NO. 4.

% 2016 M Caetano;
% Revised 2019 SMT 0.1.1
% 2020 MCaetano SMT 0.1.2 (Revised)
% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(12,17);

% Check number of output arguments
nargoutchk(0,9);

if nargin == 12
    
    ptrackflag = '';
    
    normflag = true;
    
    zphflag = true;
    
    frequnitflag = true;
    
    npeakflag = false;
    
elseif nargin == 13
    
    normflag = true;
    
    zphflag = true;
    
    frequnitflag = true;
    
    npeakflag = false;
    
elseif nargin == 14
    
    zphflag = true;
    
    frequnitflag = true;
    
    npeakflag = false;
    
elseif nargin == 15
    
    frequnitflag = true;
    
    npeakflag = false;
    
elseif nargin == 16
    
    npeakflag = false;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Sinusoidal Analysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHORT-TIME FOURIER TRANSFORM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Short-Time Fourier Transform from namespace STFT
[fft_frame,center_frame,nsample,nframe,nchannel,dc] = STFT.stft(wav,framelen,hop,nfft,winflag,causalflag,normflag,zphflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL PARAMETER ESTIMATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Estimation of parameters of sinusoids
[amplitude,frequency,phase] = sinusoidal_parameter_estimation(fft_frame,framelen,nfft,fs,nframe,nchannel,maxnpeak,winflag,paramestflag,frequnitflag,npeakflag);

if ~frequnitflag
    
    frequency = tools.spec.bin2freq(frequency,fs,nfft);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPECTRAL POST-PROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Apply absolute threshold
[amplitude,frequency,phase] = absdb(amplitude,frequency,phase,absthres);

% Apply relative threshold
[amplitude,frequency,phase] = reldb(amplitude,frequency,phase,relthres);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIAL TRACKING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Handle partial tracking
if ~isempty(ptrackflag)
    
    [amp,freq,ph,npartial] = partial_tracking(amplitude,frequency,phase,delta,hop,fs,nframe,ptrackflag);
    
else
    
    % Spectral peaks
    amp = amplitude;
    freq = frequency;
    ph = phase;
    npartial = maxnpeak;
    
end

end
