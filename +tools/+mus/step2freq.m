function freq = step2freq(step,ref)
%STEP2FREQ Number of steps to frequency in Hertz.
%   F = STEP2FREQ(N,REF) returns the frequency in Hertz corresponding
%   to N steps above the reference REF Hz using the conversion F = REF*A^N,
%   where A = 2^(1/12) for the equal tempered scale.
%
%   F = STEP2FREQ(N) uses REF = 440 Hz as reference for A4.
%
%   See also FREQ2STEP, NOTE2FREQ, FREQ2NOTE, STEP2NOTE

% 2016 MCaetano (Revised)
% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,2);

% Check number of output arguments
nargoutchk(0,1);

% Check number of input arguments
if nargin == 1
    
    % A4 == 440 Hz
    ref = 440;
    
end

% Check input argument type
if ~isnumeric(step)
    
    error('TypeInArg:wrongType',['Wrong Type of Input Argument.\n'...
        'X must be class NUMERIC not %s.\n'...
        'Type HELP STEP2FREQ for more information.\n'],class(step))
    
end

% Check input argument type
if ~isnumeric(ref)
    
    error('TypeInArg:wrongType',['Wrong Type of Input Argument.\n'...
        'REF must be class NUMERIC not %s.\n'...
        'Type HELP STEP2FREQ for more information.\n'],class(ref))
    
end

% Check if number of steps is integer
if rem(step,1) ~= 0
    
    error('TypeInArg:wrongType',['Wrong Type of Input Argument.\n'...
        'STEP must be an integer.\n'...
        'Type HELP STEP2FREQ for more information.\n'])
    
end

% Check max and min number of steps
if step < -57 || step > 50
    
    error('ValInArg:outBound',['Input argument out of bounds.\n'...
        'STEP must be between -48 and 59.\n'...
        'Type HELP STEP2FREQ for more information.\n'])
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Conversion
freq = ref*2^(step/12);

end
