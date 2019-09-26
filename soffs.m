function [frames,duration] = soffs(sig,shopsize,winlen,center,maxcorr,alpha)
%SOFFS    Split into overlapping frames
%
%   See also OLAFS

% Make SIG column vector
sig = sig(:);
% Duration of SIG in samples
duration = size(sig,1);

% Check synthesis overlap
[noverlap] = sofprep(shopsize,winlen);

% Perform SOF
[frames] = sofexe(sig,winlen,shopsize,maxcorr,center,alpha,duration,noverlap);

end

function [noverlap] = sofprep(shopsize,winlen)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK THAT ANALYSIS FRAMES OVERLAP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
noverlap = winlen - shopsize;

%shopsize == winlen
if noverlap == 0
    
    warning('AdjacentFrames: Frames are adjancent. Frames do not overlap. Typically, consecutive frames overlap by 50%.')
    
    %shopsize > winlen
elseif noverlap < 0
    
    warning(['NonOverlappingFrames: Frames do not overlap. There is a gap of ' num2str(abs(noverlap)) ' samples between consecutive frames.'])
    
end

end

function [frames] = sofexe(sig,winlen,shopsize,maxcorr,center,alpha,duration,noverlap)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the analysis hop size
ahopsize = fix(shopsize/alpha);

% Calculate the maximum number of frames NUMBER_FRAMES
maxframe = nframes(duration,winlen,ahopsize,center);

% Initialize the matrix FRAMES that will hold the signal frames
frames = zeros(winlen,maxframe);

% Initialize center of analysis window (in signal reference)
caw = zeros(maxframe,1);

% Initialize center of synthesis window (in signal reference)
csw = zeros(maxframe,1);

% Initialize predicted offset
poffset = zeros(maxframe,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIRST FRAME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Frame number
iframe = 1;

% Position of center of synthesis window (in signal reference)
csw(iframe) = cfw(winlen,center);

% Position of center of analysis window (in signal reference)
caw(iframe) = cfw(winlen,center);

% Initialize offset
poffset(iframe) = 0;

% Make first frame
frames(:,iframe) = makeframe(sig,caw(iframe),winlen,duration);

% fprintf(1,'Frame = %d caw = %d csw = %d Predicted offset = %d\n',iframe,caw(iframe),csw(iframe),poffset(iframe));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMAINING FRAMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Next frame number
iframe = iframe + 1;

% Next center of synthesis window (in signal reference)
csw(iframe) = csw(iframe-1) + shopsize;

% Next center of analysis window (in signal reference)
caw(iframe) = caw(iframe-1) + ahopsize;

% Predict next offset
poffset(iframe) = poffset(iframe-1) + shopsize - ahopsize;

while iframe <= maxframe && caw(iframe) <= duration
    
    if abs(poffset(iframe)) <= maxcorr && abs(poffset(iframe)) >= 0
        
        % Update frame
        frames(:,iframe) = makeframe(sig,caw(iframe)+poffset(iframe),winlen,duration);
        
        %             figure(1)
        %             subplot(2,1,1)
        %             plot(csw(iframe-1)-lhw(winlen):csw(iframe-1)+rhw(winlen),frames(:,iframe-1),'k')
        %             hold on
        %             plot(csw(iframe)-lhw(winlen):csw(iframe)+rhw(winlen),frames(:,iframe),'r')
        %             hold off
        %             title('Predicted offset from frames')
        %             legend('previous frame','current frame')
        %             subplot(2,1,2)
        %             plot(csw(iframe-1)-lhw(winlen):csw(iframe-1)+rhw(winlen),sig(caw(iframe-1)+poffset(iframe-1)-lhw(winlen):caw(iframe-1)+poffset(iframe-1)+rhw(winlen)),'b')
        %             hold on
        %             plot(csw(iframe)-lhw(winlen):csw(iframe)+rhw(winlen),sig(caw(iframe)+poffset(iframe)-lhw(winlen):caw(iframe)+poffset(iframe)+rhw(winlen)),'r')
        %             hold off
        %             title('Predicted offset from signal')
        %             legend('previous frame','current frame')
        %
        %         fprintf(1,'Frame = %d caw = %d csw = %d Predicted offset = %d\n',iframe,caw(iframe),csw(iframe),poffset(iframe));
        
    else
        
        % Make frame
        frames(:,iframe) = makeframe(sig,caw(iframe),winlen,duration);
        
        %             figure(1)
        %             subplot(2,1,1)
        %             plot(csw(iframe-1)-lhw(winlen):csw(iframe-1)+rhw(winlen),frames(:,iframe-1),'k')
        %             hold on
        %             plot(csw(iframe)-lhw(winlen):csw(iframe)+rhw(winlen),frames(:,iframe),'r')
        %             hold off
        %             title('Before cross corelation from frames')
        %             legend('previous frame','current frame')
        %             subplot(2,1,2)
        %             plot(csw(iframe-1)-lhw(winlen):csw(iframe-1)+rhw(winlen),sig(caw(iframe-1)+poffset(iframe-1)-lhw(winlen):caw(iframe-1)+poffset(iframe-1)+rhw(winlen)),'b')
        %             hold on
        %             plot(csw(iframe)-lhw(winlen):csw(iframe)+rhw(winlen),sig(caw(iframe)-lhw(winlen):caw(iframe)+rhw(winlen)),'r')
        %             hold off
        %             title('Before cross corelation from signal')
        %             legend('previous frame','current frame')
        
        % Cross correlate only overlapping samples (in CAW reference) LAGS refer to IFRAME shifting
        [xc,xl] = xcorrel([frames(:,iframe);zeros(maxcorr+noverlap,1)],frames(:,iframe-1),winlen,shopsize,0,1,maxcorr);
        
        [~,ind] = max(xc);
        
        poffset(iframe) = xl(ind);
        
        % Update frame
        frames(:,iframe) = makeframe(sig,caw(iframe)+poffset(iframe),winlen,duration);
        
        %             figure(2)
        %             subplot(2,1,1)
        %             plot(csw(iframe-1)-lhw(winlen):csw(iframe-1)+rhw(winlen),frames(:,iframe-1),'k')
        %             hold on
        %             plot(csw(iframe)-lhw(winlen):csw(iframe)+rhw(winlen),frames(:,iframe),'r')
        %             hold off
        %             title('Calculated offset from frames')
        %             legend('previous frame','current frame')
        %             subplot(2,1,2)
        %             plot(csw(iframe-1)-lhw(winlen):csw(iframe-1)+rhw(winlen),sig(caw(iframe-1)+poffset(iframe-1)-lhw(winlen):caw(iframe-1)+poffset(iframe-1)+rhw(winlen)),'b')
        %             hold on
        %             plot(csw(iframe)-lhw(winlen):csw(iframe)+rhw(winlen),sig(caw(iframe)+poffset(iframe)-lhw(winlen):caw(iframe)+poffset(iframe)+rhw(winlen)),'r')
        %             hold off
        %             title('Calculated offset from signal')
        %             legend('previous frame','current frame')
        %             
        %             fprintf(1,'Frame = %d caw = %d csw = %d Calculated offset = %d\n',iframe,caw(iframe),csw(iframe),poffset(iframe));
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NEXT FRAME
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Next frame number
    iframe = iframe + 1;
    
    % Update predicted offset
    poffset(iframe) = poffset(iframe-1) + shopsize - ahopsize;
    
    % Next center of synthesis window (in signal reference)
    csw(iframe) = csw(iframe-1) + shopsize;
    
    % Next center of analysis window (in signal reference)
    caw(iframe) = caw(iframe-1) + ahopsize;
    
end

end

% FUNCTION THAT MAKES EACH FRAME
function frame = makeframe(sig,cw,winlen,duration)

frame = zeros(winlen,1);

if cw < 1
    
    up_bound = cw + rhw(winlen);
    
    if up_bound > 0
        
        frame(winlen-(up_bound-1):winlen) = sig(1:up_bound);
        
    end
    
elseif cw > duration
    
    low_bound = cw - lhw(winlen);
    
    if low_bound < duration
        
        frame(1:duration-(low_bound-1)) = sig(low_bound:duration);
        
    end
    
else
    
    % sample position of lower window bound in signal reference
    low_bound = max(1,cw - lhw(winlen));
    
    % sample position of upper window bound in signal reference
    up_bound = min(duration,cw + rhw(winlen));
    
    if cw - lhw(winlen) < 1
        
        frame(winlen-(up_bound-low_bound):winlen) = sig(low_bound:up_bound);
        
    elseif cw + rhw(winlen) > duration
        
        frame(1:(up_bound-low_bound)+1) = sig(low_bound:up_bound);
        
    else
        
        frame(1:winlen) = sig(low_bound:up_bound);
        
    end
    
end

end

function [Rxy,Rl] = xcorrel(x,y,W,Ss,Kmin,Kdec,Kmax)

if nargin < 3;  W = 600;        end;
if nargin < 4;  Ss = 120;       end;
if nargin < 5;  Kmin = 0;       end;
if nargin < 6;  Kdec = 1;       end;
if nargin < 7;  Kmax = W + Ss;  end;

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
    
    %     figure(1)
    %     plot(Ss+1:W,y(Ss+1:W),'k')
    %     hold on
    %     plot(1:Wov,x(1+k:Wov+k),'r')
    %     hold off
    %     title(sprintf('k = %d',k))
    %     pause(0.01)
    
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