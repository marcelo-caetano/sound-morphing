function [ampCurrNew,ampNextNew,freqCurrNew,freqNextNew,phaseCurrNew,phaseNextNew,ideath,ibirth,imatch,iempty] = partial_matching(ampCurr,ampNext,freqCurr,freqNext,phaseCurr,phaseNext,npartial,delta)
%PEAK MATCHING Match parameters of spectral peaks between consecutive
%frames
%
%   [CAm,NAm,CFm,NFm,CPm,NPm] = PARTIAL_MATCHING(CA,NA,CF,NF,CP,NP,delta,hopsize,sr)

% Input NPARTIAL == NBIN
% IND == IBIN
ind = 1:npartial;

% Indices of numeric frequencies
indFreqCurr = ind(not(isnan(freqCurr)));
indFreqNext = ind(not(isnan(freqNext)));

% Number of peaks
npeakCurr = length(indFreqCurr);
npeakNext = length(indFreqNext);

auxIndPeakCurr = 1:npeakCurr;
auxIndPeakNext = 1:npeakNext;

% Initialize
peakMatchCurr = zeros(npartial,1);
peakMatchNext = zeros(npartial,1);

lastMatch = 1;

for ipeakCurr = indFreqCurr
    
    % fprintf(1,'Current peak %d\n',ipeakCurr);
    
    if freqCurr(ipeakCurr)==0
        
        % disp('Current is 0')
        % fprintf(1,'No match for current peak %d\n',ipeakCurr);
        
        continue
        
    else
        
        % Initialize frequency match (index of peak in next frame)
        freqMatch = 0;
        
        % Minimum frequency difference found
        minFreqDiff = delta + 1;
        
        for ipeakNext = indFreqNext(lastMatch:end)
            
            % fprintf(1,'Next peak %d\n',ipeakNext);
            
            a=1;
            
            if freqNext(ipeakNext)==0
                
                % disp('Next is 0')
                % fprintf(1,'No match for next peak %d\n',ipeakNext);
                
                continue
                
            else
                
                a=1;
                
                % Step 1: Find candidate match
                if abs(freqCurr(ipeakCurr)-freqNext(ipeakNext)) <= delta % (26)
                    
                    % fprintf(1,'Entered candidate match\n');
                    
                    if abs(freqCurr(ipeakCurr)-freqNext(ipeakNext)) < minFreqDiff
                        
                        a=1;
                        
                        minFreqDiff = abs(freqCurr(ipeakCurr)-freqNext(ipeakNext));
                        freqMatch = ipeakNext;
                        
                        % fprintf(1,'Update min freq diff %f\n',minFreqDiff);
                        % fprintf(1,'Update candidate match %d\n',freqMatch);
                        
                    else
                        
                        % Never passes here
                        % fprintf(1,'Break\n');
                        
                        break % Found minimum frequency difference
                        
                    end
                    
                end
                
            end
            
        end
        
        a=1;
        
        % Step 2: Confirm candidate match
        if freqMatch > 0
            
            % Search current for better match
            % indFreqNext(auxIndPeakNext(indFreqNext==freqMatch)+1:end)
            for count = indFreqCurr(auxIndPeakCurr(indFreqCurr==ipeakCurr)+1:end)
                
                % fprintf(1,'Is current %d closer to next peak %d\n',count,ipeakNext);
                
                a=1;
                
                if abs(freqNext(freqMatch)-freqCurr(count)) < minFreqDiff % (27) freqNext(freqMatch) better match to freqCurr(count)
                    
                    % 2 additional cases
                    
                    % fprintf(1,'Entered better match\n');
                    
                    a=1;
                    
                    if auxIndPeakNext(indFreqNext==freqMatch) ~= 1 && indFreqNext(auxIndPeakNext(indFreqNext==freqMatch)-1) > indFreqNext(lastMatch) && abs(freqNext(indFreqNext(auxIndPeakNext(indFreqNext==freqMatch)-1))-freqCurr(ipeakCurr)) <= delta
                        
                        % fprintf(1,'Entered other condition\n');
                        
                        freqMatch = indFreqNext(auxIndPeakNext(indFreqNext==freqMatch)-1); % Best match
                        
                        a=1;
                        
                        % fprintf(1,'Freq match %d\n',freqMatch);
                        
                    else
                        
                        % disp('Death')
                        % fprintf(1,'Freq match %d\n',freqMatch);
                        freqMatch = 0; % Death
                        
                    end
                    
                    % fprintf(1,'Break best match\n');
                    
                    break % Best match
                    
                end
                
            end
            
        end
        
        a=1;
        
        if freqMatch > 0
            
            % Current peak in current frame receives index of match (freq match)
            % Each position has the index of the matched peak in NEXT
            peakMatchCurr(ipeakCurr) = freqMatch;
            
            % fprintf(1,'Final match for current %d\n',freqMatch);
            
            % Current peak in next frame receives index of match (ipeak_match)
            % Each position has the index of the matchd peak in CURR
            peakMatchNext(freqMatch) = ipeakCurr;
            
            % fprintf(1,'Final match for next %d\n',ipeakCurr);
            
            % Update last peak matched (in current frame)
            lastMatch = auxIndPeakNext(indFreqNext==freqMatch)+1;
            
            % fprintf(1,'Last matched current %d\n',freqMatch);
            
        end
        
    end
    
end

% % Keep track of match, birth, and death
% event = cell(npartial,1);

if all(peakMatchCurr==0)
    
    % No matches
    ampCurrNew = ampCurr;
    freqCurrNew = freqCurr;
    ampNextNew = ampNext;
    freqNextNew = freqNext;
    phaseCurrNew = phaseCurr;
    phaseNextNew = phaseNext;
    
    % Death
    ideath = not(isnan(freqCurrNew)) & isnan(freqNextNew);
    
    % Birth
    ibirth = isnan(freqCurrNew) & not(isnan(freqNextNew));
    
    % Match
    imatch = not(isnan(freqCurrNew)) & not(isnan(freqNextNew));
    
    % Empty
    iempty = isnan(freqCurrNew) & isnan(freqNextNew);
    
    %     event(ideath) = {'d'};
    %     event(ibirth) = {'b'};
    %     event(imatch) = {'m'};
    %     event(iempty) = {'e'};
    
else
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FINAL MATCH
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    a=1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % KEEP CURRENT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    freqCurrNew = freqCurr;
    ampCurrNew = ampCurr;
    phaseCurrNew = phaseCurr;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TRACK NEXT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Initialize
    freqNextNew = nan(npartial,1);
    ampNextNew = nan(npartial,1);
    phaseNextNew = nan(npartial,1);
    
    % Keep indices of all peaks in FREQNEXT
    % Peaks that match (move | not move) & are born
    indPeakNext = not(isnan(freqNext));
    
    % Keep indices of empty tracks in FREQNEXT (to avoid conflict)
    % indEmptyNext = isnan(freqNext);
    
    % indpeakMatch = logical(peakMatchNext);
    
    % Find positions NEXT move to
    posMoveTo = peakMatchNext(logical(peakMatchNext));
    
    % Find positions move from
    posMoveFrom = peakMatchCurr(logical(peakMatchCurr)); % posMatch
    
    % Find positions of empty tracks
    % [posEmpty] = find(indEmptyNext);
    
    % Indices of peaks that move
    indMove = logical(peakMatchNext) & not(logical(peakMatchCurr));
    
    % Indices of peaks that don't move
    indStay = logical(peakMatchCurr) & logical(peakMatchNext);
    
    % Indices of peaks born
    % ONLY PEAKS THAT MATCH FREQ
    % indNonMatch = all peaks NEXT & peaks NonMatch
    indBorn = indPeakNext & not(logical(peakMatchNext));
    
    % Check if moves to empty slot
    if any(not(isnan(freqNext(peakMatchNext(indMove)))))
        
        aux = freqNext(peakMatchNext(indMove));
        dispflag = 's';
        if strcmpi(dispflag,'v')
            fprintf(1,'Peak crushed %5.2f\n',aux(not(isnan(aux))));
        end
        % keyboard
        
    end
    
    a=1;
    
    % Move matches to new locations
    freqNextNew(posMoveTo) = freqNext(posMoveFrom);
    ampNextNew(posMoveTo) = ampNext(posMoveFrom);
    phaseNextNew(posMoveTo) = phaseNext(posMoveFrom);
    
    % Move non matches (born)
    freqNextNew(indBorn) = freqNext(indBorn);
    ampNextNew(indBorn) = ampNext(indBorn);
    phaseNextNew(indBorn) = phaseNext(indBorn);
    
    % Death
    ideath = not(isnan(freqCurrNew)) & isnan(freqNextNew);
    
    % Birth
    % PEAKS THAT COINCIDE POSITION BUT NOT FREQ MATCH
    % SOME TRACKS HAVE BIRTH+DEATH
    ibirth = isnan(freqCurrNew) & not(isnan(freqNextNew));
    
    % Match
    imatch = not(isnan(freqCurrNew)) & not(isnan(freqNextNew));
    
    % Empty
    iempty = isnan(freqCurrNew) & isnan(freqNextNew);
    
    %     event(ideath) = {'d'};
    %     event(ibirth) = {'b'};
    %     event(imatch) = {'m'};
    %     event(iempty) = {'e'};
    
end

end