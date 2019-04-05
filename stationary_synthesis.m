function [addsynth,partials,amplitude,phase_argument] = stationary_synthesis(amp,freq,phase,winlen,sr,wintype,cfr)
%STATIONARY_SYNTHESIS synthesize stationary sinusoid inside frame.
%
%   [Add] = STATIONARY_SYNTHESIS(A,F,P,T,SR)
%   Synthesize each partial as s(n) = A*cos(2*pi*F*T/SR + Theta)
%   Theta is the phase shift calculated as Theta = P - 2*pi*f*T/SR

% Number of partials
npartial = length(amp);

% Make samples spanning frame winlen
samples = (cfr-lhw(winlen):cfr+rhw(winlen))';

% Make analysis window
synthwin = gencolawin(winlen,wintype);

% Initialize variables
partials = zeros(winlen,npartial);
amplitude = zeros(winlen,npartial);
phase_argument = zeros(winlen,npartial);
addsynth = zeros(winlen,1);
phase_shift = zeros(npartial,1);

for ipartial = 1:npartial
    
    % Synthesize constant amplitude vector
    % amplitude(:,ipartial) = 2*amp(ipartial)*ones(winlen,1);
    
    % Calculate phase shift (using center of frame as reference)
    phase_shift(ipartial) = phase(ipartial) - freq(ipartial)*2*pi*cfr/sr;
    
    % Synthesize phase argument
    phase_argument(:,ipartial) = freq(ipartial)*2*pi*samples/sr + phase_shift(ipartial);
    
    % Synthesize partial
    partials(:,ipartial) = 2*amp(ipartial)*cos(phase_argument(:,ipartial));
    % partials(:,ipartial) = amplitude(:,ipartial).*cos(phase_argument(:,ipartial)).*synthwin;
    
    % Add partial to final synthesis
    addsynth = addsynth + partials(:,ipartial);
    
end

addsynth = addsynth.*synthwin;

end