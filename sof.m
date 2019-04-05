function [frames,duration,dc,cframe] = sof(sig,hopsize,winlen,wintype,center,normflag)
%SOF    Split into overlapping frames
%
%   [FR] = SOF(S,H,M,WINTYPE,CENTER,NORMWIN) splits the input S into
%   overlapping frames of length M with a hop size H and returns the frames FR.
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
%   NORMFLAG is a flag that specifies if the window is normalized as
%   normw(n)=w(n)/sum(w(n)). NORMFLAG is TRUE or FALSE.
%
%   [FR,L,DC,CFR] = SOF(...) also returns the original length L of S (in samples),
%   the dc value DC of S, and the vector CFR with the samples corresponding
%   to the center of the frames FR.
%
%   See also OLA

% M Caetano

%   Make INPUT_SIG column vector
sig = sig(:);
duration = size(sig,1);

[analwin,dc,nframe,cframe] = sofprep(duration,winlen,hopsize,center,wintype,normflag);

[frames] = sofexe(sig,duration,analwin,winlen,cframe,nframe);

end

function [analwin,dc,nframe,cframe] = sofprep(duration,winlen,hopsize,center,wintype,normflag)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK WINDOW OVERLAP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of overlapping samples
noverlap = winlen - hopsize;

%hopsize == winlen
if noverlap == 0
    
    warning('AdjacentFrames: Frames are adjancent. Frames do not overlap. Typically, consecutive frames overlap by 50%.')
    
    %hopsize > winlen
elseif noverlap < 0
    
    warning(['NonOverlappingFrames: Frames do not overlap. There is a gap of ' num2str(abs(noverlap)) ' samples between consecutive frames.'])
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREPARE REMAINING VARIABLES TO GENERATE FRAMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make analysis window
analwin = gencolawin(winlen,wintype);

% Normalize analysis window energy
if normflag
    % sum(ANALYSIS_WINDOW) = 1
    dc = sum(analwin);
    analwin = analwin/dc;
else
    % No normalization
    dc = 1;
end

% Number of frames
nframe = nframes(duration,winlen,hopsize,center);

% Center of each frame in signal reference
cframe = f2s(1:nframe,cfw(winlen,center),hopsize);

end

function [windowed_frames,duration,cframe] = sofexe(sig,duration,analwin,winlen,cframe,nframe)

% Initialize the matrix FRAMES that will hold the signal frames
frames = zeros(winlen,nframe);

% Initialize WINDOWED_SIG
windowed_frames = zeros(winlen,nframe);

for iframe = 1:nframe
    
    % Make each frame
    frames(:,iframe) = makeframe(sig,cframe(iframe),winlen,duration);
    
    % Perform windowing
    windowed_frames(:,iframe) = analwin.*frames(:,iframe);
    
end

end

% FUNCTION THAT MAKES EACH FRAME
function frame = makeframe(sig,cf,winlen,duration)

frame = zeros(winlen,1);

% First half window (right of CW)
fhw = rhw(winlen);

% Second half window (left of CW)
shw = lhw(winlen);

if cf < 1
    
    up_bound = cf + fhw;
    
    if up_bound >= 1
        
        frame(winlen-(up_bound-1):winlen) = sig(1:up_bound);
        
    end
    
elseif cf > duration
    
    low_bound = cf - shw;
    
    if low_bound <= duration
        
        frame(1:duration-(low_bound-1)) = sig(low_bound:duration);
        
    end
    
else
    
    % Sample position of lower window bound in signal reference
    low_bound = max(1,cf - shw);
    
    % Sample position of upper window bound in signal reference
    up_bound = min(duration,cf + fhw);
    
    if cf - shw < 1
        
        frame(winlen-(up_bound-low_bound):winlen) = sig(low_bound:up_bound);
        
    elseif cf + fhw > duration
        
        frame(1:(up_bound-low_bound)+1) = sig(low_bound:up_bound);
        
    else
        
        frame(1:winlen) = sig(low_bound:up_bound);
        
    end
    
end

end