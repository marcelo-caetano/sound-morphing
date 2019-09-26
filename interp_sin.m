function [interp_amp,interp_freq] = interp_sin(amp1,freq1,f01,ntrack1,amp2,freq2,f02,ntrack2,nframe,alpha)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
a=1;

ntrack = [ntrack1, ntrack2];

[~,indtrack] = sort(ntrack);

% NTRACK1 is smaller
if ntrack1 == ntrack(indtrack(1))
    
    % Fill 1 with NaN
    amp1(ntrack1+1:ntrack2,:) = nan(ntrack2-ntrack1,nframe);
    freq1(ntrack1+1:ntrack2,:) = nan(ntrack2-ntrack1,nframe);
    
else % NTRACK2 is smaller
    
    % Fill 2 with NaN
    amp2(ntrack2+1:ntrack1,:) = nan(ntrack1-ntrack2,nframe);
    freq2(ntrack2+1:ntrack1,:) = nan(ntrack1-ntrack2,nframe);
    
end

% Initialize interp with higher ntrack
interp_amp = nan(ntrack(indtrack(2)),nframe);
interp_freq = nan(ntrack(indtrack(2)),nframe);

for iframe = 1:nframe
    
    % Higher number of partials
    for itrack = 1:ntrack(indtrack(2))
        
        % Both have harmonics
        if not(isnan(freq1(itrack,iframe))) && not(isnan(freq2(itrack,iframe)))
            
            interp_amp(itrack,iframe) = (1-alpha)*amp1(itrack,iframe) + alpha*amp2(itrack,iframe);
%             interp_amp(itrack,iframe) = (1-alpha)*amp1(itrack,iframe)*10^(alpha*log10(amp2(itrack,iframe)/amp1(itrack,iframe)))...
%                 + alpha*amp2(itrack,iframe)*10^((1-alpha)*log10(amp1(itrack,iframe)/amp2(itrack,iframe)));
            
            %int_partials(i,2) = beta*(part_data{1}(i,2)*2^((1-beta)*log2(part_data{2}(i,2)/part_data{1}(i,2))))...
            % + (1-beta)*(part_data{2}(i,2)*2^(beta*log2(part_data{1}(i,2)/part_data{2}(i,2))));
            interp_freq(itrack,iframe) = (1-alpha)*freq1(itrack,iframe)*2^(alpha*log2(freq2(itrack,iframe)/freq1(itrack,iframe)))...
                + (1-alpha)*freq2(itrack,iframe)*2^(alpha*log2(freq1(itrack,iframe)/freq2(itrack,iframe)));
            
            % Only 1 has harmonic
        elseif not(isnan(freq1(itrack,iframe))) && isnan(freq2(itrack,iframe))
            
            % Interpolation reduces to that when A1 == A2
            interp_amp(itrack,iframe) = (1-alpha)*amp1(itrack,iframe);
            
            % interp_freq(itrack,iframe) = (1-alpha)*freq1(itrack,iframe) + alpha*itrack*f02;
            % part_data{1}(i,2)*2^((1-beta)*log2(f02/f01))
            interp_freq(itrack,iframe) = freq1(itrack,iframe)*2^((1-alpha)*log2((itrack*f02)/freq1(itrack,iframe)));
            
            % Only 2 has harmonic
        elseif isnan(freq1(itrack,iframe)) && not(isnan(freq2(itrack,iframe)))
            
            % Interpolation reduces to that when A1 == A2
            interp_amp(itrack,iframe) = alpha*amp2(itrack,iframe);
            
            % interp_freq(itrack,iframe) = (1-alpha)*itrack*f01 + alpha*freq2(itrack,iframe);
            interp_freq(itrack,iframe) = freq2(itrack,iframe)*2^(alpha*log2((itrack*f01)/freq2(itrack,iframe)));
            
        else
            
            interp_amp(itrack,iframe) = amp1(itrack,iframe);
            interp_freq(itrack,iframe) = freq1(itrack,iframe);
            
        end
        
    end
    
end

end