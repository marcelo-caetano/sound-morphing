function powmagspec = fft2pow_mag_spec(fft_frame,nfft,pow,posspecflag,nrgflag,nanflag)
%FFT2POW_MAG_SPEC From complex FFT to power magnitude spectrum.
%   PMS = FFT2POW_MAG_SPEC(FFT) retuns the power
%   magnitude spectrum PMS of the full frequency range of the complex FFT
%   vector or matrix. FFT is size NFFT x NFRAME x NCHANNEL, where NFFT is
%   the FFT size, NFRAME is the number of frames of the STFT, and NCHANNEL
%   is the number of channels of the original signal S transformed with the
%   STFT. NCHANNEL = 1 for mono, NCHANNEL = 2 for stereo, and so on. FFT is
%   a colum vector when NFRAME = 1 and NCHANNEL = 1. PMS will have the same
%   size as FFT. The default power is 2 so PMS = abs(FFT).^2.
%
%   PMS = FFT2POW_MAG_SPEC(FFT,NFFT) uses NFFT as the
%   size of the FFT.
%
%   PMS = FFT2POW_MAG_SPEC(FFT,NFFT,POW) uses POW as the power
%   to raise the magnitude spectrum. POW can be integer or rational,
%   positive or negative, so POW is class float.
%
%   PMS = FFT2POW_MAG_SPEC(FFT,NFFT,POW,POSFREQFLAGFLAG) uses
%   the logical flag POSSPECFLAG to specify the frequency range of PMS.
%   POSSPECFLAG = FALSE is the default to output the full frequency range
%   of the power magnitude spectrum. POSSPECFLAG = TRUE forces
%   FFT2POW_MAG_SPEC to output the positive half of the FFT.
%   PMS is NFFT/2+1 x NFRAME, where NFFT/2+1 is the number of _non-negative_
%   frequency bins of the FFT.
%
%   PMS = FFT2POW_MAG_SPEC(FFT,NFFT,POW,POSFREQFLAGFLAG,
%   NRGFLAG) uses the logical flag NRGFLAG to specify if PMS should also
%   contain the spectral energy of the negative frequency bins.
%   NRGFLAG = TRUE adds the negative frequency energy to the power
%   magnitude spectrum and NRGFLAG = FALSE does not. The default is
%   NRGFLAG = FALSE. POSSPECFLAG must be TRUE when NRGFLAG = TRUE,
%   otherwise FFT2LIN_MAG_SPEC issues a warning and forces
%   POSSPECFLAG = TRUE.
%
%   PMS = FFT2POW_MAG_SPEC(FFT,NFFT,POW,POSFREQFLAGFLAG,
%   NRGFLAG, NANFLAG) uses the logical flag NANFLAG to handle the case
%   POWMAG = Inf commonly resulting from POW < 0 when LINMAG contains
%   values approaching 0. NANFLAG = TRUE replaces Inf with REALMAX in
%   POWMAG. NANFLAG = FALSE ignores Inf in POWMAG. Use NANFLAG = TRUE to
%   get numeric values in POWMAG. NANFLAG defaults to FALSE when LIN2POW is
%   called with only two input arguments.
%
%   See also FFT2LOG_MAG_SPEC, FFT2UNWRAP_PHASE_SPEC,
%   FFT2POS_MAG_SPEC,

% 2021 M Caetano SMT
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
    
    pow = 2;
    
    posspecflag = false;
    
    nrgflag = false;
    
    nanflag = false;
    
elseif nargin == 2
    
    pow = 2;
    
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
    
    warning('SMT:FFT2POW_MAG_SPEC:wrongInputArgument',...
        ['Input argument NFFT does not match the dimensions of FFT.\n'...
        'FFT must be NFFT x NFRAME.\nSize of FFT entered was %d x %d.\n'...
        'NFFT entered was %d.\nUsing NFFT = %d'],nrow,ncol,nfft,nrow);
    
    nfft = nrow;
    
end

% POSSPECFLAG must be TRUE when NRGFLAG is TRUE
if nrgflag && ~posspecflag
    
    warning('SMT:FFT2POW_MAG_SPEC:wrongFlagCombination',...
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

% Power magnitude spectrum
powmagspec = tools.math.lin2pow(magspec,pow,nanflag);

end
