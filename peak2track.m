function [amppart,freqpart,phasepart,npartial] = peak2track(amp,freq,ph,nframe,maxnpeak,nfft,sr,delta,dispflag)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK FUNCTION INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

narginchk(8,9)

if nargin == 8
    
    dispflag = 's';
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION BODY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Bin of FFT
binfft = sr/nfft;

% Center of bins of FFT
cbinfft = 0:binfft:sr/2;

% Number of bins of FFT
nbin = nfft/2 + 1;

% Initialize variables
amppeak = nan(maxnpeak,nframe);
freqpeak = nan(maxnpeak,nframe);
phasepeak = nan(maxnpeak,nframe);

% Number of peaks in each frame
npeak = cellfun('size',amp,1);

% From cell 2 array
for iframe = 1:nframe
    
    amppeak(1:npeak(iframe),iframe) = amp{iframe};
    freqpeak(1:npeak(iframe),iframe) = freq{iframe};
    phasepeak(1:npeak(iframe),iframe) = ph{iframe};
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAKE FFT BINS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Edge of histogram bins
fedge = -binfft/2:binfft:sr/2+binfft/2;

% Index of frequency bin each peak belongs to
indbin = discretize(freqpeak,fedge);

% Initialize variables
freqbin = nan(nbin,nframe);
ampbin = nan(nbin,nframe);
phasebin = nan(nbin,nframe);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUN THROUGH ALL PEAKS AND ALLOCATE TO RIGHT BIN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FOR EACH FRAME
for iframe = 1:nframe
    
    % Index of values
    ind = not(isnan(indbin(:,iframe)));
    
    % Assign only values
    ampbin(indbin(ind,iframe),iframe) = amppeak(ind,iframe);
    freqbin(indbin(ind,iframe),iframe) = freqpeak(ind,iframe);
    phasebin(indbin(ind,iframe),iframe) = phasepeak(ind,iframe);
    
end

a=1;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % RUN THROUGH ALL BINS AND ELLIMINATE WHENEVER NO FREQUENCY BELONGS TO BIN
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% % Initialize track
% istrack = false(nbin,1);
%
% for ibin = 1:nbin
%
%     istrack(ibin) = not(all(isnan(freqbin(ibin,:))));
%
% end
%
% % Number of tracks
% ntrack = nnz(istrack);
%
% freqtrack = freqbin(istrack,:);
% amptrack = ampbin(istrack,:);
% phasetrack = phasebin(istrack,:);
%
% % Frequency limit
% fmin = 000;
% flim = 4000;
%
% % Horizontal lines dividing FFT bins
% ybin = [cbinfft(istrack)-binfft/2;cbinfft(istrack)-binfft/2];
% xbin = [ones(1,ntrack);nframe*ones(1,ntrack)];
%
% % Vertical lines at center of frames
% xfr = [(1:nframe);(1:nframe)];
% yfr = [zeros(1,nframe);flim*ones(1,nframe)];
%
% % Plot bins
% figure
% plot((1:nframe),freqtrack,'*-')
% hold on
% line(xbin,ybin,'LineWidth',1,'LineStyle','-','Color',[0.55 0.55 0.55])
% line(xfr,yfr,'LineWidth',1,'LineStyle','--','Color',[0.35 0.35 0.35])
% hold off
% ylim([fmin flim]);

a=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAKE HARMONICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Edge of histogram bins
% fedge = -binfft/2:binfft:sr/2+binfft/2;
%
% % Index of frequenct bin each peak belongs to
% indbin = discretize(freqpeak,fedge);
%
% % Initialize variables
% freqbin = nan(nbin,nframe);
% ampbin = nan(nbin,nframe);
% phasebin = nan(nbin,nframe);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIAL TRACKING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Keep track of DEATH, BIRTH, and MATCH
% % event = cell(nframe-1,1);
% death = false(ntrack,nframe);
% birth = false(ntrack,nframe);
% match = false(ntrack,nframe);
% emptyTrack = false(ntrack,nframe);

% Keep track of DEATH, BIRTH, and MATCH
death = false(nbin,nframe);
birth = false(nbin,nframe);
match = false(nbin,nframe);
emptyTrack = false(nbin,nframe);


for iframe = 1:nframe-1
    
    % Match
    [ampbin(:,iframe),ampbin(:,iframe+1),freqbin(:,iframe),freqbin(:,iframe+1),phasebin(:,iframe),phasebin(:,iframe+1),death(:,iframe),birth(:,iframe),match(:,iframe),emptyTrack(:,iframe)] = ...
        partial_matching(ampbin(:,iframe),ampbin(:,iframe+1),freqbin(:,iframe),freqbin(:,iframe+1),phasebin(:,iframe),phasebin(:,iframe+1),nbin,delta);
    
end

% Whenever a track dies in PARTIAL TRACKING it is reborn in different track
a=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ELLIMINATE EMPTY TRACKS (ALL NAN)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Initialize track
% istrack = false(nbin,1);
%
% for itrack = 1:nbin
%
%     istrack(itrack) = not(all(isnan(freqbin(itrack,:))));
%
% end
%
% % Number of tracks
% ntrack = nnz(istrack);
%
% freqtrack = freqtrack(istrack,:);
% amptrack = amptrack(istrack,:);
% phasetrack = phasetrack(istrack,:);

% % Plot partials
% figure
% plot((1:nframe),freqtrack,'*-')
% hold on
% line(xbin,ybin,'LineWidth',1,'LineStyle','-','Color',[0.55 0.55 0.55])
% line(xfr,yfr,'LineWidth',1,'LineStyle','--','Color',[0.35 0.35 0.35])
% hold off
% ylim([fmin flim]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MERGE PARTIALS BY FREQUENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Median frequency of each track
m = median(freqbin,2,'omitnan');

% Replace if frequencies closer to the median of another track

a=1;

% % Horizontal lines dividing FFT bins
% xmed = [ones(1,ntrack);nframe*ones(1,ntrack)];
% ymed = [m,m]';

% % Plot tracks
% figure
% plot((1:nframe),freqtrack,'*-')
% hold on
% % line(xbin,ybin,'LineWidth',1,'LineStyle','-','Color',[0.55 0.55 0.55])
% % line(xfr,yfr,'LineWidth',1,'LineStyle','--','Color',[0.35 0.35 0.35])
% line(xmed,ymed,'LineWidth',2,'LineStyle','-','Color',[0.55 0.55 0.55])
% hold off
% ylim([fmin flim]);

% % Plot tracks
% figure(1)
% plot((1:nframe),freqtrack(1,:),'y*-')
% hold on
% plot((1:nframe),freqtrack(2,:),'k*-')
% plot((1:nframe),freqtrack(3,:),'g*-')
% plot((1:nframe),freqtrack(4,:),'b*-')
% plot((1:nframe),freqtrack(5,:),'m*-')
% plot((1:nframe),freqtrack(6,:),'c*-')
% plot((1:nframe),freqtrack(7,:),'r*-')
% plot((1:nframe),freqtrack(8,:),'yo-')
% plot((1:nframe),freqtrack(9,:),'ko-')
% plot((1:nframe),freqtrack(10,:),'go-')
% plot((1:nframe),freqtrack(11,:),'bo-')
% plot((1:nframe),freqtrack(12,:),'mo-')
% plot((1:nframe),freqtrack(13,:),'co-')
% plot((1:nframe),freqtrack(14,:),'ro-')
% plot((1:nframe),freqtrack(15,:),'y+-')
% plot((1:nframe),freqtrack(16,:),'k+-')
% plot((1:nframe),freqtrack(17,:),'g+-')
% plot((1:nframe),freqtrack(18,:),'b+-')
% plot((1:nframe),freqtrack(19,:),'m+-')
% plot((1:nframe),freqtrack(20,:),'c+-')
% plot((1:nframe),freqtrack(21,:),'r+-')
% plot((1:nframe),freqtrack(22,:),'yd-')
% plot((1:nframe),freqtrack(23,:),'kd-')
% plot((1:nframe),freqtrack(24,:),'gd-')
% plot((1:nframe),freqtrack(25,:),'bd-')
% plot((1:nframe),freqtrack(26,:),'md-')
% plot((1:nframe),freqtrack(27,:),'cd-')
% plot((1:nframe),freqtrack(28,:),'rd-')
% line(xmed,ymed,'LineWidth',2,'LineStyle','-','Color',[0.55 0.55 0.55])
% hold off
% ylim([fmin flim]);

a=1;

aux = (1:nbin)';
% ntrack = nkeep               + nmerge ()
% ntrack = legth(aux(indkeep)) + length(unique([irep;irep+1]))

% Positions of tracks closer in median frequency than DELTA
[indrep] = find(abs(diff(m)) < delta);

% Positions of adjacent track;
posadj = indrep(diff(indrep)==1);

% Indices of tracks kept (not merged)
indkeep = not(ismember((1:nbin),unique([indrep;indrep+1])));

% Positions of tracks kept
% poskeep = aux(not(ismember((1:ntrack),unique([indrep;indrep+1]))));

% Indices of trackes merged
% indmerge = ismember((1:ntrack),unique([indrep;indrep+1]));

% Positions of tracks merged
% posmerge = aux(ismember((1:ntrack),unique([indrep;indrep+1])));

% Number of merged partials
% nmerge = length(posmerge);

% Final number of partials
% npartial = ntrack - length(irep);

% Initialize partial index
ipart = 1;

% Initialize partials
amppart = nan(nbin,nframe);
freqpart = nan(nbin,nframe);
phasepart = nan(nbin,nframe);

% Run through all tracks and merge
for ibin = 1:nbin
    
    if strcmpi(dispflag,'v')
        
        fprintf(1,'Track %d of %d\n',ibin,nbin);
        
    end
    
    if indkeep(ibin) || ibin == nbin
        
        amppart(ipart,:) = ampbin(ibin,:);
        freqpart(ipart,:) = freqbin(ibin,:);
        phasepart(ipart,:) = phasebin(ibin,:);
        
        % Next partial
        ipart = ipart + 1;
        
    else % merge
        
        a=1;
        
        if any(ismember(posadj,ibin))
            
            % Merge 3 tracks
            for count = posadj(ismember(posadj,ibin)):min(posadj(ismember(posadj,ibin))+2,nbin)
                
                if strcmpi(dispflag,'v')
                    
                    fprintf(1,'Track %d of %d\n',count,nbin);
                    
                end
                
                % Find indices of frequencies
                ind = not(isnan(freqbin(count,:)));
                
                % Pass values
                amppart(ipart,ind) = ampbin(count,ind);
                freqpart(ipart,ind) = freqbin(count,ind);
                phasepart(ipart,ind) = phasebin(count,ind);
                
            end
            
            % Next partial
            ipart = ipart + 1;
            
        elseif any(ismember(indrep+1,ibin)) || any(ismember(posadj+1,ibin)) || any(ismember(posadj+2,ibin))
            
            a=1;
            
            % This track was merged
            continue
            
        else
            
            % Merge 2 tracks
            a=1;
            
            for count = indrep(ismember(indrep,ibin)):indrep(ismember(indrep,ibin))+1
                
                % Find indices of frequencies
                ind = not(isnan(freqbin(count,:)));
                
                % Pass values
                amppart(ipart,ind) = ampbin(count,ind);
                freqpart(ipart,ind) = freqbin(count,ind);
                phasepart(ipart,ind) = phasebin(count,ind);
                
            end
            
            % Next partial
            ipart = ipart + 1;
            
        end
        
    end
    
end

a=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ELLIMINATE EMPTY TRACKS (ALL NAN)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize track
ispartial = false(nbin,1);

for ibin = 1:nbin
    
    ispartial(ibin) = not(all(isnan(freqpart(ibin,:))));
    
end

% Number of tracks
npartial = nnz(ispartial);

freqpart = freqpart(ispartial,:);
amppart = amppart(ispartial,:);
phasepart = phasepart(ispartial,:);

% % % Plot partials
% % figure(2)
% % plot((1:nframe),freqpart,'*-')
% % ylim([fmin flim]);

a=1;

end