function bool = istrough(mag)
% ISTROUGH True for troughs.
%   BOOL = ISTROUGH(MAG) returns a logical vector BOOL with the positions of
%   the troughs of MAG. BOOL is the same size as MAG and contains TRUE for
%   positions that correspond to troughs and FALSE otherwise. A trough is
%   defined as being either a 3-point trough or a 2-point trough. Type HELP
%   TOOLS.PSEL.IS3PTTROUGH, HELP TOOLS.PSEL.IS2PTTROUGHR, and
%   HELP TOOLS.PSEL.IS2PTTROUGHL for further information.
%
%   See also IS3PTTROUGH, IS2PTTROUGHL, IS2PTTROUGHR

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

% Positions of spectral troughs
bool_spec = tools.psel.is3pttrough(mag);

% Positions of right symmetrical troughs
bool_symm_right = tools.psel.is2pttroughr(mag);

% Positions of left symmetrical troughs
bool_symm_left = tools.psel.is2pttroughl(mag);

% Positions of troughs
bool = bool_spec | bool_symm_right | bool_symm_left;

end
