function bin = mkbinvec(binStart,binEnd,binStep)
%MKBINVEC Make frequency bins within range.
%   B = MKBINVEC(S,E) returns a frequency bin column vector B that starts
%   at S and ends at E as B = [S:E]'. S and E must be real but not
%   necessarily integers. The step increment is always 1, so the final size
%   of B depends on whether only S || E is an integer or both are. For
%   example, compare the output of:
%
%   MKBINVEC(0,3) = [0 1 2 3]';
%   MKBINVEC(0.1,3) = [0.1 1.1 2.1]';
%   MKBINVEC(0,3.1) = [0 1 2 3]';
%   MKBINVEC(0,2.9) = [0 1 2]';
%   MKBINVEC(0.1,2.9) = [0.1 1.1 2.1]';
%   MKBINVEC(-0.1,2.9) = [-0.1 0.9 1.9 2.9]';
%
%   B = MKBINVEC(S,E,H) uses the increment H [S:H:E]'
%
%   See also MKBIN

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check the number of input arguments
narginchk(2,3);

% Check the number of output arguments
nargoutchk(0,1);

if binStart == binEnd
    
    warning('SMT:MKBINVEC:InvalidInputArgument',...
        ['Invalid input arguments.\n'...
        'S = %2.5g and E = %2.5g\n'...
        'S == E results in a scalar B = S.\n'...
        'Ensure S > E or S < E to get a range.\n'],binStart,binEnd)
    
    binStep = 1;
    
elseif isnan(binStart) || isnan(binEnd)
    
    bin = [];
    
    return
    
elseif nargin == 2 && binStart > binEnd
    
    binStep = -1;
    
elseif nargin == 2 && binStart < binEnd
    
    binStep = 1;
    
elseif nargin == 3 && binStep < 0 && binEnd > binStart
    
    error('SMT:MKBINVEC:InvalidInputArgument',...
        ['Invalid input arguments.\n'...
        'S = %2.5g, E = %2.5g and H = %2.5g\n'...
        'S < E results in an empty array when H < 0.\n'...
        'Ensure S > E when H < 0 to get a range.\n'],binStart,binEnd,binStep)
    
elseif nargin == 3 && binStep > 0 && binEnd < binStart
    
    error('SMT:MKBINVEC:InvalidInputArgument',...
        ['Invalid input arguments.\n'...
        'S = %2.5g, E = %2.5g and H = %2.5g\n'...
        'S > E results in an empty array when H > 0.\n'...
        'Ensure S < E when H > 0 to get a range.\n'],binStart,binEnd,binStep)
    
elseif nargin == 3 && binStep > 0 && binStart + binStep > binEnd
    
    warning('SMT:MKBINVEC:InvalidInputArgument',...
        ['Invalid input arguments.\n'...
        'S = %2.5g, E = %2.5g, and H = %2.5g\n'...
        'S + H > E results in a scalar when H > 0.\n'...
        'Ensure S + H < E when H > 0 to get a range.\n'],...
        binStart,binEnd,binStep)
    
elseif nargin == 3 && binStep < 0 && binStart + binStep < binEnd
    
    warning('SMT:MKBINVEC:InvalidInputArgument',...
        ['Invalid input arguments.\n'...
        'S = %2.5g, E = %2.5g, and H = %2.5g\n'...
        'S + H < E results in a scalar when H < 0.\n'...
        'Ensure S + H > E when H < 0 to get a range.\n'],...
        binStart,binEnd,binStep)
    
end

validateattributes(binStart,{'numeric'},{'scalar','real'},mfilename,'S',1)

validateattributes(binEnd,{'numeric'},{'scalar','real'},mfilename,'E',2)

validateattributes(binStep,{'numeric'},{'scalar','real','nonzero'},mfilename,'H',3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bin = [binStart:binStep:binEnd]';

end
