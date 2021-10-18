function lh = leftwin(framelen)
%LEFTWIN First half of analysis window.
%   LH = LEFTWIN(M) returns the length LH in samples of the left half of an
%   M-sample long window generated with MKCOLAWIN. LEFTWIN excludes the
%   sample at the center of the window with sample position CW, so
%   M = LH + 1 + RH, where RH is the length of the right half of the window.
%   For odd M (symmetric around CW), LH = RH = H and M = 2*(H) + 1. For
%   even M (not symmetric around CW, RH = LH - 1 and M = 2*LH = 2*RH + 1.
%   Consequently, CW is always an integer number of samples because
%   CW = LH + 1 = M - RH.
%
%   See also RIGHTWIN, CENTERWIN, MKCOLAWIN

% 2016 MCaetano
% 2020 MCaetano SMT 0.1.1 (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check length of window and make LH accordingly
if tools.misc.iseven(framelen)
    
    lh = framelen/2;
    
else
    
    lh = (framelen-1)/2;
    
end

end
