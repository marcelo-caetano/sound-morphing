function [amp,freq,ph] = absdb(amp,freq,ph,absthres)
%ABSDB Set absolute threshold in dB.
%   [A,F,P] = ABSDB(A,F,P,ABSTHRES) sets the amplitudes A, frequencies F,
%   and phases P that are below ABSTHRES to NaN.
%
%   See also RELDB

% 2020 MCaetano SMT 0.1.1
% 2021 M Caetano SMT (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(4,4);

% Check number of output arguments
nargoutchk(0,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ensure ABSTHRES is negative value in dB
absthres = -abs(absthres);

% Convert ABSTHRES in dB to linear
linthres = tools.math.log2lin(absthres,'dbp');

% TRUE when AMP id below ABSTHRES
bool = amp < linthres;

% Replace with NaN
amp(bool) = nan(1);
freq(bool) = nan(1);
ph(bool) = nan(1);

end
