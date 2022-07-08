function tsm = solafs(wav,framelen,synth_hop,maxcorr,alpha,causalflag)
%SOLAFS Synchronous overlap-add with fixed synthesis step.
%   SOLAFS is an implementation of the synchronous overlap-add with fixed
%   synthesis (SOLA-FS) time scale modification algorithm. SOLA-FS adapts
%   the analysis hop size according to the correlation of the current time
%   frame with the previous frame and resynthesizes the time scaled version
%   by overlap-adding the frames with a fixed OLA synthesis hop size.
%
%   TSM = SOLAFS(S,M,H,MAXCORR,ALPHA,CAUSALFLAG) splits the input signal S
%   into overlapping frames of size M with a hop size of H and returns the
%   time scaled signal TSM. MAXCORR is the maximum range of the correlation
%   in samples. ALPHA is the time scaling factor. ALPHA > 1 stretches and
%   ALPHA < 1 compresses. CAUSALFLAG is a flag the determines the causalflag of
%   the first analysis window. CAUSALFLAG can be NON, CAUSAL, or NCAUSAL.
%
%   See also OLAFS, SOFFS

% 2016 MCaetano (Revised)
% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPLIT WAV INTO OVERLAPPING FRAMES OF FRAMELEN SEPARATED BY ANALYSIS HOPSIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[time_frame,nsample] = soffs(wav,framelen,synth_hop,maxcorr,alpha,causalflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OVERLAP-ADD RESULT WITH SYNTHESIS HOPSIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tsm = olafs(time_frame,framelen,synth_hop,fix(alpha*nsample),causalflag);

end
