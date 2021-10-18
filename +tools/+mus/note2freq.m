function freq = note2freq(note,ref)
%NOTE2FREQ Convert note in German system to frequency in Hertz.
%   F = NOTE2FREQ(NOTE,REF) returns the frequency in Hertz corresponding
%   to N steps above the reference REF Hz using the conversion F = REF*A^N,
%   where A = 2^(1/12) for the equal tempered scale.
%
%   F = NOTE2FREQ(N) uses REF = 440 Hz as reference for A4.
%
%   NOTE must be a character array in the following format: LETTER(OPT)NUMBER
%   LETTER specifies the pitch class between A and G
%   OPT specifies that the pitch class is sharp (omit otherwise)
%   NUMBER specifies the octave between 0 and 8
%
%   Examples: A#3, G7, D0, F#6
%
%   See also FREQ2NOTE, FREQ2STEP, STEP2FREQ, STEP2NOTE, NOTE2STEP

% 2016 MCaetano (Revised)
% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,2);

% Check number of output arguments
nargoutchk(0,1);

% Default reference
if nargin == 1
    
    % A4 == 440 Hz
    ref = 440;
    
end

% Check input argument type
if ~tools.misc.istext(note)
    
    error('SMT:NOTE2FREQ:wrongTypeInputArg',['Wrong Type of Input Argument.\n'...
        'NOTE must be class CHAR not %s.\n'...
        'Type HELP NOTE2FREQ for more information.\n'],class(note))
    
end

% Check input argument type
if ~isnumeric(ref)
    
    error('SMT:NOTE2FREQ:wrongTypeInputArg',['Wrong Type of Input Argument.\n'...
        'REF must be class NUMERIC not %s.\n'...
        'Type HELP NOTE2FREQ for more information.\n'],class(ref))
    
end

% Check that pitch class is between A(=65) and G(=71)
if double(note(1)) < 65 || double(note(1)) > 71
    
    error('SMT:NOTE2FREQ:inputArgOutBound',['Input argument out of bounds.\n'...
        'NOTE(1) must be between A and G.\n'...
        'Type HELP NOTE2FREQ for more information.\n'])
    
end

% Check that octave is between 0 and 8
if str2double(note(end)) < 0 || str2double(note(end)) > 8
    
    error('SMT:NOTE2FREQ:inputArgOutBound',['Input argument out of bounds.\n'...
        'NOTE(end) must be between 0 and 8.\n'...
        'Type HELP NOTE2FREQ for more information.\n'])
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Convert from note (German system) to number of steps in equal tempered scale
step = tools.mus.note2step(note);

% Convert from number of steps in equal tempered scale to frequency in Hertz
freq = tools.mus.step2freq(step,ref);

end
