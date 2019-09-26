function [frames,nsample,dc,cframe] = sof(sig,hopsize,framesize,wintype,cfwflag,normflag)
%SOF    Split into overlapping frames
%   [FR] = SOF(S,H,M,WINTYPE,CFWFLAG,NORMWIN) splits the input S into
%   overlapping frames of length M with a hop size H and returns the frames FR.
%
%   WINTYPE is a numeric flag that specifies the following windows
%
%   1 - Rectangular
%   2 - Bartlett
%   3 - Hann
%   4 - Hanning
%   5 - Blackman
%   6 - Blackman-Harris
%   7 - Hamming
%
%   CFWFLAG is a flag that determines the center of the first analysis window
%   CFWFLAG can be 'ONE', 'HALF', or 'NHALF'. The sample CFW corresponding
%   to the center of the first window is obtained as CFW = cfw(M,CFWFLAG).
%
%   NORMFLAG is a flag that specifies if the window is normalized as
%   normw(n)=w(n)/sum(w(n)). NORMFLAG is TRUE or FALSE.
%
%   [FR,L,DC,CFR] = SOF(...) also returns the original length L of S (in samples),
%   the dc value DC of S, and the vector CFR with the samples corresponding
%   to the cfwflag of the frames FR.
%
%   See also OLA

% 2016 M Caetano: Revised 2019

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK FUNCTION CALL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(6,6);

% Check number of output arguments
nargoutchk(1,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION BODY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make SIG column vector
sig = sig(:);

% Get NSAMPLE
nsample = size(sig,1);

% Prepare SOF
[analysis_window,dc,nframe,cframe] = sofprep(nsample,framesize,hopsize,cfwflag,wintype,normflag);

% Execute SOF
[frames] = sofexe(sig,nsample,analysis_window,framesize,cframe,nframe);

end

% FUNCTION THAT PREPARES SOF
function [analysis_window,dc,nframe,cframe] = sofprep(nsample,framesize,hopsize,cfwflag,wintype,normflag)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK WINDOW OVERLAP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of overlapping samples
noverlap = framesize - hopsize;

%hopsize == framesize
if noverlap == 0
    
    warning('AdjacentFrames: Frames are adjancent. Frames do not overlap. Typically, consecutive frames overlap by 50%.')
    
    %hopsize > framesize
elseif noverlap < 0
    
    warning(['NonOverlappingFrames: Frames do not overlap. There is a gap of ' num2str(abs(noverlap)) ' samples between consecutive frames.'])
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREPARE REMAINING VARIABLES TO GENERATE FRAMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make analysis window
analysis_window = gencolawin(framesize,wintype);

% Normalize analysis window energy
if normflag
    % sum(ANALYSIS_WINDOW) = 1
    dc = sum(analysis_window);
    analysis_window = analysis_window/dc;
else
    % No normalization
    dc = 1;
end

% Number of frames
nframe = nframes(nsample,framesize,hopsize,cfwflag);

% Center of each frame in signal reference
cframe = f2s(1:nframe,cfw(framesize,cfwflag),hopsize);

end

% FUNCTION THAT EXECUTES SOF
function [windowed_frames,nsample,cframe] = sofexe(sig,nsample,analysis_window,framesize,cframe,nframe)

% Initialize the matrix FRAMES that will hold the signal frames
frames = zeros(framesize,nframe);

% Initialize WINDOWED_FRAMES
windowed_frames = zeros(framesize,nframe);

% For each frame
for iframe = 1:nframe
    
    % Make each frame
    frames(:,iframe) = makeframe(sig,cframe(iframe),framesize,nsample);
    
    % Perform windowing
    windowed_frames(:,iframe) = analysis_window.*frames(:,iframe);
    
end

end

% FUNCTION THAT MAKES EACH FRAME
function frame = makeframe(sig,cf,framesize,nsample)

frame = zeros(framesize,1);

% First half window (right of CW)
fhw = rhw(framesize);

% Second half window (left of CW)
shw = lhw(framesize);

if cf < 1
    
    up_bound = cf + fhw;
    
    if up_bound >= 1
        
        frame(framesize-(up_bound-1):framesize) = sig(1:up_bound);
        
    end
    
elseif cf > nsample
    
    low_bound = cf - shw;
    
    if low_bound <= nsample
        
        frame(1:nsample-(low_bound-1)) = sig(low_bound:nsample);
        
    end
    
else
    
    % Sample position of lower window bound in signal reference
    low_bound = max(1,cf - shw);
    
    % Sample position of upper window bound in signal reference
    up_bound = min(nsample,cf + fhw);
    
    if cf - shw < 1
        
        frame(framesize-(up_bound-low_bound):framesize) = sig(low_bound:up_bound);
        
    elseif cf + fhw > nsample
        
        frame(1:(up_bound-low_bound)+1) = sig(low_bound:up_bound);
        
    else
        
        frame(1:framesize) = sig(low_bound:up_bound);
        
    end
    
end

end