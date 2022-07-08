function cents = step2cents(step)
%STEP2CENTS Interval in cents corresponding to number of steps.
%   C = STEP2CENTS(S) returns the frequency interval C expressed in cents
%   corresponding to the integer number of steps S as C = 100*S. S must be
%   an integer number of steps otherwise the values will be rounded.
%
%   See also CENTS2STEP, FREQ2CENTS, CENTS2FREQ

% 2022 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

validateattributes(step,{'numeric'},{'real'},mfilename,'STEP',1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

isFractional = tools.misc.isfrac(step);

if any(isFractional(:))
    
    warning('SMT:STEP2CENTS:invalidInputArgument',...
        ['Input argument S contains non integer values\n'...
        'All steps S must be integers\n'...
        'Rounding off S\n'])
    
    step = round(step);
    
end

cents = 100 * step;

end
