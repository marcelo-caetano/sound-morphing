function [time_frame,center_frame,nsample,nframe,nchannel,dc] = sof(wav,framelen,hop,winflag,causalflag,normflag)
%SOF Split into overlapping frames.
%   FR = SOF(S,M,H,WINFLAG,CAUSALFLAG,NORMFLAG) splits the input S into
%   overlapping frames FR of length M with a hop size H.
%
%   WINFLAG is a numeric flag that specifies the following windows
%
%   1 - Rectangular
%   2 - Bartlett
%   3 - Hann
%   4 - Hanning
%   5 - Blackman
%   6 - Blackman-Harris
%   7 - Hamming
%
%   CAUSALFLAG is a character flag that determines the causality of the
%   window. CAUSALFLAG can be 'ANTI', 'NON', or 'CAUSAL' for anti-causal,
%   non-causal, or causal respectively. The sample CENTERWIN corresponding
%   to the center of the first window is obtained as
%   CENTERWIN = tools.dsp.centerwin(M,CAUSALFLAG).
%
%   NORMFLAG is a boolean that specifies if the window is normalized as
%   normw(n)=w(n)/sum(w(n)). NORMFLAG = TRUE normalizes and FALSE does not.
%
%   [FR,CFR,NSAMPLE,NFRAME,NCHANNEL,DC] = SOF(...) also returns the vector
%   CFR with the samples corresponding to the center of the time frames FR,
%   the original number of time samples NSAMPLE of S, the number of frames
%   NFRAME, the number of channels NCHANNEL, AND the dc value DC of S.
%
%   See also OLA

% 2016 M Caetano
% 2019 MCaetano (Revised)
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2021 M Caetano SMT (Revised for stereo)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(6,6);

% Check number of output arguments
nargoutchk(0,6);

validateattributes(wav,{'numeric'},{'finite'},mfilename,'WAV',1);
validateattributes(framelen,{'numeric'},{'scalar','integer','real','positive'},mfilename,'FRAMELEN',2)
validateattributes(hop,{'numeric'},{'scalar','integer','real','positive'},mfilename,'HOP',3)
validateattributes(winflag,{'numeric'},{'scalar','integer','>=',1,'<=',14},mfilename,'WINFLAG',4)
validateattributes(causalflag,{'char','string'},{'scalartext','nonempty'},mfilename,'CAUSALFLAG',5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get NSAMPLE and NCHANNEL
[nsample,nchannel] = size(wav);

% Prepare SOF
[analysis_window,dc,nframe,center_frame] = sofprep(nsample,framelen,hop,causalflag,winflag,normflag);

% Execute SOF
[time_frame] = sofexe(wav,nsample,analysis_window,framelen,center_frame,nframe,nchannel);

end

% LOCAL FUNCTION THAT PREPARES SOF
function [analysis_window,dc,nframe,center_frame] = sofprep(nsample,framelen,hop,causalflag,winflag,normflag)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK WINDOW OVERLAP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of overlapping samples
noverlap = framelen - hop;

%hop == framelen
if noverlap == 0
    
    warning('SMT:SOF:AdjacentFrames',...
        ['Frames are adjacent.\nFrames do not overlap.\n'...
        'Typically, consecutive time frames overlap by 50%%.']);
    
    %hop > framelen
elseif noverlap < 0
    
    warning('SMT:SOF:NonOverlappingFrames',['Frames do not overlap.\n'...
        'There is a gap of %d samples between consecutive time frames.'],...
        abs(noverlap));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREPARE REMAINING VARIABLES TO GENERATE FRAMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make analysis window
analysis_window = tools.ola.mkcolawin(framelen,winflag);

% Window normalization factor
normwin = sum(analysis_window);

% Normalize analysis window energy
if normflag
    % sum(ANALYSIS_WINDOW) = 1
    analysis_window = analysis_window/normwin;
    dc = normwin;
else
    % No normalization
    dc = 1;
end

% Number of time frames
nframe = tools.dsp.numframe(nsample,framelen,hop,causalflag);

% Center of each frame in signal reference
center_frame = tools.dsp.frame2sample([1:nframe]',framelen,hop,causalflag);

end

% LOCAL FUNCTION THAT EXECUTES SOF
function [windowed_frames,nsample,center_frame] = sofexe(wav,nsample,analysis_window,framelen,center_frame,nframe,nchannel)

% Initialize the matrix FRAMES that will hold the time frames
time_frame = zeros(framelen,nframe,nchannel);

% Initialize WINDOWED_FRAMES
windowed_frames = zeros(framelen,nframe,nchannel);

% For each frame
for iframe = 1:nframe
    
    % Make each frame
    time_frame(:,iframe,:) = mkframe(wav,center_frame(iframe),framelen,nsample,nchannel);
    
    % Perform windowing
    windowed_frames(:,iframe,:) = analysis_window.*time_frame(:,iframe,:);
    
end

end

% LOCAL FUNCTION THAT MAKES EACH FRAME
function frame = mkframe(wav,cf,framelen,nsample,nchannel)

% Initialize frame
frame = zeros(framelen,nchannel);

% First half window (right of CW)
fhw = tools.dsp.rightwin(framelen);

% Second half window (left of CW)
shw = tools.dsp.leftwin(framelen);

if cf < 1
    
    up_bound = cf + fhw;
    
    if up_bound >= 1
        
        frame(framelen-(up_bound-1):framelen,:) = wav(1:up_bound,:);
        
    end
    
elseif cf > nsample
    
    low_bound = cf - shw;
    
    if low_bound <= nsample
        
        frame(1:nsample-(low_bound-1),:) = wav(low_bound:nsample,:);
        
    end
    
else
    
    % Sample position of lower window bound in signal reference
    low_bound = max(1,cf-shw);
    
    % Sample position of upper window bound in signal reference
    up_bound = min(nsample,cf+fhw);
    
    if cf - shw < 1
        
        frame(framelen-(up_bound-low_bound):framelen,:) = wav(low_bound:up_bound,:);
        
    elseif cf + fhw > nsample
        
        frame(1:(up_bound-low_bound)+1,:) = wav(low_bound:up_bound,:);
        
    else
        
        frame(1:framelen,:) = wav(low_bound:up_bound,:);
        
    end
    
end

end
