function sample = frame2sample(frame,center_win,hop)
%FRAME2SAMPLE Convert time frame to time sample number.
%   S = FRAME2SAMPLE(FR,CENTERWIN,H) returns the samples S at the center of
%   the time frames FR obtained with an M-sample long window sliding by a
%   hopsize of H samples. The sample S(1) corresponding to the center of
%   the first window is obtained as CENTERWIN = CENTER_FIRST_WIN(M,CAUSALFLAG),
%   CAUSALFLAG is a text flag that specifies the causality of the first
%   window as 'NON', 'CAUSAL', or 'ANTI'.
%
%   See also SAMPLE2FRAME

% 2016 M Caetano
% 2020 MCaetano SMT 0.1.1 (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(3,3);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Return sample number (column vector)
sample = center_win + (frame(:) - 1) .* hop;

end
