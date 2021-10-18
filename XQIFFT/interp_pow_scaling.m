function pow = interp_pow_scaling(powtable,framelen,winflag)
%INTERP_POW_SCALING Interpolate optimal power scaling factor.
%   P = INTERP_POW_SCALING(PTABLE,M,WINFLAG)
%
%   See also XQIFFT

% 2021 M Caetano SMT% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% TODO: CHECK INPUT ARGUMENTS (NaN,class, etc)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(3,3);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Function for the original curve (before linearization)
fun = @(x,k) k*(1-exp(-x));

% Line fit: [slope Yintercept]
pol = powtable{winflag,'linefit'};

% Matrix S
S = powtable{winflag,'S'};

% Normalized
mu = powtable{winflag,'mu'}{:};

% Asymptote
asymp = powtable{winflag,'asymp'};

% Frame length as power of two
framelenpow2 = log2(framelen);

% Linearized estimation of POW
linpow = polyval(pol,framelenpow2,S,mu);

% Original value of POW
pow = fun(linpow,asymp);

end
