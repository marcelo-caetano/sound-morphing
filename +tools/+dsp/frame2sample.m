function sample = frame2sample(frame,framelen,hop,causalflag)
%FRAME2SAMPLE Convert frame number to time sample.
%   S = FRAME2SAMPLE(FR,M,H,CAUSALFLAG) returns the time samples S
%   corresponding to the center of the frames FR obtained with an M-sample
%   long window sliding by a hopsize of H samples. The text flag CAUSALFLAG
%   specifies the causality of the first window as 'NON', 'CAUSAL', or 'ANTI'.
%
%   See also SAMPLE2FRAME

% 2016 M Caetano
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


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

center_win = tools.dsp.centerwin(framelen,causalflag);

sample = center_win + (frame - 1) .* hop;

end
