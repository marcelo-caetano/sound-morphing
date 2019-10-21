function [amppart,freqpart,phasepart,npartial] = peak2track(amp,freq,ph,nframe,maxnpeak,nfft,sr,delta,dispflag)
%PEAK2TRACK Convert spectral peaks into partial tracks.
%   [Ap,Fp,Pp,NPARTIAL] = PEAK2TRACK(A,F,P,NFRAME,MAXNPEAK,NFFT,SR,DELTA,DISPFLAG)

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIAL TRACKING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MERGE PARTIALS BY FREQUENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Median frequency of each track
m = median(freqbin,2,'omitnan');

aux = (1:nbin)';

% Positions of tracks closer in median frequency than DELTA
[indrep] = find(abs(diff(m)) < delta);

% Positions of adjacent track;
posadj = indrep(diff(indrep)==1);

% Indices of tracks kept (not merged)
indkeep = not(ismember((1:nbin),unique([indrep;indrep+1])));

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
            
            % This track was merged
            continue
            
        else
            
            % Merge 2 tracks
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

end