function magspec = scaled_mag_spec2lin_mag_spec(scaled_magspec,pow,logflag,paramestflag)
%SCALED_MAG_SPEC2LIN_MAG_SPEC From scaled to linear magnitude spectrum.
%   MAGSPEC = SCALED_MAG_SPEC2LIN_MAG_SPEC(SMAGSPEC,P,LOGFLAG,PARAMESTFLAG)
%   reverts the scaling of the magnitude spectrum SMAGSPEC determined by
%   PARAMESTFLAG, a text flag that indicates the parameter estimation
%   method used. PARAMESTFLAG can be 'NNE', 'LIN', 'LOG', or 'POW'. P is
%   the exponent used to scale SMAGSPEC when PARAMESTFLAG = 'POW'. P is
%   ignored unless PARAMESTFLAG = 'POW'. LOGFLAG is a text flag that
%   indicates the logarithmic scale. LOGFLAG can be 'DBR' for decibel
%   root-power, 'DBP' for decibel power, 'BEL' for bels, 'NEP' for neper,
%   and 'OCT' for octave. DBR uses 10*log10, DBP uses 20*log10, BEL uses
%   log10, NEP uses ln, and OCT uses log2. LOGFLAG is ignored unless
%   PARAMESTFLAG = 'LOG'.
%
%   See also MAG_SPEC_SCALING

% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


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

% Unscale the magnitude spectrum
switch lower(paramestflag)
    
    case {'nne','lin'}
        
        % No need to revert
        magspec = scaled_magspec;
        
    case 'log'
        
        % From log to linear
        magspec = tools.math.log2lin(scaled_magspec,logflag);
        
    case 'pow'
        
        % From power to linear
        magspec = tools.math.pow2lin(scaled_magspec,pow);
        
    otherwise
        
        warning('SMT:SCALED_MAG_SPEC2LIN_MAG_SPEC:invalidFlag',...
            ['Invalid Magnitude Scaling Flag.\n'...
            'PARAMESTFLAG must be LOG, LIN, or P.\n'...
            'PARAMESTFLAG entered was %d.\n'...
            'Using default PARAMESTFLAG = LOG.\n'],paramestflag)
        
        % From log to linear
        magspec = tools.math.log2lin(scaled_magspec,logflag);
        
end

end

