function [amp,freq,ph] = sinusoidal_peak_selection(fft_frame,amp,freq,ph,indmaxnpeak,framelen,nfft,fs,nframe,nchannel,...
    winflag,maxnpeak,shapethres,rangethres,relthres,absthres,normflag,zphflag,npeakflag)
%SINUSOIDAL_PEAK_SELECTION Selection of spectral peaks as sinusoids.
%   [AMP,FREQ,PH] = SINUSOIDAL_PEAK_SELECTION(FFTFR,A,F,P,IND,M,N,Fs,NFRAME,NCHANNEL,MAXNPEAK,
%   SHAPETHRES,RANGETHRES,RELTHRES,ABSTHRES,WINFLAG,NORMFLAG,ZPHFLAG,NPEAKFLAG)
%   returns the amplitudes AMP, frequencies FREQ, and phases PH of the spectral
%   peaks selected as sinusoids according to spectral shape, amplitude range of
%   peaks, relative amplitudes of peaks within each frame, and absolute amplitude
%   of peaks.
%
%   The FFT frames FFTFR and the estimations of the amplitudes A,
%   frequencies F, and phases P of each spectral peak are used to
%   compute the measures.
%
%   The measure of spectral shape compares the shape
%   of each peak with the theoretical DFT of the window determined by
%   WINDOWFLAG modulated by a sinusoid with amplitude A, frequency F, and
%   phase P around NBINSPAN bins of F. The normalized dot product between
%   the peak in FFTFR and the theoretical peak is the final measure. The
%   default is 0.8. Higher values remove more noisy peaks but may also
%   introduce artifacts by removing sinusoids.
%
%   The measure of spectral range uses the average of the difference in
%   amplitude between the spectral peak and the troughs to its left- and
%   right-hand sides. The default is 10dB. Higher values remove more noisy
%   peaks but may also introduce artifacts by removing sinusoids.
%
%   The relative amplitude of each peak is a measure of its amplitude in dB
%   using the amplitude of the maximum peak in that frame as reference. The
%   default is -100dB. Values closer to 0 remove more noise but may also
%   introduce artifacts by removing sinusoids.
%
%   The absolute amplitude of each peak is a measure of its amplitude in
%   dB using 0dB as reference. The default is -120dB. Values closer to 0
%   remove more noise but may also introduce artifacts by removing
%   sinusoids.
%
%   The peaks are selected using the thresholds:
%
%   SHAPETHRES spectral shape threshold (normalized)
%   RANGETHRES spectral range threshold (dB power)
%   RELTHRES relative amplitude threshold (dB power)
%   ABSTHRES absolute amplitude threshold (dB power)
%
%   See also PEAKSEL, PEAK_SHAPE, PEAK_RANGE, PEAK_RELDB

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(10,19);

% Check number of output arguments
nargoutchk(0,3);

defaults = {3, 200, 0.8, 10, -100, -120, true, true, true};

if nargin == 10
    
    [winflag,maxnpeak,shapethres,rangethres,relthres,absthres,normflag,zphflag,npeakflag] = defaults{1:end};
    
elseif nargin == 11
    
    [maxnpeak,shapethres,rangethres,relthres,absthres,normflag,zphflag,npeakflag] = defaults{2:end};
    
elseif nargin == 12
    
    [shapethres,rangethres,relthres,absthres,normflag,zphflag,npeakflag] = defaults{3:end};
    
elseif nargin ==13
    
    [rangethres,relthres,absthres,normflag,zphflag,npeakflag] = defaults{4:end};
    
elseif nargin == 14
    
    [relthres,absthres,normflag,zphflag,npeakflag] = defaults{5:end};
    
elseif nargin == 15
    
    [absthres,normflag,zphflag,npeakflag] = defaults{6:end};
    
elseif nargin == 16
    
    [normflag,zphflag,npeakflag] = defaults{7:end};
    
elseif nargin == 17
    
    [zphflag,npeakflag] = defaults{8:end};
    
elseif nargin == 18
    
    [npeakflag] = defaults{9:end};
    
end

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
validateattributes(winflag,{'numeric'},{'scalar','integer','nonempty','>=',1,'<=',8},mfilename,'WINFLAG',11)
validateattributes(maxnpeak,{'numeric'},{'nonempty','scalar','real','positive'},mfilename,'MAXNPEAK',12)
validateattributes(shapethres,{'numeric'},{'nonempty','scalar','real','>=',0,'<=',1},mfilename,'SHAPETHRES',13)
validateattributes(rangethres,{'numeric'},{'nonempty','scalar','real'},mfilename,'RANGETHRES',14)
validateattributes(relthres,{'numeric'},{'nonempty','scalar','real'},mfilename,'RELTHRES',15)
validateattributes(absthres,{'numeric'},{'nonempty','scalar','real'},mfilename,'ABSTHRES',16)
validateattributes(normflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NORMFLAG',17)
validateattributes(zphflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'ZPHFLAG',18)
validateattributes(npeakflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NPEAKFLAG',19)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Range of frequency bins around peak
nbinspan = 6;

% Flag to specify frequency sign of signal (only applies to complex signals)
posfreqflag = true;

% Flag to generate the DFT of a real signal
realsigflag = true;

% Flag to normalize the dot product
normdprodflag = true;

[amp,freq,ph] = tools.psel.peaksel(fft_frame,amp,freq,ph,indmaxnpeak,framelen,nfft,fs,nframe,nchannel,...
    winflag,maxnpeak,nbinspan,shapethres,rangethres,relthres,absthres,normflag,zphflag,posfreqflag,...
    realsigflag,npeakflag,normdprodflag);

end
