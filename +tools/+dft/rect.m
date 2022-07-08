function mag = rect(bin,framelen,nfft,normflag,zphflag)
%RECT Discrete Fourier transform of the rectangular window.
%   W = RECT(BIN,FRAMELEN,NFFT,NORMFLAG,ZPHFLAG) returns the size-NFFT DFT
%   of the rectangular window with FRAMELEN samples over the range BIN.
%   NORMFLAG is a logical flag that determines if W is normalized by
%   FRAMELEN. NORMFLAG = TRUE sets normalization and NORMFLAG = FALSE
%   does not. ZPHFLAG is a logical flag that determines if W is zero phase
%   or linear phase. ZPHFLAG = TRUE sets zero-phase and ZPHFLAG = FALSE
%   sets linear-phase.
%
%   The input BIN and the output W are structures containing the fields POS
%   and NEG with the positive and negative frequencies respectively.
%
%   See also HANN, HAMMING, BLACKMAN, BLACKMANHARRIS

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

% Positive frequencies
mag.pos = tools.dft.dirichlet(bin.pos,framelen,nfft,normflag,zphflag);

% Negative frequencies
mag.neg = tools.dft.dirichlet(bin.neg,framelen,nfft,normflag,zphflag);

end
