function hop = hopsize(framelen,overlap)
%HOPSIZE Hop size corresponding to overlap.
%   H = HOPSIZE(FRAMELEN) returns the hop size H corresponding to 50%
%   overlap of consecutive frames.
%
%   H = HOPSIZE(FRAMELEN,OVERLAP) returns H corresponding to consecutive
%   frames overlapping by 0 <= OVERLAP < 1. OVERLAP = 0 means no overlap,
%   so the frames will be adjacent with H = FRAMELEN. Note that OVERLAP = 1
%   is not allowed because it implies H = 0.
%
%   See also FRAMESIZE, FFTSIZE, CEPSORDER

% 2020 MCaetano SMT 0.1.1
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of input arguments
narginchk(1,2);

% Number of output arguments
nargoutchk(0,1);

if nargin == 1
    
    overlap = 0.5;
    
end

% Edge case OVERLAP = 1 - 1e-16 (lower values OVERLAP == 1)
if overlap < 0 || overlap >= 1
    
    warning('SMT:HOPSIZE:InvalidInputArgument',['OVERLAP must be between 0 and 1.\n'...
        'Value entered was %2.5g.\n'...
        'Using default value OVERLAP = 0.5\n'],overlap);
    
    overlap = 0.5;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Remaining fraction
frac = 1 - overlap;

% CEIL guarantees that OVERLAP >= 1 - 1e-16 results in HOP === 1
hop = ceil(frac * framelen);

end
