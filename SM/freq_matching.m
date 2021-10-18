function [amp_prev,freq_prev,ph_prev,npartial] = freq_matching(amp_prev,freq_prev,ph_prev,amp_next,freq_next,ph_next,freq_diff,hop,fs,ifr)
%FREQ_MATCHING Match parameters of spectral peaks between consecutive frames.
%   Adapted from [1].
%
%   [amp_prev,freq_prev,ph_prev] = FREQ_MATCHING(amp_prev,freq_prev,ph_prev,amp_next,freq_next,ph_next,freq_diff,hop,fs,ifr)
%
%   See also PEAK2TRACK, PARTIAL_MATCHING
%
% [1] McAulay and Quatieri (1986, August). Speech analysis/synthesis
% based on a sinusoidal representation. IEEE Transactions on Acoustics,
% Speech, and Signal Processing ASSP-34(4),744-754.

% 2020 MCaetano SMT 0.2.1 (Revised)
% 2021 M Caetano SMT (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% TODO: UNIT TEST WITH SYNTHETIC PARTIALS THAT SIMULATE MATCH, DEATH, BIRTH
% See /DSP/Dev/SM/_UnitTest/test_partial_tracks.m
% TODO: REPLACE INDEX OF INDEX FREQ_CURR(IFREQ_CURR) WITH NUMERICAL INDEX
% TODO: ADAPT LOCAL FUNCTION matchPartials TO HANDLE ONLY BIRTH/DEATH

% Frequencies of current frame
freq_curr = freq_prev(:,end);
npeak = length(freq_curr);

% Numerical indices of frequencies
ifreq_curr = find(~isnan(freq_curr));
ifreq_next = find(~isnan(freq_next));

% Number of peaks in CURR
npeak_curr = length(ifreq_curr);

% Number of peaks in NEXT
npeak_next = length(ifreq_next);

%%%%%%%%%%%%%%%
% GUIDELINES
%%%%%%%%%%%%%%%
% NaN: no data
% 0: Birth
% -1: Death
% n > 0: matching peak number (Match)
% ivar: numerical index of var
% bool_var: logical index of var

% No peaks in CURR => Only BIRTH
if isempty(ifreq_curr) && ~isempty(ifreq_next)
    
    % No data in CURR
    peak_curr = nan(npeak_curr,1);
    
    % NPEAK_NEXT peaks born in NEXT
    % BIRTH: NEXT == 0
    peak_next = zeros(npeak_next,1);
    
    % No peaks in NEXT => Only DEATH
elseif ~isempty(ifreq_curr) && isempty(ifreq_next)
    
    % NPEAK_CURR peaks die in CURR
    % DEATH: CURR == -1
    peak_curr = -ones(npeak_curr,1);
    
    % No data in NEXT
    peak_next = nan(npeak_next,1);
    
    % Silence
elseif isempty(ifreq_curr) && isempty(ifreq_next)
    
    % No data in CURR
    peak_curr = nan(npeak_curr,1);
    
    % No data in NEXT
    peak_next = nan(npeak_curr,1);
    
    % Both CURR and NEXT have peaks
else
    
    % Match partials
    [peak_curr,peak_next] = matchPartials(freq_curr,freq_next,ifreq_curr,ifreq_next,npeak_curr,npeak_next,freq_diff);
    
end % END If CURR has peaks

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 3: UNMATCHED PEAKS IN NEXT ARE BORN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[bool_death,bool_match_curr,bool_match_next,bool_birth] = ind2bool(peak_curr,peak_next);

[ndeath,nmatch,nbirth,npartial] = getNumEvent(bool_death,bool_match_curr,bool_birth);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET INDICES OF EVENTS IN PREVIOUS FRAMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[bool_part_death_curr,bool_part_match_curr,bool_part_birth_curr] = bool2event(freq_curr,freq_next,ifreq_curr,ifreq_next,bool_death,bool_match_curr,bool_birth,ndeath,nmatch);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ASSIGN PARTIALS BY EVENT: BIRTH; DEATH; MATCH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize variables
new_amp = nan(npartial,ifr+1);
new_freq = nan(npartial,ifr+1);
new_ph = nan(npartial,ifr+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handle MATCH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nmatch ~= 0
    
    % Convert subscripts to linear indexing (for previous frames)
    rowsub = repmat(ifreq_curr(peak_next(bool_match_next)),1,ifr);
    colsub = repmat(1:ifr,nmatch,1);
    inext = sub2ind([npeak ifr],rowsub,colsub);
    
    % Create multi-frame logical index matrix
    ipart = repmat(bool_part_match_curr,1,ifr);
    
    % Between frame 1 and NFR
    new_amp(ipart) = amp_prev(inext);
    new_freq(ipart) = freq_prev(inext);
    new_ph(ipart) = ph_prev(inext);
    
    % frame NFR+1
    new_amp(bool_part_match_curr,ifr+1) = amp_next(ifreq_next(peak_curr(bool_match_curr)));
    new_freq(bool_part_match_curr,ifr+1) = freq_next(ifreq_next(peak_curr(bool_match_curr)));
    new_ph(bool_part_match_curr,ifr+1) = ph_next(ifreq_next(peak_curr(bool_match_curr)));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handle DEATH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ndeath ~= 0
    
    % Convert subscripts to linear indexing (for previous frames)
    rowsub = repmat(ifreq_curr(bool_death),1,ifr);
    colsub = repmat(1:ifr,ndeath,1);
    iprev = sub2ind([npeak ifr],rowsub,colsub);
    
    % Create multi-frame logical index matrix
    ipart = repmat(bool_part_death_curr,1,ifr);
    
    % Between frame 1 and NFR
    new_freq(ipart) = freq_prev(iprev);
    new_amp(ipart) = amp_prev(iprev);
    new_ph(ipart) = ph_prev(iprev);
    
    % frame NFR+1
    new_freq(bool_part_death_curr,ifr+1) = freq_prev(ifreq_curr(bool_death),ifr);
    new_amp(bool_part_death_curr,ifr+1) = 0;
    new_ph(bool_part_death_curr,ifr+1) = ph_prev(ifreq_curr(bool_death),ifr) + 2*pi*freq_prev(ifreq_curr(bool_death),ifr)*hop/fs;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handle BIRTH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nbirth ~= 0
    
    % Between frame 1 and NFR-1 (REBIRTH)
    
    % frame NFR
    new_freq(bool_part_birth_curr,ifr) = freq_next(ifreq_next(bool_birth));
    new_amp(bool_part_birth_curr,ifr) = 0;
    new_ph(bool_part_birth_curr,ifr) = ph_next(ifreq_next(bool_birth)) - 2*pi*freq_next(ifreq_next(bool_birth))*hop/fs;
    
    % frame NFR+1
    new_freq(bool_part_birth_curr,ifr+1) = freq_next(ifreq_next(bool_birth));
    new_amp(bool_part_birth_curr,ifr+1) = amp_next(ifreq_next(bool_birth));
    new_ph(bool_part_birth_curr,ifr+1) = ph_next(ifreq_next(bool_birth));
    
end

amp_prev = new_amp;
freq_prev = new_freq;
ph_prev = new_ph;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOCAL FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Local function to calculate frequency difference
function fdiff = calcFreqDiff(freqCurr,freqNext,ifreqCurr,ifreqNext,indCurr,indNext)

fdiff = abs(freqCurr(ifreqCurr(indCurr)) - freqNext(ifreqNext(indNext)));

end

% Local function to find candidate match
function [candMatch,minFreqDiff] = findCandidateMatch(freqCurr,freqNext,indFreqCurr,indFreqNext,probePeakCurr,unmatchedPeakNext,diffThreshold)

% Calculate frequency difference
freqDiff = calcFreqDiff(freqCurr,freqNext,indFreqCurr,indFreqNext,probePeakCurr,unmatchedPeakNext);

% If there are peaks in NEXT within DELTA
if any(freqDiff <= diffThreshold)
    
    % Candidate match gets the minimum frequency difference
    [minFreqDiff,indMinFreqDiff] = min(freqDiff);
    
    % Keep numerical index of matching NEXT peak to confirm match in STEP 2
    candMatch = unmatchedPeakNext(indMinFreqDiff);
    
else
    
    % Unused minimum frequency difference
    minFreqDiff = nan(1);
    
    % DEATH of CURR
    candMatch = -1;
    
end

end

% Local function to confirm candidate match
function finalMatch = confirmCandidateMatch(freqCurr,freqNext,indFreqCurr,indFreqNext,probePeakCurr,numPeakCurr,candMatch,lastMatch,minFreqDiff,freqDiffThreshold)

% Frequency difference between peaks in CURR above PROBE and CANDMATCH in NEXT
freqDiff = calcFreqDiff(freqCurr,freqNext,indFreqCurr,indFreqNext,probePeakCurr+1:numPeakCurr,candMatch);

% If no peak above PROBE in CURR is better match
if ~any(freqDiff < minFreqDiff)
    
    % Confirm match
    finalMatch = candMatch;
    
else
    
    % Look below CANDMATCH in NEXT for a match for PROBE in CURR
    if candMatch ~= 1 && lastMatch + 1 <= candMatch - 1
        
        % Assign candidate match or DEATH as final match
        finalMatch = findCandidateMatch(freqCurr,freqNext,indFreqCurr,indFreqNext,probePeakCurr,lastMatch+1:candMatch-1,freqDiffThreshold);
        
    else
        
        finalMatch = -1;
        
    end
    
end

end

% Local function to match partials
function [peakCurr,peakNext] = matchPartials(freqCurr,freqNext,indFreqCurr,indFreqNext,numPeakCurr,numPeakNext,freqDiffThreshold)

% Initialize CURR without data
peakCurr = nan(numPeakCurr,1);

% Initialize all NEXT as BIRTH
peakNext = zeros(numPeakNext,1);

% Numerical index of last peak matched
indLastMatch = 0;

for indPeakCurr = 1:numPeakCurr
    
    % Indices of unmatched peaks of the NEXT frame
    indUnmatch = indLastMatch+1:numPeakNext;
    
    % STEP 1: Find candidate match in NEXT frame
    [indMatch,minFreqDiff] = findCandidateMatch(freqCurr,freqNext,indFreqCurr,indFreqNext,indPeakCurr,indUnmatch,freqDiffThreshold);
    
    % If there was a match
    if indMatch ~= -1
        
        % STEP 2: Confirm candidate match in NEXT frame
        indMatch = confirmCandidateMatch(freqCurr,freqNext,indFreqCurr,indFreqNext,indPeakCurr,numPeakCurr,indMatch,indLastMatch,minFreqDiff,freqDiffThreshold);
        
    end
    
    % Assign CURR
    peakCurr(indPeakCurr) = indMatch;
    
    % If there was a match
    if indMatch ~= -1
        
        % Assign NEXT
        peakNext(indMatch) = indPeakCurr;
        
        % Update LAST_MATCH
        indLastMatch = indMatch;
        
    end
    
end

end

function [boolDeath,boolMatchCurr,boolMatchNext,boolBirth] = ind2bool(peakCurr,peakNext)

% Logical indices of Deaths (NPEAK_CURR)
boolDeath = peakCurr==-1;

% Logical indices of matches (CURR)
boolMatchCurr = peakCurr ~= -1;

% Logical indices of matches (NEXT)
boolMatchNext = peakNext ~= 0;

% Logical indices of Births (NPEAK_NEXT)
boolBirth = peakNext==0;

end

function [ndeath,nmatch,nbirth,npartial] = getNumEvent(boolDeath,boolMatch,boolBirth)

% Number of Deaths
ndeath = nnz(boolDeath);

% Number of Matches
nmatch = nnz(boolMatch);

% Number of Births
nbirth = nnz(boolBirth);

% Total number of partial tracks
npartial = nbirth + ndeath + nmatch;

end

function [boolDeathPart,boolMatchPart,boolBirthPart] = bool2event(freqCurr,freqNext,ifreqCurr,ifreqNext,boolDeath,boolMatch,boolBirth,nDeath,nMatch)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INSERT BIRTH FREQUENCIES INTO CORRESPONDING PARTIAL BY FREQUENCY
% Concatenate frequencies by event: [DEATH; MATCH; BIRTH] and sort the
% frequencies in ascending order. Compare the indices of the sorted
% frequencies with their original positions to insert the events into the
% corresponding frequency slot (i.e., partials arranged in ascending
% frequency)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Concatenate frequencies by event: [DEATH; MATCH; BIRTH]
freqEvent = [freqCurr(ifreqCurr(boolDeath));freqCurr(ifreqCurr(boolMatch));freqNext(ifreqNext(boolBirth))];

% Numerical indices of sorted frequencies in ascending order
[~,iEvent] = sort(freqEvent);

% Get indices in CURR by event: [DEATH; MATCH; BIRTH]
boolDeathPart = iEvent <= nDeath;
boolMatchPart = iEvent > nDeath & iEvent <= nDeath + nMatch;
boolBirthPart = iEvent > nDeath + nMatch;

% % Get indices in NEXT by event: [DEATH; MATCH; BIRTH]
% boolDeathPart = iEvent <= nDeath;
% boolMatchPart = iEvent > nDeath & ievent_next <= nDeath + nMatch;
% boolBirthPart = iEvent > nDeath + nMatch;

end
