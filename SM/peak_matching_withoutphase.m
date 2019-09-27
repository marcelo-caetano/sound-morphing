function [new_amp_curr,new_amp_next,new_freq_curr,new_freq_next,new_phase_curr] = peak_matching_withoutphase(amp_curr,amp_next,freq_curr,freq_next,phase_curr,delta)
%PEAK MATCHING Match parameters of spectral peaks between consecutive
%frames
%
%   [CAm,NAm,CFm,NFm,CPm,NPm] = PEAK_MATCHING(CA,NA,CF,NF,CP,NP,delta,hopsize,sr)

[npeak_curr,~] = size(freq_curr); % N
[npeak_next,~] = size(freq_next); % M

aux_peaks_curr = zeros(npeak_curr,1);
aux_peaks_next = zeros(npeak_next,1);

last_matched = 0;

for ipeak_curr = 1:npeak_curr
    
    % Initialize frequency match (index of peak in next frame)
    freq_match = 0;
    
    % Minimum frequency difference found
    min_freq_diff = delta + 1;
    
    for ipeak_next = last_matched+1:npeak_next
        
        % Step 1: Find candidate match
        if abs(freq_curr(ipeak_curr)-freq_next(ipeak_next)) <= delta % (26)
            
            if abs(freq_curr(ipeak_curr)-freq_next(ipeak_next)) < min_freq_diff
                
                min_freq_diff = abs(freq_curr(ipeak_curr)-freq_next(ipeak_next));
                freq_match = ipeak_next;
                
            else
                
                break % Found minimum frequency difference
                
            end
            
        end
        
    end
    
    a=1;
    
    % Step 2: Confirm candidate match
    if freq_match > 0
        
        for count = ipeak_curr+1:npeak_curr
            
            if abs(freq_next(freq_match)-freq_curr(count)) < min_freq_diff % (27) freq_next(freq_match) better match to freq_curr(count)
                
                % 2 additional cases
                    % Previous peak in NEXT was not matched AND freq_next
                if freq_match-1 > last_matched && abs(freq_next(freq_match-1)-freq_curr(ipeak_curr)) <= delta
                    
                    freq_match = freq_match-1; % Best match
                    
                else
                    
                    freq_match = 0; % Death
                    
                end
                
                break % Best match
                
            end
            
        end
        
    end
    
    a=1;
    
    if freq_match > 0
        
        % Current peak in current frame receives index of match (freq match)
        % Each position has the index of the matched peak in NEXT
        aux_peaks_curr(ipeak_curr) = freq_match;
        
        % Current peak in next frame receives index of match (ipeak_match)
        % Each position has the index of the matchd peak in CURR
        aux_peaks_next(freq_match) = ipeak_curr;
        
        % Update last peak matched (in current frame)
        last_matched = freq_match;
        
    end
    
end

% FINAL MATCH = npeak NEXT + number of dead peaks in CURR
npartial = npeak_next + length(aux_peaks_curr(aux_peaks_curr==0));

ipeak_curr = 1;
ipeak_next = 1;
ipartial = 1;
new_amp_curr = zeros(npartial,1);
new_amp_next = zeros(npartial,1);
new_freq_curr = zeros(npartial,1);
new_freq_next = zeros(npartial,1);
new_phase_curr = zeros(npartial,1);

% Keep track of match, birth, and death
event = cell(npartial,1);

a=1;

while ipartial <= npartial
    
    % fprintf(1,'Partial number is %d\n\n',ipartial);
    
    if ipeak_curr <= npeak_curr && ipeak_next <= npeak_next && aux_peaks_curr(ipeak_curr) == 0 && aux_peaks_next(ipeak_next) == 0 % Both match to zero
        
        % fprintf(1,'Neither has a match\n\n');
        
        if freq_curr(ipeak_curr) <= freq_next(ipeak_next) % Left frequency is smaller => DEATH CURR
            
            % fprintf(1,'Left frequency is smaller => Death current\n\n');
            
            event{ipartial} = 'death';
            
            new_amp_curr(ipartial) = amp_curr(ipeak_curr);
            new_amp_next(ipartial) = 0;
            new_freq_curr(ipartial) = freq_curr(ipeak_curr);
            new_freq_next(ipartial) = freq_curr(ipeak_curr);
            new_phase_curr(ipartial) = phase_curr(ipeak_curr);
            
            % Update current peak
            ipeak_curr = ipeak_curr + 1;
            
            % fprintf(1,'Current peak %d and Next peak %d\n\n',ipeak_curr,ipeak_next);
            
            % Update partial
            ipartial = ipartial + 1;
            
            % fprintf(1,'Next partial is %d\n\n',ipartial);
            
            a=1;
            
        else % Right frequency is smaller => DEATH CURR & BIRTH NEXT
            
            % fprintf(1,'Right frequency is smaller => Death current\n\n');
            
            event{ipartial} = 'death';
            
            % Death CURR
            new_amp_curr(ipartial) = amp_curr(ipeak_curr);
            new_amp_next(ipartial) = 0;
            new_freq_curr(ipartial) = freq_curr(ipeak_curr);
            new_freq_next(ipartial) = freq_curr(ipeak_curr);
            new_phase_curr(ipartial) = phase_curr(ipeak_curr);
            
            % Update current peak
            ipeak_curr = ipeak_curr + 1;
            
            % fprintf(1,'Right frequency is smaller => Birth next\n\n');
            
            % Update partial
            ipartial = ipartial + 1;
            
            % fprintf(1,'Next partial is %d\n\n',ipartial);
            
            event{ipartial} = 'birth';
            
            % Birth NEXT
            new_amp_curr(ipartial) = 0;
            new_amp_next(ipartial) = amp_next(ipeak_next);
            new_freq_curr(ipartial) = freq_next(ipeak_next);
            new_freq_next(ipartial) = freq_next(ipeak_next);
            new_phase_curr(ipartial) = 0;
            
            % Update next peak
            ipeak_next = ipeak_next + 1;
            
            % Update partial
            ipartial = ipartial + 1;
            
            % fprintf(1,'Current peak %d and Next peak %d\n\n',ipeak_curr,ipeak_next);
            
            a=1;
            
        end
        
    elseif ipeak_curr <= npeak_curr && aux_peaks_curr(ipeak_curr) == 0 % Current matches to zero => Death
        
        % fprintf(1,'Current peak has no match => Death current\n\n');
        
        event{ipartial} = 'death';
        
        new_amp_curr(ipartial) = amp_curr(ipeak_curr);
        new_amp_next(ipartial) = 0;
        new_freq_curr(ipartial) = freq_curr(ipeak_curr);
        new_freq_next(ipartial) = freq_curr(ipeak_curr);
        new_phase_curr(ipartial) = phase_curr(ipeak_curr);
        
        % Update current peak
        ipeak_curr = ipeak_curr + 1;
        
        % fprintf(1,'Current peak %d and Next peak %d\n\n',ipeak_curr,ipeak_next);
        
        % Update partial
        ipartial = ipartial + 1;
        
        % fprintf(1,'Next partial is %d\n\n',ipartial);
        
        a=1;
        
    elseif ipeak_next <= npeak_next && aux_peaks_next(ipeak_next) == 0 % Next matches to zero => Birth
        
        % fprintf(1,'Next peak has no match => Birth next\n\n');
        
        event{ipartial} = 'birth';
        
        new_amp_curr(ipartial) = 0;
        new_amp_next(ipartial) = amp_next(ipeak_next);
        new_freq_curr(ipartial) = freq_next(ipeak_next);
        new_freq_next(ipartial) = freq_next(ipeak_next);
        new_phase_curr(ipartial) = 0;
        
        % Update next peak
        ipeak_next = ipeak_next + 1;
        
        % fprintf(1,'Current peak %d and Next peak %d\n\n',ipeak_curr,ipeak_next);
        
        % Update partial
        ipartial = ipartial + 1;
        
        % fprintf(1,'Next partial is %d\n\n',ipartial);
        
        a=1;
        
    elseif ipeak_curr > npeak_curr && ipeak_next > npeak_next % Dealt with all matches
        
        % fprintf(1,'Done with all peaks => Break loop\n\n');
        
        break
        
    else % They match each other
        
        % fprintf(1,'Both have a match => They match each other\n\n');
        
        event{ipartial} = 'match';
        
        new_amp_curr(ipartial) = amp_curr(ipeak_curr);
        new_amp_next(ipartial) = amp_next(ipeak_next);
        new_freq_curr(ipartial) = freq_curr(ipeak_curr);
        new_freq_next(ipartial) = freq_next(ipeak_next);
        new_phase_curr(ipartial) = phase_curr(ipeak_curr);
        
        % Update current peak
        ipeak_curr = ipeak_curr + 1;
        
        % Update next peak
        ipeak_next = ipeak_next + 1;
        
        % fprintf(1,'Current peak %d and Next peak %d\n\n',ipeak_curr,ipeak_next);
        
        % Update partial
        ipartial = ipartial + 1;
        
        % fprintf(1,'Next partial is %d\n\n',ipartial);
        
        a=1;
        
    end
    
    % fprintf(1,'Counter Overflow at %f\n\n',ipartial)
    
end

% fprintf(1,'Passed here\n')
% keyboard

end