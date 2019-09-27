function h = rhw(winlen)
%RHW    right half window length (to the right of CW).
%   RH = RHW(WINSIZE) calculates the length RH in samples of the right
%   half of a WINSIZE long window. RHW excludes the sample at the center
%   of the window with sample position CW.
%   Thus WINSIZE = LH + 1 + RH, where RH is the length of the right
%   half of the window.
%   For odd WINSIZE (symmetric around CW), LH = RH = H and
%   WINSIZE = 2*(H) + 1.
%   For even WINSIZE (not symmetric around CW, RHW = LHW - 1 and
%   WINSIZE = 2*LH = 2*RH + 1.
%   Consequently, CW is always an integer number of samples because
%   CW = LH + 1 = WINSIZE - RH.
%
%   See also LHW CFW

% The periodic flag is useful for DFT/FFT purposes such as in spectral analysis.
%
% Because there is an implicit periodic extension in the DFT/FFT,
% the periodic flag enables a signal that is windowed with a periodic window to have perfect periodic extension.
% When using windows for spectral analysis or other DFT/FFT purposes,
% the periodic option can be useful. When using windows for filter design, the symmetric flag should be used.

if isevenl(winlen)
    
    h = winlen/2-1;
    
else
    
    h = (winlen-1)/2;
    
end