function measure_range = peak_range(fft_frame,amp,indmaxnpeak,nfft,fs,nframe,nchannel,npeakflag)
%PEAKRANGE Spectral peak range.
%   R = TOOLS.PSEL.PEAK_RANGE(FFTFR,AMP,INDMAXNPEAK,NFFT,Fs,NFRAME,NCHANNEL,NPEAKFLAG)
%   returns the measure of spectral range R for each spectral peak in the
%   FFT frames FFTFR. The measure of spectral range R in dB power is the
%   average difference between the amplitude of a peak AMP and the
%   amplitudes of the spectral troughs immediately to the right and to the
%   left.
%
%   NFFT is the size of the FFT, Fs is the sampling frequency, NFRAME is
%   the number of frames, NCHANNEL is the number of audio channels, and
%   NPEAKFLAG is a logical flag that determines if R has MAXNPEAK or NBIN
%   rows, where MAXNPEAK is the parameter that determines the maximum
%   number of peaks and NBIN is the number of positive frequency bins
%   corresponding to NFFT. NPEAKFLAG = TRUE sets MAXNPEAK and NPEAKFLAG =
%   FALSE sets NBIN.
%
%   FFTFR is an array of size NFFT x NFRAME x NCHANNEL, AMP is an array of
%   size MAXNPEAK x NFRAME x NCHANNEL or NBIN x NFRAME x NCHANNEL depending
%   on NPEAKFLAG. INDMAXNPEAK is an array of size MAXNPEAK x NFRAME x NCHANNEL
%   containing the linear indices of FFTFR that correspond to MAXNPEAK peaks
%   per frame.
%
%   See also PEAK_SHAPE, SPEC_PEAK_SHAPE

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


% TODO: MAKE FUNCTION THAT USES FREQ TO CALCULATE RANGE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(8,8);

% Check number of output arguments
nargoutchk(0,1);

validateattributes(fft_frame,{'numeric'},{'nonempty','finite'},mfilename,'FFRFR',1)
validateattributes(amp,{'numeric'},{'nonempty','real'},mfilename,'AMP',2)
validateattributes(indmaxnpeak,{'numeric'},{'nonempty','integer','real','positive','increasing'},mfilename,'INDMAXNPEAK',3)
validateattributes(nfft,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'NFFT',4)
validateattributes(fs,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'Fs',5)
validateattributes(nframe,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NFRAME',6)
validateattributes(nchannel,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NCHANNEL',7)
validateattributes(npeakflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NPEAKFLAG',8)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ampLeft,ampRight,freqLeft,freqRight] = tools.psel.spec_trough(fft_frame,indmaxnpeak,nfft,fs,nframe,nchannel,npeakflag);

% TODO: INCLUDE MEASURE OF DIFFERENCE THAT ALSO USES FREQUENCY INFORMATION
measure_range = tools.psel.rangediff(amp,ampLeft,ampRight);

end
