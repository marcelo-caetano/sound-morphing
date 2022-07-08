function freq_num = cents2freq(cents,freq_den)
%CENTS2FREQ From interval in cents to frequency in Hertz.
%   F = CENTS2FREQ(C,REF) returns the frequency F in Hz that corresponds to
%   the interval C in cents using the reference frequency REF also in Hz.
%   The conversion is F = REF*2^(C/1200).
%
%   See also FREQ2CENTS, CENTS2HERTZ, HERTZ2CENTS

% 2022 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,2);

% Check number of output arguments
nargoutchk(0,1);

validateattributes(cents,{'numeric'},{'real'},mfilename,'CENTS',1)
validateattributes(freq_den,{'numeric'},{'real'},mfilename,'REF',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hertz = tools.mus.cents2hertz(cents);

freq_num = freq_den.*hertz;

end
