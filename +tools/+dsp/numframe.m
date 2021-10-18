function nframe = numframe(nsample,framelen,hop,causalflag)
%NFRAMES Number of frames.
%   F = NUMFRAME(NSAMPLE,M,H,CAUSALFLAG) returns the number of frames F
%   that a NSAMPLE-long signal will have when split into overlapping frames
%   of length M by a hop H and first window centered at CAUSALFLAG. The
%   text flag CAUSALFLAG specifies the sample corresponding to the center
%   of the first analysis window. CAUSALFLAG can be CAUSAL, NON, or ANTI.
%
%   See also NUMSAMPLE

% 2016 M Caetano
% 2020 MCaetano SMT 0.1.1 (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% TODO: VALIDATE INPUT ARGUMENTS (NSAMPLE>0, FRAMELEN>0, HOP>0, etc)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(4,4);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Offset for causal processing
offset = tools.dsp.causal_offset(framelen,causalflag);

% Number of times HOP fits into NSAMPLE (rounded up)
nframe = ceil((nsample + offset) / hop);

end
