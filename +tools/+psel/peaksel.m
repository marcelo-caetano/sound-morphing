function [amp,freq,ph] = peaksel(fft_frame,amp,freq,ph,indmaxnpeak,framelen,nfft,fs,nframe,nchannel,...
    winflag,maxnpeak,nbinspan,shapethres,rangethres,relthres,absthres,normflag,zphflag,...
    posfreqflag,realsigflag,npeakflag,normdprodflag)
%PEAKSEL Selection of spectral as sinusoids.
%   [AMP,FREQ,PH] = PEAKSEL(FFTFR,A,F,P,IND,M,N,Fs,NFRAME,NCHANNEL,MAXNPEAK,NBINSPAN,
%   SHAPETHRES,RANGETHRES,RELTHRES,ABSTHRES,WINFLAG,NORMFLAG,ZPHFLAG,POSFREQFLAG,
%   REALSIGFLAG,NPEAKFLAG,NORMDPRODFLAG) returns the amplitudes AMP,
%   frequencies FREQ, and phases PH of the spectral peaks selected as sinusoids
%   according to spectral shape, amplitude range of peaks, relative
%   amplitudes of peaks within each frame, and absolute amplitude of peaks.
%
%   The FFT frames FFTFR and the estimations of the amplitudes A,
%   frequencies F, and phases P of each spectral peak are used to
%   compute the measures.
%
%   The measure of spectral shape compares the shape
%   of each peak with the theoretical DFT of the window determined by
%   WINDOWFLAG modulated by a sinusoid with amplitude A, frequency F, and
%   phase P around NBINSPAN bins of F. The normalized dot product between
%   the peak in FFTFR and the theoretical peak is the final measure.
%
%   The measure of spectral range uses the average of the difference in
%   amplitude between the spectral peak and the troughs to its left- and
%   right-hand sides.
%
%   The relative amplitude of each peak is a measure of its amplitude in dB
%   using the amplitude of the maximum peak in that frame as reference.
%
%   The absolute amplitude of each peak is a measure of its amplitude in
%   dB using 0dB as reference.
%
%   The peaks are selected using the thresholds:
%
%   SHAPETHRES spectral shape threshold (normalized)
%   RANGETHRES spectral range threshold (dB power)
%   RELTHRES relative amplitude threshold (dB power)
%   ABSTHRES absolute amplitude threshold (dB power)
%
%   See also SINUSOIDAL_PEAK_SELECTION, PEAK_SHAPE, PEAK_RANGE, PEAK_RELDB

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(23,23);

% Check number of output arguments
nargoutchk(0,3);

validateattributes(fft_frame,{'numeric'},{'nonempty','finite'},mfilename,'FFRFR',1)
validateattributes(amp,{'numeric'},{'nonempty','real'},mfilename,'AMP',2)
validateattributes(freq,{'numeric'},{'nonempty','real'},mfilename,'FREQ',3)
validateattributes(ph,{'numeric'},{'nonempty','real'},mfilename,'PH',4)
validateattributes(indmaxnpeak,{'numeric'},{'nonempty','integer','real','positive','increasing'},mfilename,'INDMAXNPEAK',5)
validateattributes(framelen,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'FRAMELEN',6)
validateattributes(nfft,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'NFFT',7)
validateattributes(fs,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'Fs',8)
validateattributes(nframe,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NFRAME',9)
validateattributes(nchannel,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NCHANNEL',10)
validateattributes(maxnpeak,{'numeric'},{'nonempty','scalar','real','positive'},mfilename,'MAXNPEAK',11)
validateattributes(nbinspan,{'numeric'},{'nonempty','scalar','integer','real','positive'},mfilename,'NBINSPAN',12)
validateattributes(shapethres,{'numeric'},{'nonempty','scalar','real','>=',0,'<=',1},mfilename,'SHAPETHRES',13)
validateattributes(rangethres,{'numeric'},{'nonempty','scalar','real'},mfilename,'RANGETHRES',14)
validateattributes(relthres,{'numeric'},{'nonempty','scalar','real'},mfilename,'RELTHRES',15)
validateattributes(absthres,{'numeric'},{'nonempty','scalar','real'},mfilename,'ABSTHRES',16)
validateattributes(winflag,{'numeric'},{'scalar','integer','nonempty','>=',1,'<=',8},mfilename,'WINFLAG',17)
validateattributes(normflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NORMFLAG',18)
validateattributes(zphflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'ZPHFLAG',19)
validateattributes(posfreqflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'POSFREQFLAG',20)
validateattributes(realsigflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'REALSIGFLAG',21)
validateattributes(npeakflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NPEAKFLAG',22)
validateattributes(normdprodflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NORMDPRODFLAG',23)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MEASURE OF SHAPE OF PEAKS OF MAGNITUDE SPECTRUM (NORMALIZED)
measure_shape = tools.psel.peak_shape(fft_frame,amp,freq,ph,framelen,nfft,fs,nframe,nchannel,maxnpeak,nbinspan,winflag,...
    posfreqflag,realsigflag,normflag,zphflag,npeakflag,normdprodflag);

% MEASURE OF AMPLITUDE RANGE OF PEAKS OF LOG MAGNITUDE SPECTRUM (dB Power)
measure_range = tools.psel.peak_range(fft_frame,amp,indmaxnpeak,nfft,fs,nframe,nchannel,npeakflag);

% RELATIVE MEASURE OF AMPLITUDE (REFERENCE IS MAX/FRAME) (dB Power)
measure_reldb = tools.psel.peak_reldb(amp);

% ABSOLUTE MEASURE OF AMPLITUDE (dB Power)
measure_absdb = tools.math.lin2log(amp,'dbp');

% APPLY THRESHOLD
bool_shape = measure_shape < shapethres;

bool_range = measure_range < abs(rangethres);

bool_reldb = measure_reldb < -abs(relthres);

bool_absdb = measure_absdb < -abs(absthres);

% COMBINE SELECTION CRITERIA
bool = bool_shape | bool_range | bool_reldb | bool_absdb;

amp(bool) = nan(1);
freq(bool) = nan(1);
ph(bool) = nan(1);

end
