function bool = ispeak(mag)
% ISPEAK True for peaks.
%   BOOL = ISPEAK(MAG) returns a logical vector BOOL with the positions of
%   the peaks of MAG. BOOL is the same size as MAG and contains TRUE for
%   positions that correspond to peaks and FALSE otherwise. A peak is
%   defined as being either a 3-point peak or a 2-point peak. Type HELP
%   TOOLS.SPEC.IS3PTPEAK and HELP TOOLS.SPEC.IS2PTPEAK for further
%   information.
%
%   See also IS3PTPEAK, IS2PTPEAK

% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


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

% Positions of spectral peaks
bool_spec = tools.sin.is3ptpeak(mag);

% Positions of symmetrical peaks
bool_symm = tools.sin.is2ptpeak(mag);

% Positions of peaks
bool = bool_spec | bool_symm;

end
