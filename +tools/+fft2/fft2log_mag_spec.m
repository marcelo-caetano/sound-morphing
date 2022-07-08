function logmagspec = fft2log_mag_spec(fft_frame,nfft,logflag,posspecflag,nrgflag,nanflag)
%FFT2LOG_MAG_SPEC From complex FFT to log magnitude spectrum.
%   LMS = FFT2LOG_MAG_SPEC(FFT) retuns the log magnitude spectrum
%   LMS of the full frequency range of the complex FFT multi-dimensional
%   array in dB power. FFT is size NFFT x NFRAME x NCHANNEL, where NFFT is
%   the FFT size, NFRAME is the number of frames of the STFT, and NCHANNEL
%   is the number of channels of the original signal S transformed with the
%   STFT. NCHANNEL = 1 for mono, NCHANNEL = 2 for stereo, and so on. FFT is
%   a colum vector when NFRAME = 1 and NCHANNEL = 1. LMS will have the same
%   size as FFT.
%
%   LMS = FFT2LOG_MAG_SPEC(FFT,NFFT) uses NFFT as the size of the
%   FFT.
%
%   LMS = FFT2LOG_MAG_SPEC(FFT,NFFT,LOGFLAG) uses the text flag LOGFLAG to
%   specify the magnitude scaling of the spectrum. LOGFLAG can be 'DBR' for
%   dB root-power, 'DBP' for dB power, 'NEP' for neper, 'OCT' for octave,
%   and 'BEL' for bels.
%
%   LMS = FFT2LOG_MAG_SPEC(FFT,NFFT,LOGFLAG,POSFREQFLAGFLAG) uses
%   the logical flag POSSPECFLAG to specify the frequency range of LMS.
%   POSSPECFLAG = FALSE is the default to output the full frequency range
%   of the log magnitude spectrum. POSSPECFLAG = TRUE forces
%   FFT2LOG_MAG_SPEC to output the positive half of the FFT.
%   LMS is NBIN x NFRAME x NCHANNEL, where NBIN = NFFT/2+1 is the number of
%   _non-negative_ frequency bins of the FFT.
%
%   LMS = FFT2LOG_MAG_SPEC(FFT,NFFT,LOGFLAG,POSFREQFLAGFLAG,
%   NRGFLAG) uses the logical flag NRGFLAG to specify if LMS should also
%   contain the spectral energy of the negative frequency bins.
%   NRGFLAG = TRUE adds the negative frequency energy to the log magnitude
%   spectrum and NRGFLAG = FALSE does not. The default is NRGFLAG = FALSE.
%   POSSPECFLAG must be TRUE when NRGFLAG = TRUE, otherwise
%   FFT2LOG_MAG_SPEC issues a warning and forces POSSPECFLAG = TRUE.
%
%   LMS = FFT2LOG_MAG_SPEC(FFT,NFFT,LOGFLAG,POSFREQFLAGFLAG,
%   NRGFLAG,NANFLAG) uses the logical flag NANFLAG to handle the case
%   FFT = 0. NANFLAG = TRUE replaces 0 with eps(0) to avoid -Inf in LMS
%   because log(0) = -Inf. NANFLAG = FALSE does not replace 0 in FFT. Use
%   NANFLAG = TRUE to get only numeric values in LMS. NANFLAG defaults to
%   FALSE for the previous syntaxes.
%
%   See also FFT2LIN_PHASE_SPEC, FFT2POW_MAG_SPEC, FFT2SCALED_PHASE_SPEC
%   FFT2POS_PHASE_SPEC

% 2020 MCaetano SMT 0.1.2
% 2020 MCaetano SMT 0.2.1
% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,6);

% Check number of output arguments
nargoutchk(0,1);

if nargin == 1
    
    [nfft,~] = size(fft_frame);
    
    logflag = 'dbp';
    
    posspecflag = false;
    
    nrgflag = false;
    
    nanflag = false;
    
elseif nargin == 2
    
    logflag = 'dbp';
    
    posspecflag = false;
    
    nrgflag = false;
    
    nanflag = false;
    
elseif nargin == 3
    
    posspecflag = false;
    
    nrgflag = false;
    
    nanflag = false;
    
elseif nargin == 4
    
    nrgflag = false;
    
    nanflag = false;
    
elseif nargin == 5
    
    nanflag = false;
    
end

% Check that NFFT == SIZE(FFT_FRAME,1)
[nrow,ncol] = size(fft_frame);

if nfft ~= nrow
    
    warning('SMT:FFT2LOG_MAG_SPEC:invalidInputArgument',...
        ['Input argument NFFT does not match the dimensions of FFT.\n'...
        'FFT must be NFFT x NFRAME.\nSize of FFT entered was %d x %d.\n'...
        'NFFT entered was %d.\nUsing NFFT = %d'],nrow,ncol,nfft,nrow);
    
    nfft = nrow;
    
end

% POSSPECFLAG must be TRUE when NRGFLAG is TRUE
if nrgflag && ~posspecflag
    
    warning('SMT:FFT2LOG_MAG_SPEC:wrongFlagCombination',...
        ['POSSPECFLAG must be TRUE when NRGFLAG is TRUE.\n'...
        'POSSPECFLAG entered was %d but NRGFLAG entered was %d.\n'...
        'Using POSSPECFLAG = TRUE'],posspecflag,nrgflag);
    
    posspecflag = true;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if posspecflag
    
    % Positive magnitude spectrum
    magspec = tools.fft2.fft2pos_mag_spec(fft_frame,nfft,nrgflag);
    
else
    
    % Full magnitude spectrum
    magspec = tools.fft2.fft2mag_spec(fft_frame);
    
end

% Log magnitude spectrum
logmagspec = tools.math.lin2log(magspec,logflag,nanflag);

end
