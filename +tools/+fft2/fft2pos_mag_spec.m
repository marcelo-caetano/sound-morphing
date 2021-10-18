function posmagspec = fft2pos_mag_spec(fft_frame,nfft,nrgflag)
%FFT2POS_MAG_SPEC From complex FFT to positive magnitude spectrum.
%   PMS = FFT2POS_MAG_SPEC(FFT) returns the magnitude
%   spectrum of the positive half of the complex FFT vector or matrix. FFT
%   can be either an NFFT x 1 colum vector or an NFFT x NFRAME matrix with
%   NFRAME frames of the STFT. PMS is NFFT/2+1 x NFRAME, where NFFT/2+1 is
%   the number of _non-negative_ frequency bins of the FFT.
%
%   PMS = FFT2POS_MAG_SPEC(FFT,NFFT) uses NFFT for the size
%   of the FFT.
%
%   PMS = FFT2POS_MAG_SPEC(FFT,NFFT,NRGFLAG) uses the logical flag NRGFLAG
%   to specify if PMS should also contain the spectral energy of the
%   negative frequency bins. NRGFLAG = TRUE adds the energy of the negative
%   frequency bins to the log magnitude spectrum and NRGFLAG = FALSE does
%   not. The default is NRGFLAG = FALSE for the previous syntaxes.
%
%   See also FFT2MAG_SPEC, FFT2PHASE_SPEC, FFT2POS_PHASE_SPEC

% 2020 M Caetano SMT 0.1.2
% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,3);

% Check number of output arguments
nargoutchk(0,1);

% Defaults
if nargin == 1
    
    % Assume FFT_FRAME is NFFT X NFRAME
    [nfft,~] = size(fft_frame);
    
    % Do not compensate for the energy of negative frequencies
    nrgflag = false;
    
elseif nargin == 2
    
    % Do not compensate for the energy of negative frequencies
    nrgflag = false;
    
end

% Check that NFFT == SIZE(FFT_FRAME,1)
[nrow,ncol] = size(fft_frame);

if nfft ~= nrow
    
    warning('SMT:FFT2POS_MAG_SPEC:invalidInputArgument',...
        ['Input argument NFFT does not match the dimensions of FFT.\n'...
        'FFT must be NFFT x NFRAME.\nSize of FFT entered was %d x %d.\n'...
        'NFFT entered was %d.\nUsing NFFT = %d'],nrow,ncol,nfft,nrow);
    
    nfft = nrow;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Magnitude spectrum
magspec = tools.fft2.fft2mag_spec(fft_frame);

% Positive magnitude spectrum
posmagspec = tools.fft2.full_spec2pos_spec(magspec,nfft,nrgflag);

end
