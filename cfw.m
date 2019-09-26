function c = cfw(winlen,center)
%CFW    Center of the first window in signal reference (samples).
%   [C] = CFW(WINSIZE,CENTER) returns the sample C at the CENTER of the
%   first analysis window with WINSIZE samples.
%
%   CFW returns the sample corresponding to the analysis time
%
%   See also RHW LHW

% The periodic flag is useful for DFT/FFT purposes such as in spectral analysis.
%
% Because there is an implicit periodic extension in the DFT/FFT,
% the periodic flag enables a signal that is windowed with a periodic window to have perfect periodic extension.
% When using windows for spectral analysis or other DFT/FFT purposes,
% the periodic option can be useful. When using windows for filter design, the symmetric flag should be used.

switch lower(center)
    
    case 'one'
        
        c = 1;
        
    case 'half'
        
        c = lhw(winlen) + 1;
        
    case 'nhalf'
        
        c = -rhw(winlen);
        
    otherwise
        
        c = 1;
        warning('InvalidFlag: Flag that specifies the center of the first analysis window must be ONE, HALF, or NHALF. Using default value ONE');
        
end

end

