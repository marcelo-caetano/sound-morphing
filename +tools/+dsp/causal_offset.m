function offset = causal_offset(framelen,causalflag)
%CAUSAL_OFFSET Frame offset for causal processing.
%   OFFSET = CAUSAL_OFFSET(M,CAUSALFLAG) returns the corresponding
%   causal offset OFFSET for a given frame length M according to the text
%   flag CAUSALFLAG. OFFSET changes the initial position of the first
%   processing frame, which always starts at the first time sample. Thus
%   CAUSALFLAG determines the causality of the processing by positioning 
%   the first frame according to the three following cases:
%
%   CAUSALFLAG = CAUSAL positions the first window totally inside the
%   signal, so OFFSET = 0 for causal processing. Useful for sinusoidal
%   modeling of sustained sounds.
%
%   CAUSALFLAG = NON positions the center of the first window at the first
%   time sample, so OFFSET = -LEFTWIN for non-causal processing. Useful for
%   sinusoidal modeling of percussive sounds.
%
%   CAUSALFLAG = ANTI positions the first window totally outside the
%   signal, so OFFSET = -M for anti-causal processing commonly used for OLA
%   resynthesis.
%
%   See also CAUSAL_ZEROPAD

% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


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

% WARNING: THE OFFSETS ACTUALLY APPLY TO ZERO-PHASE PROCESSING, SO HELP IS
% MISLEADINGLY WRONG ASSUMING LINEAR-PHASE PROCESSING

switch lower(causalflag)
    
    case 'causal'
        
        offset = -(tools.dsp.rightwin(framelen) + tools.dsp.leftwin(framelen));
        
    case 'non'
        
        offset = 0;
        
    case 'anti'
        
        offset = tools.dsp.rightwin(framelen) + 1 + tools.dsp.leftwin(framelen) + 1;
        
    otherwise
        
        warning('SMT:NUMFRAME:invalidFlag',...
            ['CAUSALFLAG must be CAUSAL, NON or ANTI.\n'...
            'CAUSALFLAG entered was %s.\n'...
            'Using default CAUSALFLAG = NON'],...
            causalflag);
        
        offset = 0;
        
end

end
