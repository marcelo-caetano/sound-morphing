function [olasig,olawin] = ola(frames,duration,wintype,center,cframe)
%OLA Overlap-Add columns of FRAMES by WINSIZE - HOPSIZE.
%
%   [OLAS] = OLA(FR,L,WINTYPE,CENTER,CFR) overlap-adds the frames FR by M -
%   H, where M is the length of the WINTYPE window and H is the hop size
%   used to make the frames.
%
%   L is the length of the original signal in samples. L is usually
%   different than CFW+(NFRAME-1)*H because the last frame is zero-padded
%   to M.
% 
%   WINDOW_TYPE is a numeric flag that specifies the following windows
%
%   1 - Rectangular
%   2 - Bartlett
%   3 - Hann
%   4 - Hanning
%   5 - Blackman
%   6 - Blackman-Harris
%   7 - Hamming
%
%   CENTER is a flag that determines the center of the first analysis window
%   CENTER can be 'ONE', 'HALF', or 'NHALF'. The sample CFW corresponding
%   to the center of the first window is obtained as CFW = cfw(M,CENTER).
%
%   CFRAME is a vector with the positions of the center of the frames.
%
%   [OLAS,OLAW] = OLA(...) also returns the overlap-added window OLAW
%   specified by WINTYPE.

% M Caetano

% Window size
winlen = size(frames,1);

% Hop size
hopsize = cframe(2)-cframe(1);

% Ensure CFRAME is a vector array
if size(cframe,2)==1
    cframe = cframe';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ZERO-PADDING AT THE BEGINNING AND END OF SIGNAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(center)
    
    case 'one'
        
        % SHIFT is the number of zeros before CW
        shift = lhw(winlen);
        
    case 'half'

        % SHIFT is the number of zeros before CW
        shift = 0;
        
    case 'nhalf'

        % SHIFT is the number of zeros before CW
        shift = winlen;
        
    otherwise
        
        warning(['InvalidFlag: Flag that specifies the center of the first analysis window must be ONE, HALF, or NHALF.\n'...
            'Using default value ONE']);
        
        % SHIFT is the number of zeros before CW
        shift = lhw(winlen);
        
end

% Preallocate with zero-padding
olasig = zeros(duration+2*shift,1);
olawin = zeros(duration+2*shift,1);

% Make synthesis window
synthesis_window = gencolawin(winlen,wintype);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OVERLAP-ADD PROCEDURE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for cf = cframe
    
    % Frame number
    iframe = s2f(cf,cfw(winlen,center),hopsize);
    
    % olasig(cf:cf+winlen-1) = olasig(cf:cf+winlen-1) + frames(:,framenumber);
    olasig(cf-lhw(winlen)+shift:cf+rhw(winlen)+shift) = olasig(cf-lhw(winlen)+shift:cf+rhw(winlen)+shift) + frames(:,iframe);
    
    % olawin(cf:cf+winlen-1) = olawin(cf:cf+winlen-1) + synthesis_window;
    olawin(cf-lhw(winlen)+shift:cf+rhw(winlen)+shift) = olawin(cf-lhw(winlen)+shift:cf+rhw(winlen)+shift) + synthesis_window;
    
end

% Remove zero-padding
olasig = olasig(1+shift:duration+shift);
olawin = olawin(1+shift:duration+shift);

end