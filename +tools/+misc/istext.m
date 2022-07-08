function bool = istext(txt)
%ISTEXT Test if input is text.
%   BOOL = ISTEXT(TXT) returns logical TRUE if the input is a character
%   array, a string array, or a cell array of character vectors.
%
%   See also ISINT, ISFRAC

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% True for CHAR array
bool_char = ischar(txt);

% True for cell array of character vectors
bool_cell = iscellstr(txt);

% True for STRING array
bool_str = isstring(txt);

% True for either CHAR or STRING or Cell array of CHAR
bool = bool_char || bool_str || bool_cell;

end

