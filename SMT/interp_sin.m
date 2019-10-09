function [interp_amp,interp_freq] = interp_sin(ampS,freqS,f0S,ntrackS,ampT,freqT,f0T,ntrackT,nframe,alpha,ampFlag)
%INTERP_SIN Interpolate the sinusoidal parameters amplitude and frequency.
%   [A,F] = INTERPO_SIN(AMP_SOURCE,FREQ_SOURCE,F01,P1,A2,FREQ_TARGET,F02,
%   P2,F,ALPHA,AMPFLAG) interpolates the amplitudes AMP_SOURCE and A2 and
%   frequencies FREQ_SOURCE and FREQ_TARGET of two sets of parameters
%   resulting from the sinusoidal analysis of two sounds with
%   the function SINUSOIDAL_ANALYSIS. INTERP_SIN uses the number of
%   partials P1 and P2 and the fundamental frequencies F01 and F02 to
%   interpolate unmatched partials. F is the total number of frames and
%   ALPHA is the interpolation factor varying between 0 and 1. When ALPHA=0
%   M=S and when ALPHA=1 M=T. Intermediate values of ALPHA generate M
%   between S and T. AMPFLAG is a character string that sets the scale of
%   amplitude interpolation to either 'lin' for linear or 'log' for
%   logarithmic.
%
%   2019 M Caetano (SMT 0.1.1)

% Number of tracks for Source and Target
ntrack = [ntrackS, ntrackT];

% Sort NTRACK in ascending order
[~,indtrack] = sort(ntrack);

% NTRACK1 is smaller
if ntrackS == ntrack(indtrack(1))
    
    % Fill 1 with NaN
    ampS(ntrackS+1:ntrackT,:) = nan(ntrackT-ntrackS,nframe);
    freqS(ntrackS+1:ntrackT,:) = nan(ntrackT-ntrackS,nframe);
    
else % NTRACK2 is smaller
    
    % Fill 2 with NaN
    ampT(ntrackT+1:ntrackS,:) = nan(ntrackS-ntrackT,nframe);
    freqT(ntrackT+1:ntrackS,:) = nan(ntrackS-ntrackT,nframe);
    
end

% Initialize interp with higher ntrack
interp_amp = nan(ntrack(indtrack(2)),nframe);
interp_freq = nan(ntrack(indtrack(2)),nframe);

switch lower(ampFlag)
    
    case 'lin'
        
        ampinterp = @lininterp;
        
    case 'log'
        
        ampinterp = @dbinterp;
        
    otherwise
        
        ampinterp = @dbinterp;
        
end

% For each frame
for iframe = 1:nframe
    
    % Higher number of partials
    for itrack = 1:ntrack(indtrack(2))
        
        % Both have harmonics
        if not(isnan(freqS(itrack,iframe))) && not(isnan(freqT(itrack,iframe)))
            
            % Interpolate the frequencies in cents
            interp_freq(itrack,iframe) = centinterp(freqS(itrack,iframe),freqT(itrack,iframe),alpha);
            
            % Interpolate the amplitudes
            if ampS(itrack,iframe)~=0 && ampT(itrack,iframe)~=0
                % interp_amp(itrack,iframe) = lininterp(ampS(itrack,iframe),ampT(itrack,iframe),alpha);
                % interp_amp(itrack,iframe) = dbinterp(ampS(itrack,iframe),ampT(itrack,iframe),alpha,'target');
                interp_amp(itrack,iframe) = ampinterp(ampS(itrack,iframe),ampT(itrack,iframe),alpha,'target');
            else
                interp_amp(itrack,iframe) = 0;
            end
            
            % TARGET harmonic is missing
        elseif not(isnan(freqS(itrack,iframe))) && isnan(freqT(itrack,iframe))
            
            % Interpolate the frequencies in cents
            % FREQ_TARGET is missing (harmonic approximation)
            interp_freq(itrack,iframe) = centinterp(freqS(itrack,iframe),itrack*f0T,alpha);
            
            % Interpolate the amplitudes
            if ampS(itrack,iframe)~=0
                % interp_amp(itrack,iframe) = lininterp(ampS(itrack,iframe),0,alpha);
                % interp_amp(itrack,iframe) = dbinterp(ampS(itrack,iframe),eps(0),alpha,'target');
                interp_amp(itrack,iframe) = ampinterp(ampS(itrack,iframe),missamp(ampFlag),alpha,'target');
            else
                interp_amp(itrack,iframe) = 0;
            end
            
            % SOURCE harmonic is missing
        elseif isnan(freqS(itrack,iframe)) && not(isnan(freqT(itrack,iframe)))
            
            % Interpolate the frequencies in cents
            % FREQ_SOURCE is missing (harmonic approximation)
            interp_freq(itrack,iframe) = centinterp(itrack*f0S,freqT(itrack,iframe),alpha);
            
            % Interpolate the amplitudes
            if ampT(itrack,iframe)~=0
                % interp_amp(itrack,iframe) = lininterp(0,ampT(itrack,iframe),alpha);
                % interp_amp(itrack,iframe) = dbinterp(eps(0),ampT(itrack,iframe),alpha,'target');
                interp_amp(itrack,iframe) = ampinterp(missamp(ampFlag),ampT(itrack,iframe),alpha,'source');
            else
                interp_amp(itrack,iframe) = 0;
            end
            
        else
            
            interp_amp(itrack,iframe) = ampS(itrack,iframe);
            interp_freq(itrack,iframe) = freqS(itrack,iframe);
            % interp_amp(itrack,iframe) = 0;
            % interp_freq(itrack,iframe) = f0S;
            
        end
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NESTED FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Missing amplitude value
    function amp = missamp(ampFlag)
        
        switch lower(ampFlag)
            
            case 'lin'
                
                amp = 0;
                
            case 'log'
                
                amp = eps(0);
                
        end
        
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOCAL FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Linear interpolation
function [morph] = lininterp(source,target,intfactor,varargin)

morph = intfactor*target + (1-intfactor)*source;

end

% Interpolation in frequency cents
function [morph] = centinterp(source,target,intfactor)

morph = source*2^(intfactor*log2(target/source));

end

% Interpolation in decibels
function [morph] = dbinterp(source,target,alpha,missFlag)

switch lower(missFlag)
    
    case 'source'
        
        mult = target;
        fraction = source/target;
        intfactor = 1 - alpha;
        
    case 'target'
        
        mult = source;
        fraction = target/source;
        intfactor = alpha;
end

morph = mult*10^(intfactor*log10(fraction));

end