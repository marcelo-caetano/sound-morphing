function [amp,freq,ph,npart] = partial_tracking(amplitude,frequency,phase,delta,hop,fs,nframe,trackflag)
%PARTIAL_TRACKING Partial tracking for spectral modeling sinusoidal analysis.
%   [A,F,P,NPART] = PARTIAL_TRACKING(AMP,FREQ,PH,DELTA,H,Fs,NFR,TRACKFLAG)
%   performs partial tracking on the spectral peaks contained in AMP, FREQ,
%   and PH. DELTA determines the maximum frequency difference for peak
%   continuation as described in [1]. H is the analysis hop size, Fs is the
%   sampling frequency, and NFR is the total number of frames as returned
%   by the function NUMFRAME. Type HELP NUMFRAME for further information.
%
%   TRACKFLAG determines the partial tracking algorithm used. The options are
%
%   P2P peak-to-peak frequency tracking adapted from [1].
%
%   See also PEAK2PEAK
%
% [1] McAulay and Quatieri (1986) Speech Analysis/Synthesis Based on a
% Sinusoidal Representation, IEEE TRANSACTIONS ON ACOUSTICS, SPEECH,
% AND SIGNAL PROCESSING, VOL. ASSP-34, NO. 4.

% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(8,8);

% Check number of output arguments
nargoutchk(0,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(trackflag)
    
    case 'p2p'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % PEAK TO PEAK MATCHING
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        [amp,freq,ph,npart] = peak2peak_freq_matching(amplitude,frequency,phase,delta,hop,fs,nframe);
        
        
    otherwise
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % PEAK TO PEAK MATCHING
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        [amp,freq,ph,npart] = peak2peak_freq_matching(amplitude,frequency,phase,delta,hop,fs,nframe);
        
end

end
