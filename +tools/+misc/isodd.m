function res = isodd(num)
%ISODD Test if a number is odd.
%   RES = ISODD(NUM) returns TRUE when NUM is odd and FALSE otherwise.
%
%   See also ISEVEN, ISINT

% 2020 MCaetano SMT 0.1.1
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK FUNCTION INPUTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

if tools.misc.isfrac(num)
    
    error('SMT:ISODD:notInteger',...
        ['Input argument NUM must be an integer.\n'...
        'NUM entered was %5.2f.'],num);
    
end

if ~isnumeric(num)
    
    error('SMT:ISODD:notNumeric',...
        ['Input argument NUM must be an integer.\n'...
        'NUM entered was %5.2f.'],num);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check remainder after division by 2
remdiv2 = rem(num,2);

% Convert to logical
res = logical(remdiv2);

end
