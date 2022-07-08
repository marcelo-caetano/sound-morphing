function linmagspec = fft2lin_mag_spec(fft_frame,nfft,posspecflag,nrgflag)
%FFT2LIN_MAG_SPEC From complex FFT to linear magnitude spectrum.
%   LMS = FFT2LIN_MAG_SPEC(FFT) returns the linear magnitude spectrum LMS
%   of the full frequency range of the complex FFT multi-dimensional array.
%   FFT is size NFFT x NFRAME x NCHANNEL, where NFFT is the FFT size,
%   NFRAME is the number of frames of the STFT, and NCHANNEL is the number
%   of channels of the original signal S transformed with the STFT.
%   NCHANNEL = 1 for mono, NCHANNEL = 2 for stereo, and so on. FFT is a
%   colum vector when NFRAME = 1 and NCHANNEL = 1. LMS will have the same
%   size as FFT.
%
%   LMS = FFT2LIN_MAG_SPEC(FFT,NFFT) uses NFFT as the size of the FFT.
%
%   LMS = FFT2LIN_MAG_SPEC(FFT,NFFT,POSSPECFLAG) uses the logical flag
%   POSSPECFLAG to specify the frequency range of LMS. POSSPECFLAG = FALSE
%   is the default to output the full frequency range of the linear
%   magnitude spectrum. POSSPECFLAG = TRUE forces FFT2LOG_MAG_SPEC to
%   output the positive half of the FFT so LMS is NFFT/2+1 x NFRAME, where
%   NFFT/2+1 is the number of _non-negative_ frequency bins of the FFT.
%
%   LMS = FFT2LIN_MAG_SPEC(FFT,NFFT,POSSPECFLAG,NRGFLAG) uses the logical
%   flag NRGFLAG to specify if LMS should also contain the spectral energy
%   of the negative frequency bins. NRGFLAG = TRUE adds the negative
%   frequency energy to the linear magnitude spectrum and NRGFLAG = FALSE
%   does not. The default is NRGFLAG = FALSE. POSSPECFLAG must be TRUE when
%   NRGFLAG = TRUE, otherwise FFT2LIN_MAG_SPEC issues a warning and forces
%   POSSPECFLAG = TRUE.
%
%
%   See also FFT2LOG_MAG_SPEC, FFT2POW_MAG_SPEC, FFT2SCALED_MAG_SPEC

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,4);

% Check number of output arguments
nargoutchk(0,1);

% Defaults
if nargin == 1
    
    % Assume FFT_FRAME is NFFT X NFRAME
    [nfft,~] = size(fft_frame);
    
    % Full frequency spectrum
    posspecflag = false;
    
    % Do not compensate for the energy of negative frequencies
    nrgflag = false;
    
elseif nargin == 2
    
    % Full frequency spectrum
    posspecflag = false;
    
    % Do not compensate for the energy of negative frequencies
    nrgflag = false;
    
elseif nargin == 3
    
    % Do not compensate for the energy of negative frequencies
    nrgflag = false;
    
end

% Check that NFFT == SIZE(FFT_FRAME,1)
[nrow,ncol] = size(fft_frame);

if nfft ~= nrow
    
    warning('SMT:FFT2LIN_MAG_SPEC:invalidInputArgument',...
        ['Input argument NFFT does not match the dimensions of FFT.\n'...
        'FFT must be NFFT x NFRAME.\nSize of FFT entered was %d x %d.\n'...
        'NFFT entered was %d.\nUsing NFFT = %d'],nrow,ncol,nfft,nrow);
    
    nfft = nrow;
    
end

% POSSPECFLAG must be TRUE when NRGFLAG is TRUE
if nrgflag && ~posspecflag
    
    warning('SMT:FFT2LIN_MAG_SPEC:wrongFlagCombination',...
        ['POSSPECFLAG must be TRUE when NRGFLAG is TRUE.\n'...
        'POSSPECFLAG entered was %d but NRGFLAG entered was %d.\n'...
        'Using POSSPECFLAG = TRUE'],posspecflag,nrgflag);
    
    posspecflag = true;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Magnitude spectrum
linmagspec = tools.fft2.fft2mag_spec(fft_frame);

if posspecflag
    
    % Positive magnitude spectrum
    linmagspec = tools.fft2.full_spec2pos_spec(linmagspec,nfft,nrgflag);
    
end

end
