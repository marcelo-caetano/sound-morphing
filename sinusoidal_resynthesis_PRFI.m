function [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis_PRFI(amp,freq,delta,hopsize,framesize,sr,nsample,cframe,cfwflag,maxnpeak,dispflag)
%SINUSOIDAL_RESYNTHESIS_PI Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number if input arguments
narginchk(10,11);

if nargin == 10
    
    dispflag = 's';
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nframe = length(cframe);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ZERO-PADDING AT THE BEGINNING AND END OF SIGNAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(cfwflag)
    
    case 'one'
        
        % SHIFT is the number of zeros before CW
        shift = lhw(framesize);
        
    case 'half'
        
        % SHIFT is the number of zeros before CW
        shift = 0;
        
    case 'nhalf'
        
        % SHIFT is the number of zeros before CW
        shift = framesize;
        
    otherwise
        
        warning(['InvalidFlag: Undefined window flag.\n'...
            'Flag that specifies the cfwflag of the first analysis window\n'...
            'must be ONE, HALF, or NHALF. Using default value ONE']);
        
        % SHIFT is the number of zeros before CW
        shift = lhw(framesize);
end

% Preallocate for NFRAME
new_amp = cell(nframe,1);
new_freq = cell(nframe,1);
phase_prev = cell(nframe,1);
new_phase_prev = cell(nframe,1);

% Preallocate
sinusoidal = zeros(nsample+2*shift,1);
partials = zeros(nsample+2*shift,maxnpeak);
amplitudes = zeros(nsample+2*shift,maxnpeak);
frequencies = zeros(nsample+2*shift,maxnpeak);
phases = zeros(nsample+2*shift,maxnpeak);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADDITIVE RESYNTHESIS WITHOUT PHASE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iframe = 1:nframe-1
    
    if strcmpi(dispflag,'v')
        
        fprintf(1,'ADD synthesis between frame %d and %d\n',iframe,iframe+1);
        
    end
    
    if iframe == 1 && cframe(iframe) > 1 % FIRST FRAME & CFLAG == HALF
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME-LHW(WINSIZE) TO CFRAME (LEFT HALF OF FIRST WINDOW)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % When FREQUENCY_INTEGRATION uses COS for resynthesis
        % phase_prev{iframe} = -pi/2*ones(size(amp{iframe}));
        
        % When FREQUENCY_INTEGRATION uses SIN for resynthesis
        phase_prev{iframe} = zeros(size(amp{iframe}));
        
        % Parameter interpolation & Additive resynthesis (with linear phase estimation)
        [sin_model,phase,partial_model,amp_model,freq_model] = frequency_integration(zeros(size(amp{iframe})),amp{iframe},freq{iframe},freq{iframe},phase_prev{iframe},lhw(framesize),sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)-lhw(framesize)+shift:cframe(iframe)-1+shift) = sin_model;
        partials(cframe(iframe)-lhw(framesize)+shift:cframe(iframe)-1+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)-lhw(framesize)+shift:cframe(iframe)-1+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)-lhw(framesize)+shift:cframe(iframe)-1+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        phases(cframe(iframe)-lhw(framesize)+shift:cframe(iframe)-1+shift,1:size(phase,2)) = phase;
        
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
        
        
    elseif iframe == nframe-1 && cframe(iframe) < nsample % LAST FRAME & CFLAG ~= NHALF
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME TO CFRAME+RHW(WINSIZE) (RIGHT HALF OF LAST WINDOW)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % phase_prev{iframe} = kt(ismember(new_freq{iframe},freq{iframe}));
        phase_prev{iframe} = phase(end,ismember(new_freq{iframe},freq{iframe}));
        
        
        % Parameter interpolation & Additive resynthesis (with linear phase estimation)
        [sin_model,phase,partial_model,amp_model,freq_model] = frequency_integration(amp{iframe},amp{iframe},freq{iframe},freq{iframe},phase_prev{iframe},nsample-cframe(iframe)+1,sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)+shift:nsample+shift) = sin_model;
        partials(cframe(iframe)+shift:nsample+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)+shift:nsample+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)+shift:nsample+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        phases(cframe(iframe)+shift:nsample+shift,1:size(phase,2)) = phase;
        
        
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
sinusoidal = sinusoidal(1+shift:nsample+shift);
partials = partials(1+shift:nsample+shift,:);
amplitudes = amplitudes(1+shift:nsample+shift,:);
frequencies = frequencies(1+shift:nsample+shift,:);

end