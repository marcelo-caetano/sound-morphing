function [f,nbin] = mkfreqbin(nfft,fs,nframe,nchannel,freqlimflag,frequnitflag)
%MKFREQBIN Make frequency array in bins or in Hertz.
%   F = MKFREQBIN(NFFT,Fs,NFRAME,NCHANNEL) returns a frequency array F
%   in bins corresponding to the full frequency range of the DFT
%   spectrum. F is size NFFT x NFRAME x NCHANNEL.
%
%   F = MKFREQBIN(NFFT,Fs,NFRAME,NCHANNEL,FREQLIMFLAG) uses FREQLIMFLAG
%   to control the limits of the frequency axis. FREQLIMFLAG can be
%   'POS', 'FULL', or 'NEGPOS'. The default is FREQLIMFLAG = 'FULL'.
%
%   FREQLIMFLAG = 'POS' generates frequencies from 0 to Nyquist. Use
%   'POS' to get the positive half of the spectrum. F is size
%   NBIN x NFRAME x NCHANNEL, where NBIN is the number of positive
%   frequency bins.
%
%   FREQLIMFLAG = 'FULL' generates frequencies from 0 to NFFT-1. Use
%   'FULL' to get the full frequency range output by the FFT. F is size
%   NFFT x NFRAME x NCHANNEL.
%
%   FREQLIMFLAG = 'NEGPOS' generates the negative and positive halves of
%   the frequency spectrum. Use 'NEGPOS' to get the full frequency range
%   with the zero-frequency component in the middle of the spectrum. Use
%   FFTFLIP to plot the spectrum. F is size NFFT x NFRAME x NCHANNEL.
%
%   F = MKFREQBIN(NFFT,Fs,NFRAME,NCHANNEL,FREQLIMFLAG,FUNITFLAG) uses
%   the logical flag FUNITFLAG to control the unit of the frequency
%   vector. FUNITFLAG = TRUE outputs frequencies in Hertz and
%   FUNITFLAG = FALSE outputs frequencies in bins. The default is
%   FUNITFLAG = FALSE.
%
%   [F,NBIN] = MKFREQBIN(...) also outputs the number of frequency bins
%   corresponding to the fist dimension of the array F. NBIN = NFFT when
%   FREQLIMFLAG = 'FULL' or FREQLIMFLAG = 'NEGPOS' and NBIN = NFFT/2
%   when FREQLIMFLAG = 'POS'.
%
%   See also NYQ, NYQ_FREQ, FFTFLIP

% 2016 M Caetano
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(4,6);

% Check number of output arguments
nargoutchk(0,2);

if nargin == 4
    
    freqlimflag = 'full';
    
    frequnitflag = false;
    
elseif nargin == 5
    
    frequnitflag = false;
    
end

% Validate NFFT
validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',1)

% Validate Fs
validateattributes(fs,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'Fs',2)

% Validate NFRAME
validateattributes(nframe,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFRAME',3)

% Validate NCHANNEL
validateattributes(nframe,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NCHANNEL',4)

% Validate FREQLIMFLAG
validateattributes(freqlimflag,{'char','string'},{'scalartext','nonempty'},mfilename,'FREQLIMFLAG',5)

% Validate FREQUNITFLAG
validateattributes(frequnitflag,{'logical','numeric'},{'scalar','nonempty','binary'},mfilename,'FREQUNITFLAG',6)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if frequnitflag
    
    [f,nbin] = tools.spec.mkfreq(nfft,fs,nframe,nchannel,freqlimflag);
    
else
    
    [f,nbin] = tools.spec.mkbin(nfft,nframe,nchannel,freqlimflag);
    
end

end
