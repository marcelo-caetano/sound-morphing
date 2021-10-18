function nbin = pos_freq_band(nfft)
%POS_FREQ_BAND Positive frequency band.
%   PB = POS_FREQ_BAND(NFFT) returns the length of the positive frequency
%   band in bins of a spectrum obtained with an FFT of size NFFT.
%   PB includes the zero-frequency and Nyquist-frequency bins for even NFFT
%   but only the zero-frequency bin for odd NFFT since the Nyquist bin is
%   fractional in that case.
%
%   See also NEG_FREQ_BAND, NYQBIN, FFTFLIP, IFFTFLIP, LEFTWIN, RIGHTWIN

% 2020 MCaetano SMT 0.1.1
% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

% Validate NFFT
validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Length of positive frequency band
nbin = tools.spec.nyq_ind(nfft);

end
