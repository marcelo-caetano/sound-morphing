function [amp,freq,ph,npart] = peak2peak_freq_matching(amplitude,frequency,phase,delta,hop,fs,nframe)
%PEAK2PEAK_FREQ_MATCHING Peak-to-peak frequency matching.
%   [Amp,Freq,Ph] = PEAK2PEAK_FREQ_MATCHING(A,F,P,DELTA,HOP,FS,NFRAME)
%   performs partial tracking using the peak-to-peak frequency matching
%   algorithm adapted from [1].
%
% [1] McAulay and Quatieri (1986) Speech Analysis/Synthesis Based on a
% Sinusoidal Representation, IEEE TRANSACTIONS ON ACOUSTICS, SPEECH,
% AND SIGNAL PROCESSING, VOL. ASSP-34, NO. 4.

% 2020 MCaetano SMT
% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% TODO: ADAPT FOR STEREO PROCESSING

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(7,7);

% Check number of output arguments
nargoutchk(0,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize variables
amp = amplitude(:,1);
freq = frequency(:,1);
ph = phase(:,1);

% Frame-to-frame frequency matching
for iframe = 2:nframe
    
    % Frequency matching
    [amp,freq,ph,npart] = freq_matching(amp,freq,ph,amplitude(:,iframe),frequency(:,iframe),phase(:,iframe),delta,hop,fs,iframe-1);
    
end

end
