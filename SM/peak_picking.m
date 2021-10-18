function [peakamp,peakfreq,peakph] = peak_picking(magspec,phspec,nfft,fs,nframe,freqlimflag,funitflag)
% PEAK_PICKING amplitudes, frequencies, and phases of the spectral peaks.
%   [A,F,P] = PEAK_PICKING(MAG,PH,NFFT,Fs,NFRAME) returns the amplitudes A,
%   the frequencies F, and the phases P corresponding to the peaks of the
%   DFT spectrum. MAG is the magnitude spectrum, PH is the phase spectrum,
%   NFFT is the size of the FFT, and Fs is the sampling frequency.
%
%   MAG is used to return A, PH is used to return P in radians, and NFFT
%   and Fs are used to return F in Hertz. Both MAG and PH only have the
%   non-negative frequency half of the DFT spectrum (from 0 to Nyquist), so
%   both are size NBIN x NFRAME, where NBIN = NFFT/2+1.
%
%   A, F, and P are used in the magnitude and phase interpolation steps of
%   sinusoidal analysis. A, F, and P are structures with fields PREV, PEAK,
%   and NEXT. For example, F.PEAK contains the frequencies of the spectral
%   peaks, F.PREV contains the frequencies of its immediate neighbors to
%   the left, and F.NEXT the immediate neighbor to the right. A, F, and P
%   contain NaN for positions that do not correspond to peaks.
%
%   [A,F,P] = PEAK_PICKING(MAG,PH,NFFT,Fs,NFRAME,FLIMFLAG) uses the text
%   flag FREQLIMFLAG to control the limits of the frequency axis.
%   FREQLIMFLAG can be 'POS', 'FULL', or 'NEGPOS'. The default is
%   FREQLIMGLAG = 'POS' when PEAKPICKING is called with the previous
%   syntaxes.
%
%   FREQLIMFLAG = 'POS' generates frequencies from 0 to Nyquist. Use 'POS'
%   to get the positive half of the spectrum.
%
%   FREQLIMFLAG = 'FULL' generates frequencies from 0 to NFFT-1. Use 'FULL'
%   to get the full frequency range output by the FFT.
%
%   FREQLIMFLAG = 'NEGPOS' generates the negative and positive halves. Use
%   'NEGPOS' to get the full frequency range with the zero-frequency
%   component in the middle of the spectrum. Use FFTFLIP to plot the
%   spectrum.
%
%   [A,F,P] = PEAK_PICKING(MAG,PH,NFFT,Fs,NFRAME,FUNITFLAG) uses the
%   logical flag FUNITFLAG to control the unit of the frequencies F.
%   FUNITFLAG = TRUE returns frequencies in Hz and FUNITFLAG = FALSE
%   returns frequencies in spectral bins. The default is FUNITFLAG = TRUE.
%
%   See also FIND_SPEC_PEAK, QUAD_INTERP, PHASE_INTERP

% 2016 M Caetano;
% Revised 2019 SMT 0.1.1
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(5,7);

% Check number of output arguments
nargoutchk(0,3);

if nargin == 5
    
    freqlimflag = 'pos';
    
    funitflag = true;
    
elseif nargin == 6
    
    funitflag = true;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Temporary variable
[~,~,nchannel] = size(magspec);

% Find logical indices of spectral peaks
[iprev,ipeak,inext] = find_spec_peak(magspec);

% Frequency bins
[freqbin,nbin] = tools.spec.mkfreqbin(nfft,fs,nframe,nchannel,freqlimflag,funitflag);

% Initialize amplitudes (NaN)
peakamp = struct('peak',nan(nbin,nframe,nchannel),'prev',nan(nbin,nframe,nchannel),'next',nan(nbin,nframe,nchannel));

% Initialize frequencies (NaN)
peakfreq = struct('peak',nan(nbin,nframe,nchannel),'prev',nan(nbin,nframe,nchannel),'next',nan(nbin,nframe,nchannel));

% Initialize phases (NaN)
peakph = struct('peak',nan(nbin,nframe,nchannel),'prev',nan(nbin,nframe,nchannel),'next',nan(nbin,nframe,nchannel));

% Magnitude of peaks (scaled)
peakamp.peak(ipeak) = magspec(ipeak);
peakamp.prev(ipeak) = magspec(iprev);
peakamp.next(ipeak) = magspec(inext);

% Frequency of peaks (bin or Hz)
peakfreq.peak(ipeak) = freqbin(ipeak);
peakfreq.prev(ipeak) = freqbin(iprev);
peakfreq.next(ipeak) = freqbin(inext);

% Phase of peaks (rad)
peakph.peak(ipeak) = phspec(ipeak);
peakph.prev(ipeak) = phspec(iprev);
peakph.next(ipeak) = phspec(inext);

end
