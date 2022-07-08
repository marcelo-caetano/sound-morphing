function [aestim,festim] = interp_mag_spec(amp,freq)
%INTERP_MAG_SPEC Quadratic interpolation of the magnitude spectrum.
%   [AMPEST,FREQEST] = INTERP_MAG_SPEC(A,F) returns the amplitude
%   estimation AMPEST and the frequency estimation FREQEST obtained by
%   quadratic interpolation of the frequencies F and amplitudes A
%   corresponding to the spectral peaks.
%
%   See also INTERP_PHASE_SPEC

% 2016 M Caetano
% Revised 2019 SMT 0.1.1
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,2);

% Check number of output arguments
nargoutchk(0,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[festim,aestim] = tools.math.quadfit(freq.prev,freq.peak,freq.next,amp.prev,amp.peak,amp.next);

end
