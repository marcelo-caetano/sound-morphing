function [sinusoidal,partials,amplitudes,frequencies,new_amp,new_freq,new_phase] = sinusoidal_resynthesis_PI_test(amp,freq,phase,delta,cframe,hopsize,winlen,sr,duration,cflag,maxnpeak)
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
new_amp = cell(1,nframe);
new_freq = cell(1,nframe);
new_phase = cell(1,nframe);

% new_new_amp = cell(1,nframe);
% new_new_freq = cell(1,nframe);
% new_new_phase = cell(1,nframe);

% Preallocate
sinusoidal = zeros(duration+2*shift,1);
partials = zeros(duration+2*shift,maxnpeak);
amplitudes = zeros(duration+2*shift,maxnpeak);
frequencies = zeros(duration+2*shift,maxnpeak);

% partials = cell(nframe,1);
% amplitudes = cell(nframe,1);
% frequencies = cell(nframe,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SYNTHESIS BY PARAMETER INTERPOLATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iframe = 1:nframe-1
    
    % fprintf(1,'PI synthesis frame %d of %d\n',iframe,nframe);
    
    if iframe == 1 && cframe(iframe) > 1
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME-LHW(WINSIZE) TO CFRAME (LEFT HALF OF FIRST WINDOW)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Parameter interpolation & Additive resynthesis (with linear phase estimation)
        [sin_model,partial_model,amp_model,freq_model] = parameter_interpolation(amp{iframe},amp{iframe},freq{iframe},freq{iframe},phase{iframe}-(freq{iframe}*2*pi*lhw(winlen)/sr),phase{iframe},lhw(winlen),sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)-lhw(winlen)+shift:cframe(iframe)-1+shift) = sin_model;
        partials(cframe(iframe)-lhw(winlen)+shift:cframe(iframe)-1+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)-lhw(winlen)+shift:cframe(iframe)-1+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)-lhw(winlen)+shift:cframe(iframe)-1+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME TO CFRAME+HOPSIZE (RIGHT HALF OF FIRST WINDOW)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % [new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase{iframe},new_phase{iframe+1}] = peak_matching(amp{iframe},amp{iframe+1},freq{iframe},freq{iframe+1},phase{iframe},phase{iframe+1},delta,hopsize,sr);
        [new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase{iframe},new_phase{iframe+1}] = peak_matching_tracks(amp{iframe},amp{iframe+1},freq{iframe},freq{iframe+1},phase{iframe},phase{iframe+1},delta,hopsize,sr);        
        
        % Parameter interpolation & Additive resynthesis
        [sin_model,partial_model,amp_model,freq_model] = parameter_interpolation(new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase{iframe},new_phase{iframe+1},hopsize,sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)+shift:cframe(iframe+1)-1+shift) = sin_model;
        partials(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        
    elseif iframe == nframe-1 && cframe(iframe) < duration
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME TO CFRAME+RHW(WINSIZE) (RIGHT HALF OF LAST WINDOW)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Parameter interpolation & Additive resynthesis (with linear phase estimation)
        [sin_model,partial_model,amp_model,freq_model] = parameter_interpolation(amp{iframe},amp{iframe},freq{iframe},freq{iframe},phase{iframe},phase{iframe}+(freq{iframe}*2*pi*(duration-cframe(iframe)+1)/sr),duration-cframe(iframe)+1,sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)+shift:duration+shift) = sin_model;
        partials(cframe(iframe)+shift:duration+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)+shift:duration+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)+shift:duration+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        
    else
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME TO CFRAME+HOPSIZE (BETWEEN CENTER OF CONSECUTIVE WINDOWS)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Peak matching
        % [new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase{iframe},new_phase{iframe+1}] = peak_matching(amp{iframe},amp{iframe+1},freq{iframe},freq{iframe+1},phase{iframe},phase{iframe+1},delta,hopsize,sr);
        [new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase{iframe},new_phase{iframe+1}] = peak_matching_tracks(amp{iframe},amp{iframe+1},freq{iframe},freq{iframe+1},phase{iframe},phase{iframe+1},delta,hopsize,sr);        
        
        % Parameter interpolation & Additive resynthesis
        [sin_model,partial_model,amp_model,freq_model] = parameter_interpolation(new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase{iframe},new_phase{iframe+1},hopsize,sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)+shift:cframe(iframe+1)-1+shift) = sin_model;
        partials(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        
    end
    
end

% Remove zero-padding
sinusoidal = sinusoidal(1+shift:duration+shift);
partials = partials(1+shift:duration+shift,:);
amplitudes = amplitudes(1+shift:duration+shift,:);
frequencies = frequencies(1+shift:duration+shift,:);

a = 1;

% % Remove extra partials
% partials = partials(partials~=0);
% amplitudes = amplitudes(amplitudes~=0);
% frequencies = frequencies(frequencies~=0);

end