function [boolprev,boolpeak,boolnext] = find_spec_peak(mag)
%FIND_SPEC_PEAK Find positions of spectral peaks.
% [PREV,PEAK,NEXT] = FIND_SPEC_PEAK(MAG) returns the positions of the
% spectral peaks in MAG as logical arrays PREV, PEAK, and NEXT. Each
% contains TRUE for
%
%   See also ISPEAK, IS3PTPEAK, IS2PTPEAK

% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Positions of spectral peaks (logical)
boolpeak = tools.sin.ispeak(mag);

% Indices of bins before the peaks (logical)
boolprev = circshift(boolpeak,-1);

% Indices of bins after the peaks (logical)
boolnext = circshift(boolpeak,1);

end
