function frame = sample2frame(sample,center_win,hop)
%SAMPLE2FRAME Convert time sample to time frame number.
%   FR = SAMPLE2FRAME(S,CENTERWIN,H) returns the time frame numbers FR
%   corresponding to the center of an M-sample long window sliding by a
%   hopsize of H samples. The sample S(1) corresponding to the center of
%   the first window is CENTERWIN = CENTER_FIRST_WIN(M,CAUSALFLAG),
%   CAUSALFLAG is a text flag that specifies the causality of the first
%   window as 'NON', 'CAUSAL', or 'ANTI'.
%
%   See also FRAME2SAMPLE

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

% Return frame number (column vector)
frame = (sample(:) - center_win) ./ hop + 1;

end
