function [amplitude,frequency,phase] = parameter_interpolation(amp,freq,ph,hop,fs)
%PARAMETER_INTERPOLATION Interpolates the parameters of the current frame
%with the next frame.
%
%   [A,F,P] = PARAMETER_INTERPOLATION(Ac,An,Fc,Fn,Pc,Pn,H,SR)
%   interpolates the parameters of the current and next frames of a
%   sinusoidal model. The input parameters are:
%
%   Ac is the current amplitude and An is the next amplitude.
%   Fc is the current frequency and Fn is the next frequency.
%   Pc is the current PHASE and Pn is the next PHASE (argument of sinusoid).
%   H is the hop size corresponding to the advance between frames.
%   Fs is the sampling rate.
%
%   A has the interpolated amplitudes, F the interpolated frequencies, and
%   P the interpolated phases.
%
%   Ac and An are linearly interpolated and Pc and Pn are interpolated
%   cubically.
%
%   See also PHASE_INTERP, QUAD_INTERP, PEAK_MATCHING, PEAK_PICKING
%
% [1] McAulay and Quatieri (1986) Speech Analysis/Synthesis Based on a
% Sinusoidal Representation, IEEE Transactions on Acoustics,
% Speech, and Signal Processing ASSP-34(4),744-754.

% 2016 M Caetano
% Revised 2019 (SM 0.1.1)
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% Transpose input
amp = amp';
freq = freq';
ph = ph';

% Create column vector of time samples
sample = (0:hop-1)';

% Synthesize linear AMPLITUDE
% amplitude = amp(:,1) + (amp(:,2) - amp(:,1))*sample/hop;
amplitude = (1-sample/hop)*amp(1,:) + sample/hop*amp(2,:);

% Calculate PHASE interpolation unwrapping
% interp_unwrap = round( ((ph(:,1) + 2*pi*freq(:,1)*hop/fs - ph(:,2)) + pi*(freq(:,2) - freq(:,1))*hop/fs)/(2*pi) );
interp_unwrap = round( ((ph(1,:) - ph(2,:)) + (pi*hop/fs)*(freq(1,:) + freq(2,:)))/(2*pi) );

% Calculate quadratic PHASE coefficient ALPHA
alpha = (3/hop^2)*( ph(2,:) - ph(1,:) - 2*pi*freq(1,:)*hop/fs + 2*pi*interp_unwrap ) + (-1/hop)*( freq(2,:) - freq(1,:) )*(2*pi/fs);

% Calculate cubic PHASE coefficient BETA
beta = (-2/(hop^3))*(ph(2,:)-ph(1,:)-2*pi*freq(1,:)*hop/fs+2*pi*interp_unwrap) + (1/(hop^2))*(freq(2,:)-freq(1,:))*(2*pi/fs);

% Synthesize quadratic frequency
frequency = 2*pi*repmat(freq(1,:),hop,1) + 2*sample*alpha + 3*(sample.^2)*beta;

% Synthesize cubic PHASE
phase = repmat(ph(1,:),hop,1) + 2*pi*sample*freq(1,:)/fs + (sample.^2)*alpha + (sample.^3)*beta;

end
