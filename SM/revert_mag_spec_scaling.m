function magspec = revert_mag_spec_scaling(scaled_magspec,framelen,winflag,paramestflag)
%REVERT_MAG_SPEC_SCALING Revert scaling of magnitude spectrum.
%   MAGSPEC = REVERT_MAG_SPEC_SCALING(SMAGSPEC,M,WINFLAG,PARAMESTFLAG)
%   reverts the scaling of the magnitude spectrum SMAGSPEC determined by
%   PARAMESTFLAG, a text flag that indicates the parameter estimation
%   method used. PARAMESTFLAG can be 'NNE', 'LIN', 'LOG', or 'POW'.
%   FRAMELEN is the frame length and WINFLAG is a numerical flag that
%   determines the analysis window used. Both are only used to calculate
%   POW internally.
%
%   See also MAG_SPEC_SCALING

% 2021 M Caetano SMT (Revised)
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

% Default log scale dB power
logflag = 'dbp';

if strcmpi(paramestflag,'pow')
    
    % Default power scaling
    pow = xqifft(framelen,winflag);
    
else
    
    pow = 1;
    
end

magspec = tools.fft2.scaled_mag_spec2lin_mag_spec(scaled_magspec,pow,logflag,paramestflag);

end
