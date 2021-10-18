function framelen = framesize(f0,fs,mult,f0flag)
%FRAMESIZE Returns the frame size.
%   M = FRAMESIZE(F0,Fs) returns the frame size M corresponding to 3
%   periods of the fundamental frequency F0 at a sampling frequency Fs. The
%   period is T0 = Fs/F0 samples, so M = ceil(3*Fs/F0). F0 can be a scalar
%   or a multidimensional array.
%
%   M = FRAMESIZE(F0,Fs,MULT) returns M = ceil(MULT*Fs/F0), where MULT must
%   be a non-negative integer. Otherwise, MULT falls back to the default
%   value of MULT = 3.
%
%   M = FRAMESIZE(F0,Fs,MULT,FOFLAG) uses the logical flag F0FLAG to
%   specify if the reference f0 is calculated as the MEDIAN or the MEAN.
%   The default value F0FLAG = FALSE uses MEDIAN whereas F0FLAG = TRUE uses
%   mean.
%
%   See also HOPSIZE, FFTSIZE, tools.ceps.CEPSORDER

% 2020 MCaetano SMT
% 2021 M Caetano SMT (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,4);

% Check number of output arguments
nargoutchk(0,1);

% Default input arguments
if nargin == 2
    
    % Fallback to default value
    mult = 3;
    
    % Fallback to default value
    f0flag = false;
    
elseif nargin == 3
    
    % Fallback to default value
    f0flag = false;
    
end

% If Fs is neither a scalar nor a positive integer
if numel(fs) ~= 1 || fs <= 0 || tools.misc.isfrac(fs)
    
    warning('SMT:FRAMESIZE:invalidInputArgument',...
        ['Fs must be a scalar positive integer.\n'...
        'Value entered was %6.2f. Rounding off Fs\n'],fs);
    
    % WARNING: Fs == 0 breaks this line
    fs = max(abs(ceil(fs)));
    
end

% If MULT is neither a scalar nor a positive integer
if numel(mult) ~= 1 || mult <= 0 || tools.misc.isfrac(mult)
    
    [nrow,ncol] = size(mult);
    
    warning('SMT:FRAMESIZE:invalidInputArgument',...
        ['MULT must be a non-negative integer scalar.\n'...
        'MULT entered was size %d x %d.'...
        'Using default value MULT = 3.\n'],nrow,ncol);
    
    % Fallback to default value
    mult = 3;
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reference f0 value
ref0 = tools.f0.reference_f0(f0,f0flag);

% Frame size
framelen = ceil(mult*fs/ref0);

end
