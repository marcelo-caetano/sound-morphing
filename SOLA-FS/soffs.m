function [time_frames,nsample] = soffs(wav,framelen,hopsynth,maxcorr,alpha,causalflag)
%SOFFS    Split into overlapping time_frames
%
%   See also OLAFS

% 2016 MCaetano (Revised)
% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%TODO: CHECK INPUTS (CLASS, ETC)
%TODO: PROCESS EACH CHANNEL OF STEREO SOUNDS SEPARATELY

% Make SIG column vector
wav = wav(:); % WARNING! THIS CONCATENATES THE CHANNELS OF STEREO SOUNDS

% Duration of SIG in samples
nsample = size(wav,1);

% Check synthesis overlap
[noverlap] = sofprep(framelen,hopsynth);

% Perform SOF
[time_frames] = sofexe(wav,framelen,hopsynth,maxcorr,alpha,nsample,noverlap,causalflag);

end

function [noverlap] = sofprep(framelen,hopsynth)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK THAT ANALYSIS FRAMES OVERLAP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
noverlap = framelen - hopsynth;

%hopsynth == framelen
if noverlap == 0
    
    warning(['SMT:AdjacentFrames: ','Frames do not overlap because the hop size %d is equal to the frame size %d.\n'...
        'Typically, consecutive time_frames overlap by 50%.\n'],framelen,hopsynth)
    
    %hopsynth > framelen
elseif noverlap < 0
    
    warning(['SMT:NonOverlappingFrames: ','Frames do not overlap because the hop size %d is greater than the frame size %d.\n'...
        'There is a gap of %d samples between consecutive time_frames.'],framelen,hopsynth,abs(noverlap))
    
end

end

function [time_frames] = sofexe(wav,framelen,hopsynth,maxcorr,alpha,nsample,noverlap,causalflag)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the analysis hop size
hopanal = fix(hopsynth/alpha);

% Calculate the maximum number of time_frames NUMBER_FRAMES
maxnframe = tools.dsp.numframe(nsample,framelen,hopanal,causalflag);

% Initialize the matrix FRAMES that will hold the signal time_frames
time_frames = zeros(framelen,maxnframe);

% Initialize center of analysis window (in signal reference)
caw = zeros(maxnframe,1);

% Initialize center of synthesis window (in signal reference)
csw = zeros(maxnframe,1);

% Initialize predicted offset
predoffset = zeros(maxnframe,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIRST FRAME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Frame number
iframe = 1;

% Position of center of synthesis window (in signal reference)
csw(iframe) = tools.dsp.centerwin(framelen,causalflag);

% Position of center of analysis window (in signal reference)
caw(iframe) = tools.dsp.centerwin(framelen,causalflag);

% Initialize offset
predoffset(iframe) = 0;

% Make first frame
time_frames(:,iframe) = makeframe(wav,caw(iframe),framelen,nsample);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMAINING FRAMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Next frame number
iframe = iframe + 1;

% Next center of synthesis window (in signal reference)
csw(iframe) = csw(iframe-1) + hopsynth;

% Next center of analysis window (in signal reference)
caw(iframe) = caw(iframe-1) + hopanal;

% Predict next offset
predoffset(iframe) = predoffset(iframe-1) + hopsynth - hopanal;

while iframe <= maxnframe && caw(iframe) <= nsample
    
    if abs(predoffset(iframe)) <= maxcorr && abs(predoffset(iframe)) >= 0
        
        % Update frame
        time_frames(:,iframe) = makeframe(wav,caw(iframe)+predoffset(iframe),framelen,nsample);
        
    else
        
        % Make frame
        time_frames(:,iframe) = makeframe(wav,caw(iframe),framelen,nsample);
        
        % Cross correlate only overlapping samples (in CAW reference) LAGS refer to IFRAME shifting
        [xc,xl] = xcorrel([time_frames(:,iframe);zeros(maxcorr+noverlap,1)],time_frames(:,iframe-1),framelen,hopsynth,0,1,maxcorr);
        
        [~,ind] = max(xc);
        
        predoffset(iframe) = xl(ind);
        
        % Update frame
        time_frames(:,iframe) = makeframe(wav,caw(iframe)+predoffset(iframe),framelen,nsample);
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NEXT FRAME
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Next frame number
    iframe = iframe + 1;
    
    % Update predicted offset
    predoffset(iframe) = predoffset(iframe-1) + hopsynth - hopanal;
    
    % Next center of synthesis window (in signal reference)
    csw(iframe) = csw(iframe-1) + hopsynth;
    
    % Next center of analysis window (in signal reference)
    caw(iframe) = caw(iframe-1) + hopanal;
    
end

end

% FUNCTION THAT MAKES EACH FRAME
function frame = makeframe(wav,cw,framelen,nsample)

frame = zeros(framelen,1);

if cw < 1
    
    up_bound = cw + tools.dsp.rightwin(framelen);
    
    if up_bound > 0
        
        frame(framelen-(up_bound-1):framelen) = wav(1:up_bound);
        
    end
    
elseif cw > nsample
    
    low_bound = cw - tools.dsp.leftwin(framelen);
    
    if low_bound < nsample
        
        frame(1:nsample-(low_bound-1)) = wav(low_bound:nsample);
        
    end
    
else
    
    % sample position of lower window bound in signal reference
    low_bound = max(1,cw - tools.dsp.leftwin(framelen));
    
    % sample position of upper window bound in signal reference
    up_bound = min(nsample,cw + tools.dsp.rightwin(framelen));
    
    if cw - tools.dsp.leftwin(framelen) < 1
        
        frame(framelen-(up_bound-low_bound):framelen) = wav(low_bound:up_bound);
        
    elseif cw + tools.dsp.rightwin(framelen) > nsample
        
        frame(1:(up_bound-low_bound)+1) = wav(low_bound:up_bound);
        
    else
        
        frame(1:framelen) = wav(low_bound:up_bound);
        
    end
    
end

end

function [Rxy,Rl] = xcorrel(x,y,W,Ss,Kmin,Kdec,Kmax)

if nargin < 3;  W = 600;        end
if nargin < 4;  Ss = 120;       end
if nargin < 5;  Kmin = 0;       end
if nargin < 6;  Kdec = 1;       end
if nargin < 7;  Kmax = W + Ss;  end

% if Kmax > W + Ss
%     Kmax = W + Ss;
% end

% Number of overlapping samples
Wov = W - Ss;

% Column vectors
x = x(:);
y = y(:);

if size(x,1) == size(y,1)
    
    x = [x;zeros(Wov+Kmax-(size(x,1)+1),1)];
    
end

Rl = Kmin:Kdec:Kmax-1;

% Initialize variables
rxy = zeros(length(Rl),1);
rxx = zeros(length(Rl),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate rxy and rxx
%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = 1;

for ixc = Rl
    
    rxy(k) = sum(x(1+ixc:Wov+ixc).*y(Ss+1:W));
    
    rxx(k) = sum(x(1+ixc:Wov+ixc).^2);
    
    k = k + 1;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate ryy
%%%%%%%%%%%%%%%%%%%%%%%%%%%

ryy = sum(y(Ss+1:W).^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate Rxy
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Rxy = (rxy.*abs(rxy))./rxx*ryy;
Rxy = rxy./sqrt(rxx*ryy);
end
