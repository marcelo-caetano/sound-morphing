function nfft = fftsize(framelen,ovsamplfac)
%FFTSIZE Return size of the FFT as power of two.
%   NFFT = FFTSIZE(FRAMELEN) returns the FFT size NFFT that corresponds to
%   the next power of two greater than FRAMELEN. FRAMELEN must be integer.
%   NFFT = 2^NEXTPOW2(FRAMELEN)
%
%   NFFT = FFTSIZE(FRANELEN,OVFAC) uses the integer OVFAC as oversampling
%   factor to calculate the oversampled NFFT as
%   NFFT = 2^(NEXTPOW2(FRAMELEN) + OVFAC).
%
%   See also FRAMESIZE, HOPSIZE, CEPSORDER

% 2020 MCaetano SMT 0.1.1
% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,2);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 1
    
    % Oversampling factor
    ovsamplfac = 0;
    
end

%numel == 1
if numel(framelen) ~= 1
    
    warning('SMT:FFTSIZE:InvalidInputArgValue',['FRAMELEN must be a scalar.\n'...
        'Value entered was %2.5g.\n'
        'Using default value NFFT = 1024.'],framelen);
    
    framelen = 1024;
    
end

% Must be integer
if tools.misc.isfrac(framelen)
    
    warning('SMT:FFTSIZE:InvalidInputArgValue',['FRAMELEN must be integer.\n'...
        'Value entered was %2.5g.\n'...
        'Rounding off FRAMELEN.'],framelen);
    
    framelen = ceil(framelen);
    
end

% Must be numeric
if ~isnumeric(framelen)
    
    warning('SMT:FFTSIZE:InvalidInputArgValue',['FRAMELEN must be numerical.\n'...
        'Class of FRAMELEN entered was %s.\n'
        'Using default value NFFT = 1024.'],...
        class(framelen));
    
    framelen = 1024;
    
end

%isfinite
if ~isfinite(framelen)
    
    warning('SMT:FFTSIZE:invalidInputArgument',['FRAMELEN must be finite.\n'...
        'Using default value NFFT = 1024.']);
    
    framelen = 1024;
    
end

%ispositive
if framelen <= 0
    
    warning('SMT:FFTSIZE:InvalidInputArgValue',['FRAMELEN must be positive.\n'...
        'Value entered was %2.5g.\n'...
        'Using default value NFFT = 1024.'],framelen);
    
    framelen = 1024;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate next power of 2 larger than FRAMELEN
pow = nextpow2(framelen);

% Add oversampling factor to exponent
finalpow = pow + ovsamplfac;

% Calculate NFFT
nfft = pow2(finalpow);

end
