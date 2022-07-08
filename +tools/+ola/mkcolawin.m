function win = mkcolawin(framelen,winflag)
%MKCOLAWIN Make COLA window.
%   W = MKCOLAWIN(M,WINFLAG) makes a window W that is M samples
%   long and that has the constant overlap-add (COLA) property. The flag
%   WINFLAG controls the window type. The possibilities for WINFLAG are:
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
%   The window W is carefully designed to be COLA and to ensure that the
%   center of W is an integer sample number. Consequently, even M
%   results in periodic windows, whereas odd M results in symmetric
%   windows. See the help for each window given by WINFLAG for further
%   information.
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

validateattributes(framelen,{'numeric'},{'scalar','integer','positive'},mfilename,'FRAMELEN',1)
validateattributes(winflag,{'numeric'},{'scalar','integer','>=',1,'<=',14},mfilename,'WINFLAG',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

win = tools.win.mkwin(framelen,winflag);

% Correct endpoints to make Hamming and Blackman-Harris COLA(M)
if tools.misc.isodd(framelen) && (winflag == 6 || winflag == 7)
    win(1) = win(1)/2;
    win(framelen) = win(framelen)/2;
end

end
