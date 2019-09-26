function [amp,freq,phase] = sinusoidal_analysis_frame(mag_spec,phase_spec,nfft,fs,maxnpeak,magflag,p)
%SINUSOIDAL_ANALYSIS_FRAME Summary of this function goes here
%   Detailed explanation goes here

% Peak picking
index_peaks = peak_picking(mag_spec);

% freqs = genfreq(nfft,fs,'pos',true);
% figure(1)
% plot(freqs,mag_spec)
% hold on
% stem(freqs(index_peaks),mag_spec(index_peaks))
% hold off

% Bin number
binind = genfreq(nfft,fs,'pos',false);

% Bin frequency
binfreq = genfreq(nfft,fs,'pos',true);


if any(index_peaks)
    
    % peaks = find(index_peaks);
    peaks = binind(index_peaks) + 1;
    
    npeak = length(peaks);
    
    peak_amp = zeros(npeak,1);
    % peak_bin = zeros(npeak,1);
    peak_freq = zeros(npeak,1);
    peak_phase = zeros(npeak,1);
    
    for ipeak = 1:npeak
        
        % Nearest Neighbor
        if strcmpi(magflag,'nne')
            
            peak_freq(ipeak) = binfreq(peaks(ipeak));
            
            peak_amp(ipeak) = mag_spec(peaks(ipeak));
            
            peak_phase(ipeak) = phase_spec(peaks(ipeak));
            
        % Quadratic interpolation
        else
            % fprintf(1,'Peak number %d\n',ipeak);
            
            %Quad interp peak_freq (Hz) peak_amp (dB)
            [peak_freq(ipeak),peak_amp(ipeak)] = quad_interp(binfreq(peaks(ipeak)-1:peaks(ipeak)+1),mag_spec(peaks(ipeak)-1:peaks(ipeak)+1));
            
            % Quadratic interpolation using bin number
            % [peak_bin(ipeak),peak_amp(ipeak)] = quad_interp(binind(peaks(ipeak)-1:peaks(ipeak)+1),mag_spec(peaks(ipeak)-1:peaks(ipeak)+1));
            
            % From bin number to bin frequency
            % peak_freq(ipeak) = bin2freq(peak_bin(ipeak),fs,nfft);
            
            % Unscale the magnitude spectrum
            [peak_amp(ipeak)] = unscale_magspec(peak_amp(ipeak),p,magflag);
            
            % Phase interp peak_phase (Rad)
            peak_phase(ipeak) = phase_interp(binfreq(peaks(ipeak)-1:peaks(ipeak)+1),phase_spec(peaks(ipeak)-1:peaks(ipeak)+1),peak_freq(ipeak));
            
            % Phase interpolation
            % peak_phase(ipeak) = phase_interp(bin2freq(freqbin(peaks(ipeak)-1:peaks(ipeak)+1),fs,nfft),phase_spec(peaks(ipeak)-1:peaks(ipeak)+1),peak_freq(ipeak));
            
        end
        
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
    
    amp = 0;
    freq = 0;
    phase = 0;
    
end

end