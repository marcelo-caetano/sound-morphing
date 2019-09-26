function [outsig] = olafs(frames,duration,winlen,hopsize,center)
%OLAFS Overlap Add columns of INPUT_SIG by WINSIZE-HOP_SIZE
%
%   CENTER is a flag that determines the center of the first analysis window
%
%   WINDOW_TYPE
%
%   1 - Rectangular
%   2 - Bartlett
%   3 - Hann
%   4 - Hanning
%   5 - Blackman
%   6 - Blackman-Harris
%   7 - Hamming
%
%   See also SOFFS

switch center
    
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
        
        warning('InvalidFlag: Flag that specifies the center of the first analysis window must be ONE, HALF, or NHALF. Using default value ONE');
        
end

% Preallocate final signal
olasig = zeros(duration+shift,1);

% Number of frames
nframe = size(frames,2);

% Number of samples that overlap
noverlap = winlen - hopsize;

% Center of frames (in signal reference)
cframe = f2s(1:nframe,cfw(winlen,center),hopsize);

% Fading factor
fadein = linspace(0,1,noverlap)';

for iframe = 1:nframe
    
    % Begin of frame (in signal reference)
    bframe = cframe(iframe) - lhw(winlen) + shift;
    
    % End of frame (in signal reference)
    eframe = cframe(iframe) + rhw(winlen) + shift;
    
    if iframe == 1
        
        olasig(bframe:bframe+noverlap-1) = olasig(bframe:bframe+noverlap-1) + frames(1:noverlap,iframe);
        
    else
        
        olasig(bframe:bframe+noverlap-1) = (1-fadein).*olasig(bframe:bframe+noverlap-1) + fadein.*frames(1:noverlap,iframe);
        
    end
    
    olasig(bframe+noverlap:eframe) = frames(noverlap+1:winlen,iframe);  
    
end

% for cf = cframe
%
%     framenumber = s2f(cf,1,hopsize);
%
%     olasig(cf:cf+winlen-1) = olasig(cf:cf+winlen-1) + frames(:,framenumber);
%     olasig(cf-lhw(winlen)+shift:cf+rhw(winlen)+shift) = olasig(cf-lhw(winlen)+shift:cf+rhw(winlen)+shift) + frames(:,framenumber);
%
% end

outsig = olasig(1+shift:duration+shift);

end