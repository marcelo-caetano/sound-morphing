function phspec = fft2phase_spec(fft_frame)
%FFT2PHASE_SPEC From FFT to phase spectrum.
%   P = FFT2PHASE_SPEC(FFTFR) returns the phase spectrum P of the complex
%   FFTFR array containing STFT data of size NFFT x NFRAME x NCHANNEL,
%   where NFFT is the size of the FFT, NFRAME is the number of frames,
%   NCHANNEL is the number of audio channels.
%
%   See also FFT2MAG_SPEC, FFT2POS_MAG_SPEC, FFT2POS_PHASE_SPEC,
%   FFT2LOG_MAG_SPEC, FFT2UNWRAPPED_PHASE_SPEC

% 2020 M Caetano SMT 0.1.1
% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

% Validate FFT_FRAME
validateattributes(fft_frame,{'numeric'},{'nonempty','finite','nonnan'},mfilename,'FFT_FRAME',1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Phase of the complex FFT
phspec = angle(fft_frame);

end
