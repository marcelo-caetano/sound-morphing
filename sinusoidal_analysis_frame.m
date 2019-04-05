function [amp,freq,phase] = sinusoidal_analysis_frame(mag_spec,phase_spec,freqs,winlen,wintype,maxnpeak,magflag,p)
%SINUSOIDAL_ANALYSIS_FRAME Summary of this function goes here
%   Detailed explanation goes here

% Peak picking
index_peaks = peak_picking(mag_spec);

% figure(1)
% plot(freqs,mag_spec)
% hold on
% stem(freqs(index_peaks),mag_spec(index_peaks))
% hold off

if any(index_peaks)
    
    peaks = find(index_peaks);
    
    npeak = length(peaks);
    
    peak_amp = zeros(npeak,1);
    peak_freq = zeros(npeak,1);
    peak_phase = zeros(npeak,1);
    
    for ipeak = 1:npeak
        
        % fprintf(1,'Peak number %d\n',ipeak);
        
        %Quad interp peak_freq (Hz) peak_amp (dB)
        [peak_freq(ipeak),peak_amp(ipeak)] = quad_interp(freqs(peaks(ipeak)-1:peaks(ipeak)+1),mag_spec(peaks(ipeak)-1:peaks(ipeak)+1));
        
        % Unscale the magnitude spectrum
        switch lower(magflag)
            
            case 'log'
                
                % peak_amp(ipeak) = 10^(peak_amp(ipeak)/10);
                peak_amp(ipeak) = 10^(peak_amp(ipeak)/20);
                
            case 'lin'
                
                % peak_amp(ipeak) = peak_amp(ipeak);
                % No need to do anything
                
            case 'pow'
                
                % p = xqifft(winlen,wintype);
                peak_amp(ipeak) = nthroot(peak_amp(ipeak),p);
                
            otherwise
                
                warning(['InvalidMagFlag: Invalid Magnitude Scaling Flag.\n'...
                    'Flag for magnitude scaling must be LOG, LIN, or POW.\n'...
                    'Using default magnitude scaling flag LOG'])
                
                peak_amp(ipeak) = 10^(peak_amp(ipeak)/20);
                
        end
        
        % Phase interp peak_phase (Rad)
        peak_phase(ipeak) = phase_interp(freqs(peaks(ipeak)-1:peaks(ipeak)+1),phase_spec(peaks(ipeak)-1:peaks(ipeak)+1),peak_freq(ipeak));
        
    end
    
    % Return only the MAXNPEAK highest amplitude peaks in MAG_SPEC
    [amp_sorted,amp_index] = sort(peak_amp,'descend');
    
    % Truncate to MAXNPEAK
    if length(amp_index) > maxnpeak
        amp_index = amp_index(1:maxnpeak);
    end
    
    % Recover original positions (ascending frequency)
    amp_index = sort(amp_index);
    
    % Return MAXNPEAK in ascending frequency
    amp = peak_amp(amp_index);
    phase = peak_phase(amp_index);
    freq = peak_freq(amp_index);
    
else
    
    %     amp = nan(1);
    %     freq = nan(1);
    %     phase = nan(1);
    
    amp = 0;
    freq = 0;
    phase = 0;
    
end

end