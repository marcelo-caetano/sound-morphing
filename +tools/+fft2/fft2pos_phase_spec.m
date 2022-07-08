function posphspec = fft2pos_phase_spec(fft_frame,nfft)
%FFT2POS_PHASE_SPEC From FFT to positive phase spectrum.
%   PPS = FFT2POS_PHASE_SPEC(FFT) returns the phase spectrum of
%   the positive half of the complex FFT vector or matrix. FFT can be
%   either an NFFT x 1 colum vector or an NFFT x NFRAME matrix with NFRAME
%   frames of the STFT. PPS is INYQ x NFRAME, where INYQ is the number of
%   _non-negative_ frequency bins of the FFT obtained with POS_FREQ_BAND.
%   Type HELP TOOLS.SPEC.POS_FREQ_BAND for further information.
%
%   PPS = FFT2POS_PHASE_SPEC(FFT,NFFT) uses NFFT for the size of
%   the FFT.
%
%   See also FFT2POS_MAG_SPEC, FFT2MAG_SPEC, FFT2PHASE_SPEC, FFT2LOG_MAG_SPEC, FFT2UNWRAPPED_PHASE_SPEC

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,2);

% Check number of output arguments
nargoutchk(0,1);

% Defaults
if nargin == 1
    
    % Assume FFT_FRAME is NFFT X NFRAME
    [nfft,~] = size(fft_frame);
    
end

% Check that NFFT == SIZE(FFT_FRAME,1)
[nrow,ncol] = size(fft_frame);

if nfft ~= nrow
    
    warning('SMT:FFT2POS_MAG_SPEC:wrongInputArgument',...
        ['Input argument NFFT does not match the dimensions of FFT.\n'...
        'FFT must be NFFT x NFRAME.\nSize of FFT entered was %d x %d.\n'...
        'NFFT entered was %d.\nUsing NFFT = %d'],nrow,ncol,nfft,nrow);
    
    nfft = nrow;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Phase of the FFT
phspec = tools.fft2.fft2phase_spec(fft_frame);

% Positive half of phase spectrum
posphspec = tools.fft2.full_spec2pos_spec(phspec,nfft);

end
