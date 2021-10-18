function powmag = lin2pow(linmag,pow,nanflag)
%LIN2POW Convert from linear to power amplitude.
%   POWMAG = LIN2POW(LINMAG,POW) scales the linear magnitude spectrum
%   LINMAG to the power scale specified by POW. POW can be integer or
%   rational, positive or negative, real or complex.
%
%   POWMAG = LIN2POW(LINMAG,POW,NANFLAG) uses NANFLAG to handle the
%   case POWMAG = Inf commonly resulting from POW < 0 when LINMAG contains
%   values approaching 0. NANFLAG = TRUE replaces Inf with REALMAX in
%   POWMAG. NANFLAG = FALSE ignores Inf in POWMAG. Use NANFLAG = TRUE to
%   get numeric values in POWMAG. NANFLAG defaults to FALSE when LIN2POW is
%   called with only two input arguments.
%
%   See also POW2LIN, LIN2LOG, LOG2LIN

% 2020 MCaetano SMT 0.1.1
% 2021 M Caetano SMT (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% TODO: Check inputs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,3);

% Check number of output arguments
nargoutchk(0,1);

% Default NANFLAG
if nargin == 2
    
    nanflag = false;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Convert to power scale
powmag = linmag.^pow;

% Replace Inf with realmax after conversion
if nanflag
    
    % Replace Inf with realmax
    powmag(isinf(powmag)) = realmax;
    
end

end
