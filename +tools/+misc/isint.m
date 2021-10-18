function res = isint(num)
%ISINT Test if input is integer.
%   RES = ISINT(NUM) tests if the numeric value of NUM is integer and
%   returns logic TRUE or FALSE in RES. NUM can be a scalar, an array, or a
%   matrix.
%
%   Note: ISINT tests for the numeric value of NUM, not the class. Use
%   ISINTEGER(NUM) or CLASS(NUM) for the class of NUM. ISINT(NUM) returns
%   TRUE as long as the following conditions are both TRUE: ISNUMERIC(NUM)
%   && REM(NUM,1) == 0.
%
%   See also ISEVEN, ISODD

% 2016 MCaetano (Revised)
% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

if ~isnumeric(num) || any(isnan(num(:))) || any(isinf(num(:)))
    
    error('SMT:ERROR:InputNotNumeric:The input NUM must be numeric');
    
elseif ~isreal(num)
    
    error('SMT:ERROR:ComplexInput:The input NUM must be real');
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Integers are NOT fractionals
res = ~tools.misc.isfrac(num);

end
