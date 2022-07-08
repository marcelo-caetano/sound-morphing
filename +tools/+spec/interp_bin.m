function bin = interp_bin(nfft,framelen)
%INTERP_BIN Interpolation of frequency bins
%   B = INTERP_BIN(NFFT,FRAMELEN) returns the number of frequency bins B
%   corresponding to a spectral interpolation of NFFT/FRAMELEN, where NFFT
%   is the size of the FFT and FRAMELEN is the window size. The spectral
%   interpolation operation corresponds to zero-padding in the time domain
%   by NFFT - FRAMELEN.
%
%   See also

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check the number of input arguments
narginchk(2,2);

% Check the number of output arguments
nargoutchk(0,1);

validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',1)

validateattributes(framelen,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,' FRAMELEN',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bin = nfft/framelen;

end
