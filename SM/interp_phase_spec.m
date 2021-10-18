function [phpeak,ph_slope,ph_intercept] = interp_phase_spec(freq,ph,freqest)
%PHASE_INTERP Linear interpolation of phase value across frequency.
%   Detailed explanation goes here

% 2016 M Caetano
% 2019 MCaetano SMT 0.1.0 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% TODO: Input NBIN NFRAME

% Number of frequency bins and number of frames
[nbin,nframe,nchannel] = size(freqest);

% Initialize interpolated phase
phpos = nan(nbin,nframe,nchannel);
phneg = nan(nbin,nframe,nchannel);
freqpos = nan(nbin,nframe,nchannel);
freqneg = nan(nbin,nframe,nchannel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PEAKS TO THE RIGHT OF FREQ.PEAK (POSITIVE RATIONAL BIN NUMBER)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Indices of positive rational bin numbers
iposbin = freqest > freq.peak;

% PH next
phpos(iposbin) = ph.next(iposbin);

% FREQ next
freqpos(iposbin) = freq.next(iposbin);

% PH peak
phneg(iposbin) = ph.peak(iposbin);

% FREQ peak
freqneg(iposbin) = freq.peak(iposbin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% freqest TO THE LEFT OF FREQ(:,:,2) (NEGATIVE RATIONAL BIN NUMBER)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Indices of negative rational bin numbers
inegbin = freqest < freq.peak;

% PH peak
phpos(inegbin) = ph.peak(inegbin);

% FREQ peak
freqpos(inegbin) = freq.peak(inegbin);

% PH prev
phneg(inegbin) = ph.prev(inegbin);

% FREQ prev
freqneg(inegbin) = freq.prev(inegbin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LINEAR INTERPOLATION OF PHASE USING 2-POINT LINE FIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Slope
ph_slope = (phpos - phneg) ./ (freqpos - freqneg);

% Linear term (intercept)
ph_intercept = (freqneg.*phpos - freqpos.*phneg) ./ (freqneg - freqpos);

% Linear interpolation of phase
phpeak = ph_slope.*freqest + ph_intercept;

end
