function argout = infowin(winflag,infoflag)
%INFOWIN stores information about windows.
%   OUT = INFOWIN(WINTYPE, INFOFLAG) returns information about the
%   WINTYPE window specified by INFOFLAG. WINTYPE must be numeric ranging
%   between 1 and 7. Type INFOWIN(#,'NAME') for the name of the window
%   corresponding to WINTYPE = #.
%
%   INFOFLAG must be one of the character arrays below specifying ARGOUT.
%
%   NAME window name.
%   NAME outputs a character array with the name of the window that
%   corresponds to the numerical flag WINTYPE
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
%   MAIN_LOBE_WIDTH main lobe width in frequency bins.
%   MAIN_LOBE_WIDTH is the width of the main-lobe of a WINTYPE window in
%   frequency bins.
%
%   SLL highest side-lobe level in dBp.
%   SLL is the amplitude in dB of the second side-lobe for a WINTYPE
%   window. SLL is related to the minimum amplitude a nearby sinusoid can
%   have to be detected.
%
%   SLFO side-lobe fall-off in dBp per octave.
%   The SLFO is the rate in dB at which the amplitude of the spectral
%   side-lobes attenuate per octave for a WINTYPE window.
%
%   CSF cepstral smoothing factor.
%   CSF is the factor used to estimate the order in cepstral smoothing that
%   compensates for using windows other than Rectangular.
%
% [1] Harris, F.J. 'On the Use of Windows for Harmonic Analysis with the
% Discrete Fourier Transform,' Proc. IEEE, 66(1), 1978.
%
% [2] Nuttall, A.H. 'Some Windows with Very Good Sidelobe Behavior,' IEEE
% TASLP, vol ASSP-29, pp. 84-91, Feb 1981.
%
% [3] Smith, J.O.'Spectral Audio Signal Processing', W3K Publishing, 2011,
% ISBN 978-0-9745607-3-1. (https://ccrma.stanford.edu/~jos/sasp/)
%
%   See also WHICHWIN

% 2016 MCaetano
% 2020 MCaetano SMT 0.1.1 (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number if input arguments
narginchk(1,2);

% Check number if output arguments
nargoutchk(0,1);

if nargin == 1
    
    infoflag = 'name';
    
end

% Validate WINFLAG
validateattributes(winflag,{'numeric'},{'scalar','finite','nonnan','integer','real','positive','>=',1,'<=',7},mfilename,'WINFLAG',1)

% Validate INFOFLAG
validateattributes(infoflag,{'char','string'},{'scalartext','nonempty'},mfilename,'INFOFLAG',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch winflag
    
    case 1
        
        % RECTANGULAR R=M
        % Constant overlap-add (COLA) denominator
        den = 1;
        % COLA sum
        sumfactor = 1;
        % Main lobe width (zero crossings [2]) (frequency bins)
        mlw = 2;
        % Highest side-lobe level (dB)
        sll = 13;
        % Side-lobe fall-off (dB/Octave)
        slfo = 6;
        % Cepstral smoothing coefficient (MAIN_LOBE_WIDTH=2)
        csf = 1;
        
    case 2
        
        % BARTLETT R=M/2
        % Constant overlap-add (COLA) denominator
        den = 2;
        % COLA sum
        sumfactor = 1;
        % Main lobe width (zero crossings [2]) (frequency bins)
        mlw = 4;
        % Highest side-lobe level (dB)
        sll = 27;
        % Side-lobe fall-off (dB/Octave)
        slfo = 12;
        % Cepstral smoothing coefficient (MAIN_LOBE_WIDTH=4)
        csf = 1.66;
        
    case 3
        
        % HANN R=M/2
        % Constant overlap-add (COLA) denominator
        den = 2;
        % COLA sum
        sumfactor = 1;
        % Main lobe width (zero crossings [2]) (frequency bins)
        mlw = 4;
        % Highest side-lobe level (dB)
        sll = 32;
        % Side-lobe fall-off (dB/Octave)
        slfo = 18;
        % Cepstral smoothing coefficient (MAIN_LOBE_WIDTH=4)
        csf = 1.66;
        
    case 4
        
        % HANNING R=M/2
        % Constant overlap-add (COLA) denominator
        den = 2;
        % COLA sum
        sumfactor = 1;
        % Main lobe width (zero crossings [2]) (frequency bins)
        mlw = 4;
        % Highest side-lobe level (dB)
        sll = 32;
        % Side-lobe fall-off (dB/Octave)
        slfo = 18;
        % Cepstral smoothing coefficient (MAIN_LOBE_WIDTH=4)
        csf = 1.66;
        
    case 5
        
        % BLACKMAN R=M/3
        % Constant overlap-add (COLA) denominator
        den = 3;
        % COLA sum
        sumfactor = 1.26;
        % Main lobe width (zero crossings [2]) (frequency bins)
        mlw = 6;
        % Highest side-lobe level (dB)
        sll = 57;
        % Side-lobe fall-off (dB/Octave)
        slfo = 18;
        % Cepstral smoothing coefficient (MAIN_LOBE_WIDTH=6)
        csf = 2.5;
        
    case 6
        
        % BLACKMAN-HARRIS R=M/4
        % Constant overlap-add (COLA) denominator
        den = 4;
        % COLA sum
        sumfactor = 1.435000000000001;
        % Main lobe width (zero crossings [2]) (frequency bins)
        mlw = 8;
        % Highest side-lobe level (dB)
        sll = 92;
        % Side-lobe fall-off (dB/Octave)
        slfo = 6;
        % Cepstral smoothing coefficient (MAIN_LOBE_WIDTH=8)
        csf = 3.33;
        
    case 7
        
        % HAMMING R=M/2
        % Constant overlap-add (COLA) denominator
        den = 2;
        % COLA sum
        sumfactor = 1.08;
        % Main lobe width (zero crossings [2]) (frequency bins)
        mlw = 4;
        % Highest side-lobe level (dB)
        sll = 42;
        % Side-lobe fall-off (dB/Octave)
        slfo = 6;
        % Cepstral smoothing coefficient (MAIN_LOBE_WIDTH=4)
        csf = 1.66;
        
    otherwise
        
        warning('SMT:INFOWIN:invalidWindow',['Invalid WINFLAG.\n'...
            'Valid WINFLAG values range from 1 to 7.\n'...
            'WINFLAG entered was %d\n'...
            'Using default WINFLAG = 3 for Hann window.\n'...
            'Type HELP WHICHWIN for more information.\n'],winflag)
        % HANN R=M/2
        % Constant overlap-add (COLA) denominator
        den = 2;
        % COLA sum
        sumfactor = 1;
        % Main lobe width (zero crossings [2]) (frequency bins)
        mlw = 4;
        % Highest side-lobe level (dB)
        sll = 32;
        % Side-lobe fall-off (dB/Octave)
        slfo = 18;
        % Cepstral smoothing coefficient (MAIN_LOBE_WIDTH=4)
        csf = 1.66;
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARSE OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(infoflag)
    
    case 'name'
        
        winname = {'rectwin';'bartlett';'hann';'hanning';'blackman';...
            'blackmanharris';'hamming'};
        argout = winname{winflag};
        
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
        
    case 'csf'
        
        argout = csf;
        
    otherwise
        
        warning('SMT:INFOWIN:UnknownFlag',...
            ['Unknown INFOFLAG entered: %s.\n'...
            'INFOFLAG must be ''NAME'', ''DEN'', ''SUM'', ''MLW'', '...
            '''SLL'', ''SLFO'', or ''CSF''.\nUsing default ''NAME''\n'...
            'Type HELP INFOWIN for more information.\n'],infoflag)
        
        % Default to NAME
        winname = {'rectwin';'bartlett';'hann';'hanning';'blackman';...
            'blackmanharris';'hamming'};
        argout = winname{winflag};
        
end

end
