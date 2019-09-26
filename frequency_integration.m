function [addsynth,phase,partials,amplitude,frequency] = frequency_integration(amp_curr,amp_next,freq_curr,freq_next,phase_prev,hopsize,sr)
%PARAMETER_INTERPOLATION Interpolates the parameters of the current frame
%with the next frame.
%
%   [S,P,H,A,F] = FREQUENCY_INTEGRATION(Ac,An,Fc,Fn,Pp,T,SR)
%   interpolates the parameters of the current and next frames of a
%   sinusoidal model. The input parameters are:
%
%   Ac is the current amplitude and An is the next amplitude.
%   Fc is the current frequency and Fn is the next frequency.
%   Pp is the last phase value (argument of sinusoid) of the previous frame.
%   T is the time elapsed between the center pf the previous frame and the
%   center of the current frame (i.e., the frame advance or hopsize).
%   SR is the sampling rate.
%
%   S is the final synthetic signal over T.
%   P has the phase integrated over T.
%   H contains the partials that comprise S when summed.
%   A has the amplitudes linearly interpolated over T.
%   F the frequencies linearly interpolated over T.
%
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
    
    % Linear interpolation of amplitude
    amplitude(:,ipartial) = amp_curr(ipartial) + (amp_next(ipartial) - amp_curr(ipartial))*samples/hopsize;
    
    % Linear interpolation of frequency
    frequency(:,ipartial) = freq_curr(ipartial) + (freq_next(ipartial) - freq_curr(ipartial))*samples/hopsize;
    
    % Synthesize phase
    phase(:,ipartial) = phase_prev(ipartial) + cumsum(2*pi*frequency(:,ipartial)/sr);
    
    % Synthesize partial
    % partials(:,ipartial) = 2*amplitude(:,ipartial).*cos(phase(:,ipartial));
    partials(:,ipartial) = 2*amplitude(:,ipartial).*sin(phase(:,ipartial));
    
    % Add partial to final synthesis
    addsynth = addsynth + partials(:,ipartial);
    
end

end