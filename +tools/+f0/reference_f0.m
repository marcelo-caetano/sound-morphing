function ref0 = reference_f0(f0,f0flag)
%REFERENCE_F0 Reference value for the fundamental frequency.
%   REF0 = REFERENCE_F0(F0) returns the median value REF0 of the
%   fundamental frequency estimations F0. REF0 is a scalar and F0 can be a
%   vector or multidimensional array.
%
%   REF0 = REFERENCE_F0(F0,FOFLAG) uses the logical flag F0FLAG to specify
%   if REF0 is the median or the mean of F0. F0FLAG = FALSE uses the median
%   and F0FLAG = TRUE uses the mean. The default is F0FLAG = FALSE when
%   REFERENCE_F0 is called with one input argument.

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,2);

% Check number of output arguments
nargoutchk(0,1);

if nargin == 1
    
    f0flag = false;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if f0flag
    
    func = @mean;
    
else
    
    func = @median;
    
end

% F0 condition
f0_bool = isfinite(f0) & f0 > 0;

% If no value in F0 matches condition
if all(~f0_bool(:))
    
    warning('SMT:REFERENCE_F0:invalidInputArgument',...
        ['Input argument F0 has no finite positive values.\n'...
        'Using default f0 value C0 = 16.35Hz']);
    
    % Fallback to f0 = C0
    ref0 = tools.mus.note2freq('C0');
    
else
    
    % Sanitizing f0 (eliminating Inf, NaN, and f0 <= 0)
    f0 = f0(f0_bool);
    
    % F0 sanitization always returns a column vector, so median(f0) also works
    ref0 = func(f0(:));
    
end

end
