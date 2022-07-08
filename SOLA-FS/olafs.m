function finalwav = olafs(timeframe,framelen,hop,nsample,causalflag)
%OLAFS Overlap Add columns of INPUT_SIG by WINSIZE-HOP_SIZE
%
%   CAUSALFLAG determines the center of the first analysis window
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

% 2016 M Caetano
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number if input arguments
narginchk(5,5);

% Check number if output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zero-padding at start and end for frame-based processing
shift = tools.dsp.causal_zeropad(framelen,causalflag);

% Preallocate final signal
olawav = zeros(nsample + shift,1);

% Number of timeframe
nframe = size(timeframe,2);

% Number of samples that overlap
noverlap = framelen - hop;

% Center of timeframe (in signal reference)
% center_frame = tools.dsp.frame2sample(1:nframe,tools.dsp.centerwin(framelen,causalflag),hop);
center_frame = tools.dsp.frame2sample([1:nframe]',framelen,hop,causalflag);

% Fade-in factor
fadein = linspace(0,1,noverlap)';

for iframe = 1:nframe
    
    % Beginning of frame (in signal reference)
    begframe = center_frame(iframe) - tools.dsp.leftwin(framelen) + shift;
    
    % End of frame (in signal reference)
    endframe = center_frame(iframe) + tools.dsp.rightwin(framelen) + shift;
    
    if iframe == 1
        
        olawav(begframe:begframe + noverlap - 1) = ...
            olawav(begframe:begframe + noverlap - 1) + ...
            timeframe(1:noverlap,iframe);
        
    else
        
        olawav(begframe:begframe + noverlap - 1) = ...
            (1 - fadein) .* olawav(begframe:begframe + noverlap - 1) + ...
            fadein .* timeframe(1:noverlap,iframe);
        
    end
    
    olawav(begframe + noverlap:endframe) = ...
        timeframe(noverlap + 1:framelen,iframe);
    
end

finalwav = olawav(1+shift:nsample+shift);

end
