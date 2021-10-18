function pow = xqifft(framelen,winflag)
%XQIFFT Power scaling factor for XQIFFT.
%   P = XQIFFT(M,WINFLAG) returns the optimal power scale P for the window
%   size M of the window of type WINDOWFLAG for the estimation of the
%   parameters amplitude A and frequency F of underlying sinusoids via
%   quadratic interpolation over peaks of the magnitude spectrum.
%
%   See also INTERP_POW_SCALING
%
% Experimental data from Werner & Germain "Sinusoidal Parameter Estimation
% Using Quadratic Interpolation Around Power-Scaled Magnitude Spectrum
% Peaks" Appl. Sci. 2016, 306.

% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% TODO: CHECK INPUT ARGUMENTS (NaN,class, etc)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,2);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load pre-calculated data
XQIFFT = load('xqifft.mat');

% TRUE when data contains same value as FRAMELEN
bool = framelen==XQIFFT.framelen;

switch winflag
    
    case 1
        
        pow = 1;
        
    case {2,3,4,5,6,7,8,9,10,11,12,13,14}
        
        pow = interpolateTabulatedValue(XQIFFT.T,framelen,winflag,bool);
        
    otherwise
        
        warning('SMT:XQIFFT:InvalidArgument',['Invalid flag WINFLAG.'...
            'WINFLAG entered was %d\n'...
            'Valid WINFLAG ranges between 1 and 14.\n'...
            'Using default Blackman-Harris window.\n'],winflag)
        
        winflag = 6;
        
        pow = interpolateTabulatedValue(XQIFFT.T,framelen,winflag,bool);
        
end

end

% Local function
function p = interpolateTabulatedValue(dtable,flen,wflag,istabulated)

if any(istabulated)
    
    p = dtable{wflag,2:5}(istabulated);
    
else
    
    p = interp_pow_scaling(dtable,flen,wflag);
    
end

end
