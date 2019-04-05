function [addsynth,partials,amplitude,frequency] = parameter_interpolation(amp_curr,amp_next,freq_curr,freq_next,phase_curr,phase_next,hopsize,sr)
%PARAMETER_INTERPOLATION Interpolates the parameters of the current frame
%with the next frame.
%
%   [S,T,A,P] = PARAMETER_INTERPOLATION(Ac,An,Fc,Fn,Pc,Pn,T,SR)
%   interpolates the parameters of the current and next frames of a
%   sinusoidal model. The input parameters are:
%
%   Ac is the current amplitude and An is the next amplitude.
%   Fc is the current frequency and Fn is the next frequency.
%   Pc is the current phase and Pn is the next phase (argument of sinusoid).
%   T is the period corresponding to the end of the frame.
%   SR is the sampling rate.
%
%   S is the final synthetic signal inside the frame.
%   T contains the partials that comprise S when summed.
%   A has the interpolated amplitudes and P the interpolated phases.
%
%   Ac and An are linearly interpolated and Pc and Pn are interpolated
%   cubically.
%
%   See also PHASE_INTERP, QUAD_INTERP, PEAK_MATCHING, PEAK_PICKING

% Number of partials
npartial = length(amp_curr);

% Samples spanning frame advance (= hop size)
samples = (0:hopsize-1)';

% Initialize variables
partials = zeros(hopsize,npartial);
amplitude = zeros(hopsize,npartial);
frequency = zeros(hopsize,npartial);
phase = zeros(hopsize,npartial);
addsynth = zeros(hopsize,1);

for ipartial = 1:npartial
    
    % Synthesize linear amplitude
    amplitude(:,ipartial) = amp_curr(ipartial) + (amp_next(ipartial) - amp_curr(ipartial))*samples/hopsize;
    
    % Calculate M (phase interpolation unwrapping)
    M = round(((phase_curr(ipartial) + freq_curr(ipartial)*2*pi*hopsize/sr - phase_next(ipartial))+(freq_next(ipartial)...
        - freq_curr(ipartial))*pi*hopsize/sr)/(2*pi));
    
    % Calculate alpha
    alpha = (3/(hopsize^2))*(phase_next(ipartial) - phase_curr(ipartial) - freq_curr(ipartial)*2*pi*hopsize/sr + 2*pi*M)...
        + (-1/hopsize)*(freq_next(ipartial) - freq_curr(ipartial))*(2*pi/sr);
    
    % Calculate beta
    beta = (-2/(hopsize^3))*(phase_next(ipartial) - phase_curr(ipartial) - freq_curr(ipartial)*2*pi*hopsize/sr + 2*pi*M)...
        + (1/(hopsize^2))*(freq_next(ipartial) - freq_curr(ipartial))*(2*pi/sr);
    
    % Synthesize quadratic frequency
    frequency(:,ipartial) = freq_curr(ipartial)*2*pi + 2*alpha*(samples) + 3*beta*(samples.^2);
    
    % Synthesize cubic phase
    phase(:,ipartial) = phase_curr(ipartial) + freq_curr(ipartial)*2*pi*samples/sr + alpha*(samples.^2) + beta*(samples.^3);
    
    % Synthesize partial
    partials(:,ipartial) = 2*amplitude(:,ipartial).*cos(phase(:,ipartial));
    % Synthesis with sine misses the phase offset of the original waveform
    % partials(:,ipartial) = 2*amplitude(:,ipartial).*sin(phase(:,ipartial));
    
    
    % Add partial to final synthesis
    addsynth = addsynth + partials(:,ipartial);
    
end

end