function mag = blackmanharris(bin,framelen,nfft,normflag,zphflag)
%BLACKMANHARRIS Discrete Fourier transform of the Blackman-Harris window.
%   W = BLACKMANHARRIS(BIN,FRAMELEN,NFFT,NORMFLAG,ZPHFLAG) returns the
%   size-NFFT DFT of the Blackman-Harris window with FRAMELEN samples over
%   the range BIN. NORMFLAG is a logical flag that determines if W is
%   normalized by FRAMELEN. NORMFLAG = TRUE sets normalization and
%   NORMFLAG = FALSE does not. ZPHFLAG is a logical flag that determines if
%   W is zero phase or linear phase. ZPHFLAG = TRUE sets zero-phase and
%   ZPHFLAG = FALSE sets linear-phase.
%
%   The input BIN and the output W are structures containing the fields POS
%   and NEG with the positive and negative frequencies respectively.
%
%   See also RECT, HAMMING, HAMMING, BLACKMANHARRIS

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check the number of input arguments
narginchk(5,5);

% Check the number of output arguments
nargoutchk(0,1);

validateattributes(bin,{'struct'},{'3d','real'},mfilename,'BIN',1)

validateattributes(framelen,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'FRAMELEN',2)

validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',3)

validateattributes(normflag,{'numeric','logical'},{'scalar','binary'},mfilename,'NORMFLAG',4)

validateattributes(zphflag,{'numeric','logical'},{'scalar','binary'},mfilename,'ZPHFLAG',5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Coefficients
coeff0 = 0.35875;
coeff1 = 0.48829;
coeff2 = 0.14128;
coeff3 = 0.01168;

% Positive frequencies
mag.pos = tools.dft.quaddirich(bin.pos,framelen,nfft,coeff0,coeff1,coeff2,coeff3,normflag,zphflag);

% Negative-frequency bins
mag.neg = tools.dft.quaddirich(bin.neg,framelen,nfft,coeff0,coeff1,coeff2,coeff3,normflag,zphflag);

end
