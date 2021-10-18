function [add_synth,partial] = PI_resynthesis(amplitude,phase)
%PRFI_RESYNTHESIS Resynthesis for the PRFI method.
%   [SIN,PART] = PI_RESYNTHESIS(A,P) resynthesizes the sinusoidal
%   component SIN and its isolated partials PART from the time-varying
%   amplitudes A and phases P.
%
%   See also PRFI_RESYNTHESIS
%
% [1] McAulay and Quatieri (1986) Speech Analysis/Synthesis Based on a
% Sinusoidal Representation, IEEE TRANSACTIONS ON ACOUSTICS, SPEECH,
% AND SIGNAL PROCESSING, VOL. ASSP-34, NO. 4.

% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% Synthesize partials
% WARNING! Synthesis with sine misses the PHASE offset of the original waveform
partial = amplitude.*cos(phase);

% Add partials
add_synth = sum(partial,2,'omitnan');

end
