function [interp_amp,interp_freq] = interp_sin(amp_source,freq_source,f0_source,npartial_source,...
    amp_target,freq_target,f0_target,npartial_target,nframe,alpha,interpflag,nanflag)
%INTERP_SIN Interpolate the sinusoidal parameters amplitude and frequency.
%   [A,F] = INTERP_SIN(AMP_S,FREQ_S,F0_S,NPART_S,AMP_T,FREQ_T,F0_T,
%   NPART_T,NFRAME,ALPHA,INTERPFLAG,NANFLAG) interpolates the amplitudes
%   AMP_S and AMP_T and the frequencies FREQ_S and FREQ_T of two sets of
%   parameters resulting from the sinusoidal analysis of two sounds with
%   the function SINUSOIDAL_ANALYSIS. INTERP_SIN uses the number of
%   partials P1 and P2 and the fundamental frequencies F01 and F02 to
%   interpolate unmatched partials. F is the total number of frames and
%   ALPHA is the interpolation factor varying between 0 and 1. When ALPHA=0
%   M=S and when ALPHA=1 M=T. Intermediate values of ALPHA generate M
%   between S and T. AMPFLAG is a character string that sets the scale of
%   amplitude interpolation to either 'lin' for linear or 'log' for
%   logarithmic.

% 2019 M Caetano (SMT 0.0.1)
% 2020 MCaetano SMT 0.1.1
% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% Check number of input arguments
narginchk(10,12);

% Check number of output arguments
nargoutchk(0,2);

if nargin == 10
    
    interpflag = 'log';
    
    nanflag = false;
    
elseif nargin == 11
    
    nanflag = false;
    
    
end

% Number of partials for Source and Target
ntrack = [npartial_source, npartial_target];

% Sort NTRACK in ascending order
[~,indtrack] = sort(ntrack);

% NTRACK1 is smaller
if npartial_source == ntrack(indtrack(1))
    
    % Fill 1 with NaN
    amp_source(npartial_source+1:npartial_target,:) = nan(npartial_target-npartial_source,nframe);
    freq_source(npartial_source+1:npartial_target,:) = nan(npartial_target-npartial_source,nframe);
    
else % NTRACK2 is smaller
    
    % Fill 2 with NaN
    amp_target(npartial_target+1:npartial_source,:) = nan(npartial_source-npartial_target,nframe);
    freq_target(npartial_target+1:npartial_source,:) = nan(npartial_source-npartial_target,nframe);
    
end

% Initialize interp with higher ntrack
interp_amp = nan(ntrack(indtrack(2)),nframe);
interp_freq = nan(ntrack(indtrack(2)),nframe);

% Choose amplitude interpolation function
switch lower(interpflag)
    
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
        if not(isnan(freq_source(itrack,iframe))) && not(isnan(freq_target(itrack,iframe)))
            
            % Interpolate the frequencies in cents
            interp_freq(itrack,iframe) = centinterp(freq_source(itrack,iframe),freq_target(itrack,iframe),alpha);
            
            % Interpolate the amplitudes
            if amp_source(itrack,iframe)~=0 && amp_target(itrack,iframe)~=0
                
                interp_amp(itrack,iframe) = ampinterp(amp_source(itrack,iframe),amp_target(itrack,iframe),alpha,'target');
                
            else
                
                interp_amp(itrack,iframe) = 0;
                
            end
            
            % TARGET harmonic is missing
        elseif not(isnan(freq_source(itrack,iframe))) && isnan(freq_target(itrack,iframe))
            
            % Interpolate the frequencies in cents
            % FREQ_TARGET is missing (harmonic approximation)
            interp_freq(itrack,iframe) = centinterp(freq_source(itrack,iframe),itrack*f0_target,alpha);
            
            % Interpolate the amplitudes
            if amp_source(itrack,iframe)~=0
                
                interp_amp(itrack,iframe) = ampinterp(amp_source(itrack,iframe),missamp(interpflag,nanflag),alpha,'target');
                
            else
                
                interp_amp(itrack,iframe) = 0;
                
            end
            
            % SOURCE harmonic is missing
        elseif isnan(freq_source(itrack,iframe)) && not(isnan(freq_target(itrack,iframe)))
            
            % Interpolate the frequencies in cents
            % FREQ_SOURCE is missing (harmonic approximation)
            interp_freq(itrack,iframe) = centinterp(itrack*f0_source,freq_target(itrack,iframe),alpha);
            
            % Interpolate the amplitudes
            if amp_target(itrack,iframe)~=0
                
                interp_amp(itrack,iframe) = ampinterp(missamp(interpflag,nanflag),amp_target(itrack,iframe),alpha,'source');
                
            else
                
                interp_amp(itrack,iframe) = 0;
                
            end
            
        else
            
            % Both are NaN (not synthesized)
            interp_amp(itrack,iframe) = amp_source(itrack,iframe);
            interp_freq(itrack,iframe) = freq_source(itrack,iframe);
            
        end
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NESTED FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Missing amplitude value
    function amp = missamp(interpflag,nanflag)
        
        if nanflag
            
            logamp = eps(0);
            
        else
            
            logamp = 0;
            
        end
        
        switch lower(interpflag)
            
            case 'lin'
                
                amp = 0;
                
            case 'log'
                
                amp = logamp;
                
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
