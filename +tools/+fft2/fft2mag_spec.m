function magspec = fft2mag_spec(fft_frame)
%FFT2MAG_SPEC From FFT to magnitude spectrum.
%   M = FFT2MAG_SPEC(FFT) returns the magnitude spectrum M of the
%   complex FFT vector or matrix. FFT can be either a NFFT x 1 colum vector
%   or an NFFT x NFRAME matrix with NFRAME frames of the STFT.
%
%   See also FFT2PHASE_SPEC, FFT2POS_MAG_SPEC,
%   FFT2POS_PHASE_SPEC, FFT2LOG_MAG_SPEC,
%   FFT2UNWRAP_PHASE_SPEC

% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Magnitude of the complex FFT
magspec = abs(fft_frame);

end
