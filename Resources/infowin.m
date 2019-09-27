function [argout] = infowin(wintype,infoflag)
%INFOWIN stores information about windows.
%   [OUT] = INFOWIN(WINTYPE, INFOFLAG) returns information about the
%   WINTYPE window specified by INFOFLAG. WINTYPE must be numeric ranging
%   between 1 and 7. Type HELP WHICHWIN for the names of the different
%   windows supported.
%
%   INFOFLAG must be one of the character arrays below specifying ARGOUT.
%
%   NAME window name.
%   INFOFLAG NAME outputs a character array with the name of the window
%   that corresponds to the
%
%   DEN constant overlap-add (COLA) denominator.
%   A WINTYPE window is COLA(R) if it has the constant overlap-add
%   property at hop size R = M/DEN, expressed as a fraction of the window
%   size M.
%
%   SUM constant amplitude COLA.
%   A WINTYPE window sums to a constant factor SUM when overlap-added at
%   COLA(R).
%
%   MLW main lobe width in frequency bins.
%   MLW is the width of the main-lobe of a WINTYPE window in frequency
%   bins.
%
%   SLL highest side-lobe level in dB.
%   SLL is the amplitude in dB of the second side-lobe for a WINTYPE
%   window. SLL is related to the minimum amplitude a nearby sinusoid can
%   have to be detected.
%
%   SLFO side-lobe fall-off in dB per octave.
%   The SLFO is the rate in dB at which the amplitude of the spectral
%   side-lobes attenuate per octave for a WINTYPE window.
%
%   See also WHICHWIN

% M Caetano
%
% References
%
% Harris, F.J.'On the Use of Windows for Harmonic Analysis with the
% Discrete Fourier Transform,' Proc. IEEE, 66(1), 1978.
%
% Smith, J.O.'Spectral Audio Signal Processing', W3K Publishing, 2011,
% ISBN 978-0-9745607-3-1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
if nargin ~= 2
    % Trow error
    error(['Not enough or too many input arguments.\n'...
        'Number of input arguments entered was %d.\n'...
        'The function INFOWIN takes 2 input arguments.\n'...
        'Type HELP INFOWIN for more information.\n'],nargin)
end

% Check class of input arguments
if not(isnumeric(wintype))
    error(['WrongClass: Input argument WINTYPE must be numeric.\n'...
        'Input argument entered is %s.\n'...
        'WINTYPE must be a number between 1 and 7.\n'...
        'Type HELP WHICHWIN for more information.\n'],class(wintype))
end

if not(ischar(infoflag))
    error(['WrongClass: Input argument INFOFLAG must be a character.\n'...
        'Input argument entered is %s.\n'...
        'INFOFLAG is a character that specifies the output of INFOWIN.\n'...
        'Type HELP INFOWIN for more information.\n'],class(infoflag))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch wintype
    case 1
        
        % RECTANGULAR R=M
        % Constant overlap-add (COLA) denominator
        den = 1;
        % COLA sum
        sumfactor = 1;
        % Main lobe width (frequency bins)
        mlw = 2;
        % Highest side-lobe level (dB)
        sll = 13;
        % Side-lobe fall-off (dB/Octave)
        slfo = 6;
    case 2
        % BARTLETT R=M/2
        % Constant overlap-add (COLA) denominator
        den = 2;
        % COLA sum
        sumfactor = 1;
        % Main lobe width (frequency bins)
        mlw = 4;
        % Highest side-lobe level (dB)
        sll = 27;
        % Side-lobe fall-off (dB/Octave)
        slfo = 12;
    case 3
        % HANN R=M/2
        % Constant overlap-add (COLA) denominator
        den = 2;
        % COLA sum
        sumfactor = 1;
        % Main lobe width (frequency bins)
        mlw = 4;
        % Highest side-lobe level (dB)
        sll = 32;
        % Side-lobe fall-off (dB/Octave)
        slfo = 18;
    case 4
        % HANNING R=M/2
        % Constant overlap-add (COLA) denominator
        den = 2;
        % COLA sum
        sumfactor = 1;
        % Main lobe width (frequency bins)
        mlw = 4;
        % Highest side-lobe level (dB)
        sll = 32;
        % Side-lobe fall-off (dB/Octave)
        slfo = 18;
    case 5
        % BLACKMAN R=M/3
        % Constant overlap-add (COLA) denominator
        den = 3;
        % COLA sum
        sumfactor = 1.26;
        % Main lobe width (frequency bins)
        mlw = 6;
        % Highest side-lobe level (dB)
        sll = 57;
        % Side-lobe fall-off (dB/Octave)
        slfo = 18;
    case 6
        % BLACKMAN-HARRIS R=M/4
        % Constant overlap-add (COLA) denominator
        den = 4;
        % COLA sum
        sumfactor = 1.435000000000001;
        % Main lobe width (frequency bins)
        mlw = 8;
        % Highest side-lobe level (dB)
        sll = 92;
        % Side-lobe fall-off (dB/Octave)
        slfo = 6;
    case 7
        % HAMMING R=M/2
        % Constant overlap-add (COLA) denominator
        den = 2;
        % COLA sum
        sumfactor = 1.08;
        % Main lobe width (frequency bins)
        mlw = 4;
        % Highest side-lobe level (dB)
        sll = 42;
        % Side-lobe fall-off (dB/Octave)
        slfo = 6;
    otherwise
        warning(['InvalidWindowType: Supported window types range from 1 to 7.\n'...
            'Window type entered was %d\n'...
            'Using default window type 3 for Hann window.\n'...
            'Type HELP WHICHWIN for more information.\n'],wintype)
        % HANN R=M/2
        % Constant overlap-add (COLA) denominator
        den = 2;
        % COLA sum
        sumfactor = 1;
        % Main lobe width (frequency bins)
        mlw = 4;
        % Highest side-lobe level (dB)
        sll = 32;
        % Side-lobe fall-off (dB/Octave)
        slfo = 18;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARSE OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(infoflag)
    
    case 'name'
        
        winname = {'Rectangular';'Bartlett';'Hann';'Hanning';'Blackman';'Blackman-Harris';'Hamming'};
        argout = winname{wintype};
        
    case 'den'
        
        argout = den;
        
    case 'sum'
        
        argout = sumfactor;
        
    case 'mlw'
        
        argout = mlw;
        
    case 'sll'
        
        argout = sll;
        
    case 'slfo'
        
        argout = slfo;
        
    otherwise
        
        error(['WrongFlag: Invalid INFOFLAG entered: %s.\n'...
            'INFOFLAG must be DEN, SUM, MLW, SLL, or SLFO.\n'...
            'Type HELP INFOWIN for more information.\n'],infoflag)
        
end

end