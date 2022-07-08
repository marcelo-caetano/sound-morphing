function delta = freq_diff4peak_matching(fundfreq,mult)
%FREQ_DIFF4PEAK_MATCHING Frequency difference for peak matching.
%   DELTA = FREQ_DIFF4PEAK_MATCHING(F0) returns the frequency difference
%   for peak matching DELTA used internally in PEAK2PEAK_FREQ_MATCHING as
%   DELTA = 0.5*F0. For harmonic sounds, DELTA is set as half the distance
%   between the harmonics.
%
%   DELTA = FREQ_DIFF4PEAK_MATCHING(F0,MULT) uses MULT as the multiplier.
%   Typically, 0 < MULT <= 0.5.
%
%   See also FRAMESIZE, HOPSIZE, FFTSIZE

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of input arguments
narginchk(1,2);

% Number of output arguments
nargoutchk(0,1);

% Default input arguments
if nargin == 1
    
    mult = 0.5;
    
end

if mult <= 0 || mult > 0.5
    
    warning('SMT:FREQ_DIFF4PEAK_MATCHING:invalidInputArgument',...
        ['MULT must be greater than zero and less than 0.5.\n'...
        'Value entered was %2.5f\n'...
        'Using default MULT = 0.5.\n'],mult)
    
    mult = 0.5;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delta = fix(fundfreq*mult);

end
