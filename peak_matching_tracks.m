function [new_amp_curr,new_amp_next,new_freq_curr,new_freq_next,new_phase_curr,new_phase_next] = peak_matching_tracks(amp_curr,amp_next,freq_curr,freq_next,phase_curr,phase_next,delta,hopsize,sr)
%PEAK MATCHING Match parameters of spectral peaks between consecutive
%frames
%
%   [CAm,NAm,CFm,NFm,CPm,NPm] = PEAL_MATCHING(CA,NA,CF,NF,CP,NP,delta,hopsize,sr)

% Number of peaks for current frame
[npeak_curr,~] = size(freq_curr); % N

% Number of peaks for next frame
[npeak_next,~] = size(freq_next); % M

% Initialize auxiliary variables
aux_peaks_curr = zeros(npeak_curr,1);
aux_peaks_next = zeros(npeak_next,1);

% Initialize last peak matched
last_matched = 0;

% For each peak of the current frame
for ipeak_curr = 1:npeak_curr
    
    % Initialize index of match
    ipeak_match = 0;
    
    % Initialize minimum frequency difference found
    min_freq_diff = delta + 1;
    
    % For each peak of the next frame
    for ipeak_next = last_matched+1:npeak_next
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Step 1: Find candidate match
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % If frequency difference < delta (in Hz)
        if abs(freq_curr(ipeak_curr)-freq_next(ipeak_next)) <= delta % (26) frequency difference < delta
            
            % If frequency difference < minimum difference found so far
            if abs(freq_curr(ipeak_curr)-freq_next(ipeak_next)) < min_freq_diff
                
                % Frequency difference becomes minimum difference
                min_freq_diff = abs(freq_curr(ipeak_curr)-freq_next(ipeak_next));
                
                % The next frame peak index is the match
                ipeak_match = ipeak_next;
                
            else
                
                break
                
            end
            
        end
        
    end
    
    a=1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Step 2: Confirm candidate match
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % If there was a match
    if ipeak_match > 0
        
        % ipartial from the next peak of the current frame
        for ipartial = ipeak_curr+1:npeak_curr
            
            % If next peak of current frame is a better match
            if min_freq_diff > abs(freq_next(ipeak_match)-freq_curr(ipartial)) % (27) freq_next(ipeak_match) better match to freq_curr(ipartial)
                
                % 2 additional cases
                
                % This peak matches with previous peak instead
                if ipeak_match-1 > last_matched && abs(freq_next(ipeak_match-1)-freq_curr(ipeak_curr)) <= delta
                    
                    ipeak_match = ipeak_match-1; % Best match
                    
                else
                    
                    % This partial ends
                    ipeak_match = 0; % Death
                    
                end
                
                break % Best match
                
            end
            
        end
        
    end
    
    a=1;
    % If match found partial continues
    if ipeak_match > 0
        
        % Current peak matches with IPEAK_MATCH
        aux_peaks_curr(ipeak_curr) = ipeak_match;
        
        % IPEAK_MATCH for next frame matches with current peak
        aux_peaks_next(ipeak_match) = ipeak_curr;
        
        % Update LAST_MATCHED
        last_matched = ipeak_match;
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3: FINAL MATCH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of peaks
npartial = npeak_next + length(aux_peaks_curr(aux_peaks_curr==0));

% Set index of current peak
ipeak_curr = 1;

% Set index of next peak
ipeak_next = 1;

% Set index of partial
ipartial = 1;

% Initialize variables
new_amp_curr = zeros(npartial,1);
new_amp_next = zeros(npartial,1);
new_freq_curr = zeros(npartial,1);
new_freq_next = zeros(npartial,1);
new_phase_curr = zeros(npartial,1);
new_phase_next = zeros(npartial,1);

% Keep track of match, birth, and death
% track = cell(npartial,1);

a=1;

while ipartial < npartial
    
    % fprintf('ipeaker is %f\n\n',ipartial)
    
    if ipeak_curr <= npeak_curr && ipeak_next <= npeak_next && aux_peaks_curr(ipeak_curr) == 0 && aux_peaks_next(ipeak_next) == 0 % Both match to zero
        
        % fprintf('Both match to zero\n\n')
        
        if freq_curr(ipeak_curr) <= freq_next(ipeak_next) % Left frequency is smaller => Death CURR
            
            % fprintf('Left frequency is smaller => Death current\n\n')
            
            new_amp_curr(ipartial) = amp_curr(ipeak_curr);
            new_amp_next(ipartial) = 0;
            new_phase_curr(ipartial) = phase_curr(ipeak_curr);
            new_phase_next(ipartial) = phase_curr(ipeak_curr) + 2*pi*freq_curr(ipeak_curr)*hopsize/sr;
            new_freq_curr(ipartial) = freq_curr(ipeak_curr);
            new_freq_next(ipartial) = freq_curr(ipeak_curr);
            
            % Update current peak
            ipeak_curr = ipeak_curr + 1;
            
            % Update partial
            ipartial = ipartial + 1;
            
            % fprintf('Current is %d and Next is %d\n\n',ipeak_curr,ipeak_next)
            % a=1;
            
        else % Right frequency is smaller => Death CURR & Birth NEXT
            
            % fprintf('Left frequency is smaller => Death current\n\n')
            
            new_amp_curr(ipartial) = amp_curr(ipeak_curr);
            new_amp_next(ipartial) = 0;
            new_phase_curr(ipartial) = phase_curr(ipeak_curr);
            new_phase_next(ipartial) = phase_curr(ipeak_curr) + 2*pi*freq_curr(ipeak_curr)*hopsize/sr;
            new_freq_curr(ipartial) = freq_curr(ipeak_curr);
            new_freq_next(ipartial) = freq_curr(ipeak_curr);
            
            % Update current peak
            ipeak_curr = ipeak_curr + 1;
            
            % Update partial
            ipartial = ipartial + 1;
            
            % fprintf('Right frequency is smaller => Birth next\n\n')
            
            new_amp_curr(ipartial) = 0;
            new_amp_next(ipartial) = amp_next(ipeak_next);
            new_phase_curr(ipartial) = phase_next(ipeak_next) - 2*pi*freq_next(ipeak_next)*hopsize/sr;
            new_phase_next(ipartial) = phase_next(ipeak_next);
            new_freq_curr(ipartial) = freq_next(ipeak_next);
            new_freq_next(ipartial) = freq_next(ipeak_next);
            
            % Update next peak
            ipeak_next = ipeak_next + 1;
            
            % Update partial
            ipartial = ipartial + 1;
            
            % fprintf('Current is %d and Next is %d\n\n',ipeak_curr,ipeak_next)
            % a=1;
            
        end
        
    elseif ipeak_curr <= npeak_curr && aux_peaks_curr(ipeak_curr) == 0 % Current matches to zero => Death CURR
        
        % fprintf('Current matches to zero => Death current\n\n')
        
        new_amp_curr(ipartial) = amp_curr(ipeak_curr);
        new_amp_next(ipartial) = 0;
        new_phase_curr(ipartial) = phase_curr(ipeak_curr);
        new_phase_next(ipartial) = phase_curr(ipeak_curr) + 2*pi*freq_curr(ipeak_curr)*hopsize/sr;
        new_freq_curr(ipartial) = freq_curr(ipeak_curr);
        new_freq_next(ipartial) = freq_curr(ipeak_curr);
        
        % Update current peak
        ipeak_curr = ipeak_curr + 1;
        
        % Update partial
        ipartial = ipartial + 1;
        
        % fprintf('Current is %d and Next is %d\n\n',ipeak_curr,ipeak_next)
        % a=1;
        
    elseif ipeak_next <= npeak_next && aux_peaks_next(ipeak_next) == 0 % Next matches to zero => Birth NEXT
        
        % fprintf('Next matches to zero => Birth next\n\n')
        
        new_amp_curr(ipartial) = 0;
        new_amp_next(ipartial) = amp_next(ipeak_next);
        new_phase_curr(ipartial) = phase_next(ipeak_next) - 2*pi*freq_next(ipeak_next)*hopsize/sr;
        new_phase_next(ipartial) = phase_next(ipeak_next);
        new_freq_curr(ipartial) = freq_next(ipeak_next);
        new_freq_next(ipartial) = freq_next(ipeak_next);
        
        % Update next peak
        ipeak_next = ipeak_next + 1;
        
        % Update partial
        ipartial = ipartial + 1;
        
        % fprintf('Current is %d and Next is %d\n\n',ipeak_curr,ipeak_next)
        % a=1;
        
    elseif ipeak_curr > npeak_curr && ipeak_next > npeak_next % Dealt with all matches
        
        % fprintf(1,'Done with all peaks => Break loop\n\n')
        
        break
        
    else % They match each other
        
        % fprintf('Neither matches to zero => They match each other\n\n')
        
        new_amp_curr(ipartial) = amp_curr(ipeak_curr);
        new_amp_next(ipartial) = amp_next(ipeak_next);
        new_phase_curr(ipartial) = phase_curr(ipeak_curr);
        new_phase_next(ipartial) = phase_next(ipeak_next);
        new_freq_curr(ipartial) = freq_curr(ipeak_curr);
        new_freq_next(ipartial) = freq_next(ipeak_next);
        
        % Update current peak
        ipeak_curr = ipeak_curr + 1;
        
        % Update next peak
        ipeak_next = ipeak_next + 1;
        
        % Update partial
        ipartial = ipartial + 1;
        % fprintf('Current is %f and Next is %f\n\n',ipeak_curr,ipeak_next)
        % a=1;
        
    end
    
    % fprintf('ipeaker Overflow at %f\n\n',ipartial)
    
end

% fprintf('Passed here\n')
% keyboard
a=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 4: CREATE PARTIAL TRACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

