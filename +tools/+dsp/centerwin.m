function csample = centerwin(framelen,causalflag)
%CENTERWIN Center of the first window in signal reference (samples).
%   C = CENTERWIN(FRAMELEN,CAUSALFLAG) returns the sample C at the center
%   of the first analysis window with FRAMELEN samples. CAUSALFLAG is a
%   character flag that determines the causality of the window. CAUSALFLAG
%   can be 'ANTI', 'NON', or 'CAUSAL' for anti-causal, non-causal, or
%   causal respectively. The default is CAUSALFLAG = 'NON'.
%
%   See also RIGHTWIN, LEFTWIN

% 2016 MCaetano (Revised)
% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,2);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(causalflag)
    
    case 'non'
        
        csample = 1;
        
    case 'causal'
        
        winleft = tools.dsp.leftwin(framelen);
        
        csample = winleft + 1;
        
    case 'anti'
        
        winright = tools.dsp.rightwin(framelen);
        
        csample = -winright;
        
    otherwise
        
        warning('SMT:CENTERWIN:invalidFlag',...
            ['CAUSALFLAG must be CAUSAL, NON or ANTI.\n'...
            'CAUSALFLAG entered was %s.\n'...
            'Using default CAUSALFLAG = NON'],...
            causalflag);
        
        csample = 1;
        
end

end
