function [ampharm,freqharm,phaseharm,isharmonic] = track2harm(amptrack,freqtrack,phasetrack,ntrack,nframe,f0,delta)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%
%   See also

% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


a=1;

% Median of frequencies in tracks
medfreqtrack = median(freqtrack,2,'omitnan');

% Harmonic number
harmnumber = (1:ntrack)';

% Harmonics of F0
harmseries = f0*harmnumber;

% True for track with harmonic frequency
isharmonic = false(ntrack,1);

% Index of harmonic tracks
harmpos = nan(ntrack,1);

% Initialize
ampharm = nan(ntrack,nframe);
freqharm = nan(ntrack,nframe);
phaseharm = nan(ntrack,nframe);

% % Index of inharmonic tracks
% inharmpos = nan(ntrack,1);

for itrack = 1:ntrack
    
    if any(abs(bsxfun(@minus,medfreqtrack,harmseries(itrack))) < delta)
        
        isharmonic(itrack) = true;
        
        if length(find(abs(bsxfun(@minus,medfreqtrack,harmseries(itrack))) < delta)) == 1
            
            harmpos(itrack) = find(abs(bsxfun(@minus,medfreqtrack,harmseries(itrack))) < delta);
            
        else
            
            [~,harmpos(itrack)] = min(abs(bsxfun(@minus,medfreqtrack,harmseries(itrack))));
            
        end
        
    end
    
end

% Number of harmonics
% nharm = nnz(isharmonic);

% Amplitudes of the harmonic tracks
% amptrack(harmpos(isharmonic),:);

% Frequencies of the harmonic tracks
% freqtrack(harmpos(isharmonic),:);

% Phases of the harmonic tracks
% phasetrack(harmpos(isharmonic),:);

% Corresponding harmonic number
% harmnumber(isharmonic)

% Assign amplitudes of tracks to corresponding harmonic
ampharm(harmnumber(isharmonic),:) = amptrack(harmpos(isharmonic),:);

% Assign frequencies of tracks to corresponding harmonic
freqharm(harmnumber(isharmonic),:) = freqtrack(harmpos(isharmonic),:);

% Assign amplitudes of tracks to corresponding harmonic
phaseharm(harmnumber(isharmonic),:) = phasetrack(harmpos(isharmonic),:);

% hnum = harmnumber(isharmonic);

% Positions of inharmonic tracks
% inharmpos(not(isharmonic)) = harmnumber(not(ismember(harmnumber,harmpos(isharmonic))));

% ampinharm(not(isharmonic),:) = amptrack(inharmpos,:);
% freqinharm(not(isharmonic),:) = freqtrack(inharmpos,:);
% phaseinharm(not(isharmonic),:) = phasetrack(inharmpos,:);

a=1;

end
