function relampdB = peak_reldb(amp)
%PEAK_RELDB Relative amplitude in dB.
%   R = PEAK_RELDB(A) returns the amplitudes R in dB relative to the
%   maximum of each column of the absolute linear amplitude values A.
%
%   See also ABSDB

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

% TODO: VALIDATE ARGUMENTS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Maximum amplitude per frame
maxamp = max(amp,[],1,'omitnan');

maxampdB = tools.math.lin2log(maxamp,'dbp');

ampdB = tools.math.lin2log(amp,'dbp');

relampdB = ampdB - maxampdB;

end
