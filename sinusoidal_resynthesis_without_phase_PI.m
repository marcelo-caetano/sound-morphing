function [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis_without_phase_PI(amp,freq,delta,cframe,hopsize,winlen,sr,duration,cflag,maxnpeak)
%SINUSOIDAL_RESYNTHESIS_PI Summary of this function goes here
%   Detailed explanation goes here

nframe = length(cframe);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ZERO-PADDING AT THE BEGINNING AND END OF SIGNAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(cflag)
    
    case 'one'
        
        % SHIFT is the number of zeros before CW
        shift = lhw(winlen);
        
    case 'half'
        
        % SHIFT is the number of zeros before CW
        shift = 0;
        
    case 'nhalf'
        
        % SHIFT is the number of zeros before CW
        shift = winlen;
        
    otherwise
        
        warning(['InvalidFlag: Undefined window flag.\n'...
            'Flag that specifies the cflag of the first analysis window\n'...
            'must be ONE, HALF, or NHALF. Using default value ONE']);
        
        % SHIFT is the number of zeros before CW
        shift = lhw(winlen);
end

% Preallocate for NFRAME
new_amp = cell(nframe,1);
new_freq = cell(nframe,1);
phase_prev = cell(nframe,1);
new_phase_prev = cell(nframe,1);

% Preallocate
sinusoidal = zeros(duration+2*shift,1);
partials = zeros(duration+2*shift,maxnpeak);
amplitudes = zeros(duration+2*shift,maxnpeak);
frequencies = zeros(duration+2*shift,maxnpeak);
phases = zeros(duration+2*shift,maxnpeak);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADDITIVE RESYNTHESIS WITHOUT PHASE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iframe = 1:nframe-1
    
    fprintf(1,'ADD synthesis frame %d of %d\n',iframe,nframe);
    
    if iframe == 1 && cframe(iframe) > 1 % FIRST FRAME & CFLAG == HALF
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME-LHW(WINSIZE) TO CFRAME (LEFT HALF OF FIRST WINDOW)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % When FREQUENCY_INTEGRATION uses COS for resynthesis
        % phase_prev{iframe} = -pi/2*ones(size(amp{iframe}));
        
        % When FREQUENCY_INTEGRATION uses SIN for resynthesis
        phase_prev{iframe} = zeros(size(amp{iframe}));
        
        % Parameter interpolation & Additive resynthesis (with linear phase estimation)
        [sin_model,phase,partial_model,amp_model,freq_model] = frequency_integration(zeros(size(amp{iframe})),amp{iframe},freq{iframe},freq{iframe},phase_prev{iframe},lhw(winlen),sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)-lhw(winlen)+shift:cframe(iframe)-1+shift) = sin_model;
        partials(cframe(iframe)-lhw(winlen)+shift:cframe(iframe)-1+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)-lhw(winlen)+shift:cframe(iframe)-1+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)-lhw(winlen)+shift:cframe(iframe)-1+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        phases(cframe(iframe)-lhw(winlen)+shift:cframe(iframe)-1+shift,1:size(phase,2)) = phase;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME TO CFRAME+HOPSIZE (RIGHT HALF OF FIRST WINDOW)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
        % Peak matching
        [new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase_prev{iframe}] = peak_matching_withoutphase(amp{iframe},amp{iframe+1},freq{iframe},freq{iframe+1},phase_prev{iframe},delta);
                
        % Parameter interpolation & Additive resynthesis
        [sin_model,phase,partial_model,amp_model,freq_model] = frequency_integration(new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase_prev{iframe},hopsize,sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)+shift:cframe(iframe+1)-1+shift) = sin_model;
        partials(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        phases(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(phase,2)) = phase;
        
        
    elseif iframe == nframe-1 && cframe(iframe) < duration % LAST FRAME & CFLAG ~= NHALF
                
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME TO CFRAME+RHW(WINSIZE) (RIGHT HALF OF LAST WINDOW)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % phase_prev{iframe} = kt(ismember(new_freq{iframe},freq{iframe}));
        phase_prev{iframe} = phase(end,ismember(new_freq{iframe},freq{iframe}));
        
        
        % Parameter interpolation & Additive resynthesis (with linear phase estimation)
        [sin_model,phase,partial_model,amp_model,freq_model] = frequency_integration(amp{iframe},amp{iframe},freq{iframe},freq{iframe},phase_prev{iframe},duration-cframe(iframe)+1,sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)+shift:duration+shift) = sin_model;
        partials(cframe(iframe)+shift:duration+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)+shift:duration+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)+shift:duration+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        phases(cframe(iframe)+shift:duration+shift,1:size(phase,2)) = phase;
        
        
    else
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME TO CFRAME+HOPSIZE (BETWEEN CENTER OF CONSECUTIVE WINDOWS)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if iframe == 1
            
            phase_prev{iframe} = zeros(size(amp{iframe}));
            
        else
                        
            phase_prev{iframe} = phase(end,ismember(new_freq{iframe},freq{iframe}));
                        
        end
                
        % Peak matching
        [new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase_prev{iframe}] = peak_matching_withoutphase(amp{iframe},amp{iframe+1},freq{iframe},freq{iframe+1},phase_prev{iframe},delta);
        
        % Parameter interpolation & Additive resynthesis
        [sin_model,phase,partial_model,amp_model,freq_model] = frequency_integration(new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase_prev{iframe},hopsize,sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)+shift:cframe(iframe+1)-1+shift) = sin_model;
        partials(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        phases(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(phase,2)) = phase;
        
    end
    
end

% Remove zero-padding
sinusoidal = sinusoidal(1+shift:duration+shift);
partials = partials(1+shift:duration+shift,:);
amplitudes = amplitudes(1+shift:duration+shift,:);
frequencies = frequencies(1+shift:duration+shift,:);

end