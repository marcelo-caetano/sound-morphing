function  cents = hertz2cents(freq_num,freq_den)
%HERTZ2CENTS Interval in cents between two frequencies in Hz.
%   C = HERTZ2CENTS(F,REF) returns the interval C in cents corresponding to
%   the frequencies F and REF in Hz. REF is the reference frequency, such
%   that the conversion is C = 1200*log2(F/REF).
%
%   See also CENTS2HERTZ, FREQ2CENTS, CENTS2FREQ

% 2022 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,2);

% Check number of output arguments
nargoutchk(0,1);

validateattributes(freq_num,{'numeric'},{'real'},mfilename,'F',1)
validateattributes(freq_den,{'numeric'},{'real'},mfilename,'REF',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cents = 1200*log2(freq_num./freq_den);

end
