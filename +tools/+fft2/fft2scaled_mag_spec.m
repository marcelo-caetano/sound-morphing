function scaled_magspec = fft2scaled_mag_spec(fft_frame,nfft,pow,logflag,paramestflag,posspecflag,nrgflag,nanflag)
%FFT2SCALED_MAG_SPEC From complex FFT to scaled magnitude spectrum.
%   SMAGSPEC = FFT2SCALED_MAG_SPEC(FFTFR,NFFT,POW,LOGFLAG,PARAMESTFLAG)
%   returns the scaled magnitude spectrum SMAGSPEC of the FFT frames FFTFR.
%   FFTFR is size NFFT x M x NCHANNEL, where NFFT is the size of the FFT, M
%   is the frame length, and NCHANNEL is the number of channels. POW is the
%   exponent used in power scaling, LOGFLAG is a text flag used to specify
%   the magnitude scaling of the spectrum, and PARAMESTFLAG is a text flag
%   that indicates the amplitude scale of the magnitude spectrum. LOGFLAG
%   can be 'DBR' for dB root-power, 'DBP' for dB power, 'NEP' for neper,
%   'OCT' for octave, and 'BEL' for bels. PARAMESTFLAG can be 'NNE', 'LIN',
%   'LOG', or 'POW'. SMAGSPEC contains the positive half of the magnitude
%   spectrum of FFTFR with the energy of the negative half of the spectrum
%   added and scaled according to PARAMESTFLAG. SMAGSPEC is the same size
%   as FFTFR.
%
%   SMAGSPEC = FFT2SCALED_MAG_SPEC(FFTFR,NFFT,POW,LOGFLAG,PARAMESTFLAG,
%   POSSPECFLAG) uses the logical flag POSSPECFLAG to specify the frequency
%   range of SMAGSPEC. POSSPECFLAG = FALSE is the default to output the
%   full frequency range of the log magnitude spectrum. POSSPECFLAG = TRUE
%   forces FFT2SCALED_MAG_SPEC to output the positive half of the FFT.
%   SMAGSPEC is NBIN x NFRAME x NCHANNEL, where NBIN = NFFT/2+1 is the
%   number of _non-negative_ frequency bins of the FFT.
%
%   SMAGSPEC = FFT2SCALED_MAG_SPEC(FFTFR,NFFT,POW,LOGFLAG,PARAMESTFLAG,
%   POSSPECFLAG,NRGFLAG) uses the logical flag NRGFLAG to control the
%   spectral energy of SMAGSPEC. NRGFLAG = TRUE adds the negative frequency
%   energy to the positive frequency bins and NRGFLAG = FALSE does not. The
%   default is NRGFLAG = FALSE for the previous syntaxes.
%
%   SMAGSPEC = FFT2SCALED_MAG_SPEC(FFTFR,NFFT,POW,LOGFLAG,PARAMESTFLAG,
%   POSSPECFLAG,NRGFLAG,NANFLAG) uses the logical flag NANFLAG to handle
%   the case FFTFR = 0 for each scaling. NANFLAG = TRUE replaces 0 in FFTFR
%   and NANFLAG = FALSE does not. Use NANFLAG = TRUE to get only numeric
%   values in SMAGSPEC. The default is NANFLAG = FALSE for the previous
%   syntaxes.
%
%   See also REVERT_MAG_SPEC_SCALING

% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(5,8);

% Check number of output arguments
nargoutchk(0,1);

if nargin == 5
    
    posspecflag = false;
    
    nrgflag = false;
    
    nanflag = false;
    
elseif nargin == 6
    
    nrgflag = false;
    
    nanflag = false;
    
elseif nargin == 7
    
    nanflag = false;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Scale the magnitude spectrum
switch lower(paramestflag)
    
    case {'nne','lin'}
        
        scaled_magspec = tools.fft2.fft2lin_mag_spec(fft_frame,nfft,posspecflag,nrgflag);
        
    case 'log'
        
        scaled_magspec = tools.fft2.fft2log_mag_spec(fft_frame,nfft,logflag,posspecflag,nrgflag,nanflag);
        
    case 'pow'
        
        scaled_magspec = tools.fft2.fft2pow_mag_spec(fft_frame,nfft,pow,posspecflag,nrgflag,nanflag);
        
    otherwise
        
        warning('SMT:FFT2SCALED_MAG_SPEC:UnknownFlag',...
            ['Unknown Magnitude Scaling Flag.\n'...
            'PARAMESTFLAG must be ''LOG'', ''LIN'', or ''POW''.\n'...
            'PARAMESTFLAG entered was ''%d''.\n'...
            'Using default PARAMESTFLAG = ''LOG''.\n'],paramestflag)
        
        scaled_magspec = tools.fft2.fft2log_mag_spec(fft_frame,nfft,logflag,posspecflag,nrgflag,nanflag);
        
end

end
