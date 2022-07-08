function win = mkwin(framelen,winflag)
%MKWIN Make window in the time domain.
%   W = MKWIN(M,WINFLAG) makes a window W of type WINFLAG with M samples.
%   The possibilities for WINFLAG are:
%
%   1 - Rectangular
%   2 - Bartlett
%   3 - Hann
%   4 - Hanning
%   5 - Blackman
%   6 - Blackman-Harris
%   7 - Hamming
%   8 - Bartlett-Hann
%   9 - Gaussian
%   10 - Slepian
%   11 - Kaiser-Bessel
%   12 - Nuttall
%   13 - Dolph-Chebychev
%   14 - Tukey
%
%   The window W is carefully designed to ensure that the center of W is an
%   integer sample number. Consequently, even M results in periodic windows,
%   whereas odd M results in symmetric windows. See the help for each window
%   given by WINFLAG for further information.
%
%   See also COLADEN, COLASUM, ISCOLA, COLAHOPSIZE, OVERLAP2HOPSIZE

% 2016 M Caetano
% 2019 MCaetano (Revised)
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,2);

% Check number of output arguments
nargoutchk(0,1);

validateattributes(framelen,{'numeric'},{'scalar','integer','real','positive'},mfilename,'FRAMELEN',1)
validateattributes(winflag,{'numeric'},{'scalar','integer','>=',1,'<=',14},mfilename,'WINFLAG',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if tools.misc.iseven(framelen)
    
    % Even window length
    wflag = 'periodic';
    
else
    
    % Odd window length
    wflag = 'symmetric';
    
end

% Type of window
switch winflag
    
    case 1
        
        % RECTANGULAR
        win = rectwin(framelen);
        
    case 2
        
        % BARTLETT
        if tools.misc.iseven(framelen)
            win = bartlett(framelen+1);
            win(end)=[];
        else
            win = bartlett(framelen);
        end
        
    case 3
        
        % HANN
        win = hann(framelen,wflag);
        
    case 4
        
        % HANNING (OLA > 1)
        win = hanning(framelen,wflag);
        
    case 5
        
        % BLACKMAN
        win = blackman(framelen,wflag);
        
    case 6
        
        % BLACKMAN-HARRIS
        win = blackmanharris(framelen,wflag);
        
    case 7
        
        % HAMMING (OLA > 1)
        win = hamming(framelen,wflag);
        
    case 8
        
        % BARTLETT-HANN
        if tools.misc.iseven(framelen)
            win = barthannwin(framelen+1);
            win(end)=[];
        else
            win = barthannwin(framelen);
        end
        
    case 9
        
        % GAUSSIAN
        if tools.misc.iseven(framelen)
            win = gausswin(framelen+1);
            win(end)=[];
        else
            win = gausswin(framelen);
        end
        
    case 10
        
        % SLEPIAN
        if tools.misc.iseven(framelen)
            win = dpss(framelen+1,3,1);
            win(end)=[];
        else
            win = dpss(framelen,3,1);
        end
        
    case 11
        
        % KAISER-BESSEL
        if tools.misc.iseven(framelen)
            win = kaiser(framelen+1,0.5);
            win(end)=[];
        else
            win = kaiser(framelen,0.5);
        end
        
    case 12
        
        % NUTTALL
        win = nuttallwin(framelen,wflag);
        
    case 13
        
        % DOLPH-CHEBYSHEV
        if tools.misc.iseven(framelen)
            win = chebwin(framelen+1,100);
            win(end)=[];
        else
            win = chebwin(framelen,100);
        end
        
    case 14
        
        % TUKEY
        if tools.misc.iseven(framelen)
            win = tukeywin(framelen+1,0.5);
            win(end)=[];
        else
            win = tukeywin(framelen,0.5);
        end
        
end

end
