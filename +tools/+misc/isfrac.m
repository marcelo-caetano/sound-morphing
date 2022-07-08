function res = isfrac(num)
%ISINT True when the input is integer.
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
% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

validateattributes(num,{'numeric'},{'real'},mfilename,'NUM',1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Remainder after division by 1
val_rem = rem(num,1);

% Convert remainders into logicals
res = logical(val_rem);

end
