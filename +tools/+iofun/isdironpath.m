function bool_onpath = isdironpath(querydir)
%ISDIRONPATH TRUE when query folder is on the Matlab path.
%   BOOL = ISDIRONPATH(DIR) returns TRUE if DIR is on the Matlab path and
%   FALSE otherwise.
%
%   See also ISONPATH

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

narginchk(1,1)

nargoutchk(0,1)

validateattributes(querydir,{'char','string','cell'},{'nonempty'},mfilename,'QUERYDIR',1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Perform case-insensitive search if ISPC == TRUE
bool_onpath = contains(path,querydir,'IgnoreCase',ispc);

end
