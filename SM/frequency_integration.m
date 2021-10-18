function [amplitude,frequency,phase] = frequency_integration(amp,freq,ph_prev,hop,fs)
%FREQUENCY_INTEGRATION Integrates the FREQUENCY of the current frame
%with the next frame into a time-varying PHASE track.
%
%   [S,PH,PART,A,F] = FREQUENCY_INTEGRATION(Ac,An,Fc,Fn,Pp,T,SR)
%   integrates the frequencies of the current and next frames of a
%   sinusoidal model into a time-varying PHASE track. The input parameters are:
%
%   Ac is the current AMPLITUDE and An is the next AMPLITUDE.
%   Fc is the current FREQUENCY and Fn is the next FREQUENCY.
%   Pp is the last PHASE value (argument of sinusoid) of the previous frame.
%   T is the time elapsed between the causalflag pf the previous frame and the
%   causalflag of the current frame (i.e., the frame advance or hop).
%   SR is the sampling rate.
%
%   S is the final synthetic signal over T.
%   P has the PHASE integrated over T.
%   PART contains the PARTIALS that comprise S when summed.
%   A has the amplitudes linearly interpolated over T.
%   F the frequencies linearly interpolated over T.
%
%
%   See also PHASE_INTERP, QUAD_INTERP, PEAK_MATCHING, PEAK_PICKING
%
%   [1] McAulay,R., Quatieri,T. (1984) Magnitude-only reconstruction using
%   a sinusoidal speech model. Proc. ICASSP. vol. 9, pp. 441-444.

% 2016 M Caetano
% 2019 MCaetano SMT 0.1.0 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% Transpose input
amp = amp';
freq = freq';
ph = ph_prev';

% Samples spanning frame advance (= hop size)
sample = (0:hop-1)';

% Linear interpolation of amplitude
% amplitude = amp(:,1) + (amp(:,2) - amp(:,1))*sample/hop;
amplitude = (1-sample/hop)*amp(1,:) + sample/hop*amp(2,:);

% Linear interpolation of frequency
% frequency = freq(:,1) + (freq(:,2) - freq(:,1))*sample/hop;
frequency = (1-sample/hop)*freq(1,:) + sample/hop*freq(2,:);

% Integrate frequency to synthesize phase
int_freq = cumsum(2*pi*frequency/fs,1,'omitnan');

% Synthesize phase
phase = sum(cat(3,repmat(ph,hop,1),int_freq),3,'omitnan');

end
