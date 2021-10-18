function step = note2step(note)
%NOTE2STEP Convert from note to number of steps.
%   S = NOTE2STEP(NOTE) converts the NOTE in the German system to the
%   corresponding number of steps in the equal tempered scale.
%
%   NOTE must be a character array in the following format: LETTER(OPT)NUMBER
%   LETTER specifies the pitch class between A and G
%   OPT specifies that the pitch class is sharp (omit otherwise)
%   NUMBER specifies the octave between 0 and 8
%
%   Examples: A#3, G7, D0, F#6
%
%   See also STEP2NOTE, NOTE2FREQ, FREQ2NOTE, FREQ2STEP, STEP2FREQ

% 2016 MCaetano (Revised)
% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

% Check input argument type
if ~tools.misc.istext(note)
    
    error('SMT:NOTE2STEP:wrongTypeInputArg',['Wrong Type of Input Argument.\n'...
        'NOTE must be class CHAR not %s.\n'...
        'Type HELP NOTE2STEP for more information.\n'],class(note))
    
end

% Check that pitch class is between A(=65) and G(=71)
if double(note(1)) < 65 || double(note(1)) > 71
    
    error('SMT:NOTE2STEP:inputArgOutBound',['Input argument out of bounds.\n'...
        'NOTE must be between A and G.\n'...
        'Type HELP NOTE2STEP for more information.\n'])
    
end

% Check that octave is between 0 and 8
if str2double(note(end)) < 0 || str2double(note(end)) > 8
    
    error('SMT:NOTE2STEP:inputArgOutBound',['Input argument out of bounds.\n'...
        'NOTE must be between A and G.\n'...
        'Type HELP NOTE2STEP for more information.\n'])
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read MIDI table
freqtable = readtable('ScaleFreqs.txt');

% Get matching note symbol
match = strcmp(table2cell(freqtable(:,1)),note);

% Convert into steps
step = table2array(freqtable(match,2));

end
