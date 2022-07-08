function [scaled_magspec,pow] = mag_spec_scaling(fft_frame,framelen,nfft,winflag,paramestflag)
%MAG_SPEC_SCALING From complex FFT to scaled magnitude spectrum.
%   [SMAGSPEC,P] = MAG_SPEC_SCALING(FFTFR,M,NFFT,WINFLAG,PARAMESTFLAG)
%   returns the scaled magnitude spectrum SMAGSPEC of the FFT frames FFTFR.
%   FFTFR is size NFFT x M, where NFFT is the size of the FFT and M is the
%   frame length. WINFLAG is a numerical flag that indicates the window
%   used in the STFT, and PARAMESTFLAG is a text flag that indicates the
%   amplitude scale of the magnitude spectrum. PARAMESTFLAG can be 'NNE',
%   'LIN', 'LOG', or 'POW'. SMAGSPEC contains the positive half of the
%   magnitude spectrum of FFTFR with the energy of the negative half of the
%   spectrum added and scaled according to PARAMESTFLAG. P is the exponent
%   used to scale SMAGSPEC. P = 1 unless PARAMESTFLAG = 'POW'.
%
%   See also REVERT_MAG_SPEC_SCALING

% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(5,5);

% Check number of output arguments
nargoutchk(0,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Default power scaling
if strcmpi(paramestflag,'pow')
    
    pow = xqifft(framelen,winflag);
    
else
    
    pow = 1;
    
end

% Default log scaling
logflag = 'dbp';

% Positive frequencies
posspecflag = true;

% Add spectral energy of negative frequencies
nrgflag = true;

% Handle NaN
nanflag = true;

% Scale the magnitude spectrum
scaled_magspec = tools.fft2.fft2scaled_mag_spec(fft_frame,nfft,pow,logflag,paramestflag,posspecflag,nrgflag,nanflag);

end
