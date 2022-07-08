function [addsynth,partial] = PRFI_resynthesis(amplitude,phase)
%PRFI_RESYNTHESIS Resynthesis for the PRFI method.
%   [SIN,PART] = PRFI_RESYNTHESIS(A,P) resynthesizes the sinusoidal
%   component SIN and its isolated partials PART from the time-varying
%   amplitudes A and phases P.
%
%   See also PI_RESYNTHESIS
%
% [1] McAulay,R., Quatieri,T. (1984) Magnitude-only reconstruction using
% a sinusoidal speech model. Proc. ICASSP. vol. 9, pp. 441-444.

% 2020 MCaetano SMT 0.2.0
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


% Synthesize partials
% WARNING! Synthesis with cosine misses the PHASE continuation correction
partial = amplitude.*sin(phase);

% Add partials
addsynth = sum(partial,2,'omitnan');

end
