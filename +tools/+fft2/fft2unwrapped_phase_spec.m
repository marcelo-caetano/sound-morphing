function unwrapped_phspec = fft2unwrapped_phase_spec(fft_frame,nfft,posspecflag)
%FFT2UNWRAPPED_PHASE_SPEC From FFT to unwrapped phase spectrum.
%   UPS = FFT2UNWRAPPED_PHASE_SPEC(FFT) returns the unwrapped phase
%   spectrum of the complex FFT vector or matrix. FFT can be either an
%   NFFT x 1 colum vector or an NFFT x NFRAME matrix with NFRAME frames of
%   the STFT.
%
%   UPS = FFT2UNWRAPPED_PHASE_SPEC(FFT,NFFT) uses NFFT for the size of
%   the FFT.
%
%   UPS = FFT2UNWRAPPED_PHASE_SPEC(FFT,NFFT,POSSPECFLAG) uses the logical
%   flag POSSPECFLAG to control if UPS contains the full frequency range or
%   only the positive frequency range of the spectrum of FFTFR. Use
%   POSSPECFLAG = TRUE to return the positive half of the unwrapped phase
%   spectrum in UPS and POSSPECFLAG = FALSE to return the full unwrapped
%   phase spectrum in UPS. The default is POSSPECFLAG = FALSE when
%   FFT2UNWRAPPED_PHASE_SPEC is called with one or two input arguments.
%
%   See also FFT2POS_MAG_SPEC, FFT2MAG_SPEC,
%   FFT2PHASE_SPEC, FFT2LOG_MAG_SPEC

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
    
    % Default to full spectrum
    posspecflag = false;
    
elseif nargin == 2
    
    % Default to full spectrum
    posspecflag = false;
    
end

% Check that NFFT == SIZE(FFT_FRAME,1)
[nrow,nframe,nchannel] = size(fft_frame);

if nfft ~= nrow
    
    warning('SMT:FFT2POS_MAG_SPEC:wrongInputArgument',...
        ['Input argument NFFT does not match the dimensions of FFT\n'...
        'FFT must be NFFT x NFRAME\nSize of FFT entered was %d x %d\n'...
        'NFFT entered was %d\nUsing NFFT = %d'],nrow,nframe,nfft,nrow);
    
    nfft = nrow;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if posspecflag
    
    % Positive phase spectrum
    phspec = tools.fft2.fft2pos_phase_spec(fft_frame,nfft);
    
else
    
    % Full phase spectrum
    phspec = tools.fft2.fft2phase_spec(fft_frame);
    
end

% Unwrap phase around PI
unwrapped_phspec = unwrap(phspec);

end
