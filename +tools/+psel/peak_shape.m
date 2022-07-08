function measure_shape = peak_shape(fft_frame,amp,freq,ph,framelen,nfft,fs,nframe,nchannel,maxnpeak,nbinspan,winflag,...
    posfreqflag,realsigflag,normflag,zphflag,npeakflag,normdprodflag)
%PEAK_SHAPE
%   Detailed explanation goes here

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(18,18);

% Check number of output arguments
nargoutchk(0,1);

% TODO: VALIDATE ARGUMENTS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validateattributes(fft_frame,{'numeric'},{'nonempty','finite'},mfilename,'FFRFR',1)
validateattributes(amp,{'numeric'},{'nonempty','real'},mfilename,'AMP',2)
validateattributes(freq,{'numeric'},{'nonempty','real'},mfilename,'FREQ',3)
validateattributes(ph,{'numeric'},{'nonempty','real'},mfilename,'PH',4)
validateattributes(framelen,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'FRAMELEN',5)
validateattributes(nfft,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'NFFT',6)
validateattributes(fs,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'Fs',7)
validateattributes(nframe,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NFRAME',8)
validateattributes(nchannel,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NCHANNEL',9)
validateattributes(maxnpeak,{'numeric'},{'nonempty','scalar','real','positive'},mfilename,'MAXNPEAK',10)
validateattributes(nbinspan,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NBINSPAN',11)
validateattributes(winflag,{'numeric'},{'scalar','integer','nonempty','>=',1,'<=',8},mfilename,'WINFLAG',12)
validateattributes(posfreqflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'POSFREQ  FLAG',13)
validateattributes(realsigflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'REALSIGFLAG',14)
validateattributes(normflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NORMFLAG',15)
validateattributes(zphflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'ZPHFLAG',16)
validateattributes(npeakflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NPEAKFLAG',17)
validateattributes(normdprodflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NORMDPRODFLAG',18)

[peakFFT,peakFormulaDFT] = tools.psel.spec_peak_shape(fft_frame,amp,freq,ph,framelen,nfft,fs,nframe,nchannel,...
    maxnpeak,nbinspan,winflag,posfreqflag,realsigflag,normflag,zphflag,npeakflag);

measure_shape = tools.math.dotprod(peakFormulaDFT,peakFFT,4,normdprodflag);

end
