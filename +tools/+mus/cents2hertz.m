function hertz = cents2hertz(cents)
%CENTS2HERTZ Interval in Hertz corresponding to the interval in cents.
%   H = CENTS2HERTZ(C) returns the frequency interval H in Hz corresponding
%   to the interval C expressed in cents as H = 2^(C/1200).
%
%   See also HERTZ2CENTS, CENTS2FREQ, FREQ2CENTS

% 2022 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

validateattributes(cents,{'numeric'},{'real'},mfilename,'CENTS',1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hertz = pow2(cents/1200);

end
