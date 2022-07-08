function mag = hamming(bin,framelen,nfft,normflag,zphflag,exactflag)
%HAMMING Discrete Fourier transform of the Hamming window.
%   W = HAMMING(BIN,FRAMELEN,NFFT,NORMFLAG,ZPHFLAG) returns the size-NFFT DFT
%   of the Hamming window with FRAMELEN samples over the range BIN. NORMFLAG
%   is a logical flag that determines if W is normalized by FRAMELEN.
%   NORMFLAG = TRUE sets normalization and NORMFLAG = FALSE does not.
%   ZPHFLAG is a logical flag that determines if W is zero phase or linear
%   phase. ZPHFLAG = TRUE sets zero-phase and ZPHFLAG = FALSE sets linear-phase.
%
%   The input BIN and the output W are structures containing the fields POS
%   and NEG with the positive and negative frequencies respectively.
%
%   See also RECT, HANN, BLACKMAN, BLACKMANHARRIS

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check the number of input arguments
narginchk(5,6);

% Check the number of output arguments
nargoutchk(0,1);

if nargin == 5
    
    exactflag = false;
    
end

validateattributes(bin,{'struct'},{'3d','real'},mfilename,'BIN',1)

validateattributes(framelen,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'FRAMELEN',2)

validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',3)

validateattributes(normflag,{'numeric','logical'},{'scalar','binary'},mfilename,'NORMFLAG',4)

validateattributes(zphflag,{'numeric','logical'},{'scalar','binary'},mfilename,'ZPHFLAG',5)

validateattributes(exactflag,{'numeric','logical'},{'scalar','binary'},mfilename,'EXACTFLAG',6)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exactflag
    
    alpha = 25/46;
    
else
    
    alpha = 0.54;
    
end

% Coefficients
coeff1 = alpha;
coeff2 = 1 - alpha;

% Positive-frequency bins
mag.pos = tools.dft.doubledirich(bin.pos,framelen,nfft,coeff1,coeff2,normflag,zphflag);

% Negative-frequency bins
mag.neg = tools.dft.doubledirich(bin.neg,framelen,nfft,coeff1,coeff2,normflag,zphflag);

end
