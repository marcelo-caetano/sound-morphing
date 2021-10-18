function [addsynth,partial] = OLA_resynthesis(amplitude,phase,synthwin)
%OLA_RESYNTHESIS Resynthesis for the OLA method.
%   [SIN,PART] = PI_RESYNTHESIS(A,P,SWIN) resynthesizes the sinusoidal
%   component SIN and its isolated partials PART from the time-varying
%   amplitudes A and phases P. Each frame is amplitude modulated by the
%   synthesis window SWIN.
%
%   See also PI_RESYNTHESIS, PRFI_RESYNTHESIS

% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(3,3);

% Check number of output arguments
nargoutchk(0,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Synthesize partials
% WARNING! Synthesis with SIN misses the PHASE offset of the original waveform
partial = amplitude.*cos(phase);

% Add partials
addsynth = synthwin.*sum(partial,2,'omitnan');

end
