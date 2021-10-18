function sumfactor = colasum(winflag)
%COLASUM COLA constant for different windows.
%   SUM = tools.ola.colasum(WINTYPE) returns SUM for a window of type WINTYPE.
%
%   SUM = COLA(R) for hop size R = M/DEN, expressed as a fraction of the
%   window size M. DEN depends on WINTYPE. Type WHICHWIN(WINTYPE) for the
%   names of the different windows supported.
%
%   See also COLADEN, ISCOLA, COLAHOPSIZE, ALLCOLAHOPSIZE, OVERLAP2HOPSIZE

% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%   WINDOW_TYPE
%
%   1 - Rectangular
%   2 - Bartlett
%   3 - Hann
%   4 - Hanning
%   5 - Blackman
%   6 - Blackman-Harris
%   7 - Hamming

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK FUNCTION ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of input arguments
narginchk(1,1);

% Number of output arguments
nargoutchk(1,1);

% Validate input
validateattributes(winflag,{'single','double'},{'scalar','>',0,'<',8});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BODY OF FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sumfactor = tools.dsp.infowin(winflag,'sum');

end
