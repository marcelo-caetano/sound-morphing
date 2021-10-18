function [amp,freq,ph] = reldb(amp,freq,ph,relthres)
%RELDB Set the relative threshold in dB.
%   [A,F,P] = RELDB(A,F,P,RELTHRES) sets the amplitudes A, frequencies F,
%   and phases P that are RELTHRES below the maximum of each frame to NaN.
%
%   See also ABSDB

% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
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

% Maximum amplitude per frame
maxamp = max(amp,[],1,'omitnan');

% Sum in dB
relampdB = tools.math.lin2log(maxamp,'dbp') - abs(relthres);

% Convert RELAMPDB in dB to linear
relamplin = tools.math.log2lin(relampdB,'dbp');

% TRUE when AMP is below RELAMPLIN
bool = amp < relamplin;

% Replace with NaN
amp(bool) = nan(1);
freq(bool) = nan(1);
ph(bool) = nan(1);

end
