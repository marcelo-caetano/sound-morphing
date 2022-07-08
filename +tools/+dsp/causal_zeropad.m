function shift = causal_zeropad(framelen,causalflag)
%CAUSAL_ZEROPAD Zero-pad length at start and end of signal for frame processing.
%   SHIFT = CAUSAL_ZEROPAD(FRAMELEN,CAUSALFLAG) returns the length SHIFT of zero-padding
%   at the beginning and end of the signal to compensate for the position
%   of the causalflag of the first window. FRAMELEN is the length of each
%   frame. CAUSALFLAG is a flag that determines the causalflag of the first
%   analysis window. CAUSALFLAG can be 'NON', 'CAUSAL', or 'NCAUSAL'. The sample
%   CENTERWIN corresponding to the causalflag of the first window is obtained as
%   CENTERWIN = tools.dsp.tools.dsp.centerwin(M,CAUSALFLAG). Type help tools.dsp.tools.dsp.centerwin for further details.
%
%   CAUSAL_ZEROPAD is meant to be used with other frame-based processing functions
%   such as OLA, SINUSOIDAL_RESYNTHESIS_OLA, SINUSOIDAL_RESYNTHESIS_PI,
%   and SINUSOIDAL_RESYNTHESIS_PRFI.
%
%   See also OLA, SINUSOIDAL_RESYNTHESIS_OLA, SINUSOIDAL_RESYNTHESIS_PI, SINUSOIDAL_RESYNTHESIS_PRFI

% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number if input arguments
narginchk(2,2);

% Check number if output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(causalflag)
    
    case 'causal'
        
        % SHIFT is the number of zeros at the beginning and end
        shift = 0;
        
    case 'non'
        
        % SHIFT is the number of zeros at the beginning and end
        shift = tools.dsp.leftwin(framelen);
        
    case 'anti'
        
        % SHIFT is the number of zeros at the beginning and end
        shift = framelen;
        
    otherwise
        
        warning('SMT:CAUSAL_ZEROPAD:invalidFlag',...
            ['CAUSALFLAG must be CAUSAL, NON, or ANTI.\n'...
            'CAUSALFLAG entered was %s.\n'...
            'Using default value CAUSALFLAG = NON'],causalflag);
        
        % SHIFT is the number of zeros at the beginning and end
        shift = tools.dsp.leftwin(framelen);
        
end

end
