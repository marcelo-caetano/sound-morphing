function num = mkodd(num,upflag)
%MKODD Make input odd.
%   ONUM = MKODD(NUM) returns an odd number ONUM that is the same as NUM
%   when NUM is odd or NUM + 1 when NUM is even. . NUM must be an integer.
%   ONUM is the same size and class as NUM.
%
%   ONUM = MKODD(NUM,UPFLAG) uses the logical flag UPFLAG to determine if
%   ONUM is incremented or decremented by 1. UPFLAG = TRUE is the default
%   to increment as ONUM = NUM + 1 when NUM is even and UPFLAG = FALSE
%   decrements as ONUM = NUM - 1 when NUM is even.
%
%   See also MKEVEN, ISEVEN, ISODD

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
    
    upflag = true;
    
end

validateattributes(num,{'numeric'},{'integer'},mfilename,'NUM',1)

validateattributes(upflag,{'numeric','logical'},{'binary'},mfilename,'UPFLAG',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if upflag
    
    incr = 1;
    
else
    
    incr = -1;
    
end

bool = tools.misc.iseven(num);

if any(bool(:))
    
    % Use implicit array expansion
    num(bool) = num(bool) + incr;
    
end

end
