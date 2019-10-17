function win = whichwin(wintype)
% WIN = WHICHWIN(WINTYPE) returns the name of the window that corresponds to
% WINTYPE. WIN is a character array. The possibilities are:
%
%   1 - Rectangular
%   2 - Bartlett
%   3 - Hann
%   4 - Hanning
%   5 - Blackman
%   6 - Blackman-Harris
%   7 - Hamming
%
% See also INFOWIN

win = infowin(wintype,'name');

end