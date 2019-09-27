function [sinusoidal,partials,amplitudes,frequencies,new_amp,new_freq,new_phase] = sinusoidal_resynthesis_PI(amp,freq,ph,delta,hopsize,framesize,sr,nsample,cframe,cfwflag,maxnpeak,dispflag)
%SINUSOIDAL_RESYNTHESIS_PI Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number if input arguments
narginchk(11,12);

if nargin == 11
    
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
new_amp = cell(1,nframe);
new_freq = cell(1,nframe);
new_phase = cell(1,nframe);

% new_new_amp = cell(1,nframe);
% new_new_freq = cell(1,nframe);
% new_new_phase = cell(1,nframe);

% Preallocate
sinusoidal = zeros(nsample+2*shift,1);
partials = zeros(nsample+2*shift,maxnpeak);
amplitudes = zeros(nsample+2*shift,maxnpeak);
frequencies = zeros(nsample+2*shift,maxnpeak);

% partials = cell(nframe,1);
% amplitudes = cell(nframe,1);
% frequencies = cell(nframe,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SYNTHESIS BY PARAMETER INTERPOLATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iframe = 1:nframe-1
    
    if strcmpi(dispflag,'v')
        
        fprintf(1,'PI synthesis between frame %d and %d\n',iframe,iframe+1);
        
    end
    
    if iframe == 1 && cframe(iframe) > 1
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME-LHW(WINSIZE) TO CFRAME (LEFT HALF OF FIRST WINDOW)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Parameter interpolation & Additive resynthesis (with linear ph estimation)
        [sin_model,partial_model,amp_model,freq_model] = parameter_interpolation(amp{iframe},amp{iframe},freq{iframe},freq{iframe},ph{iframe}-(freq{iframe}*2*pi*lhw(framesize)/sr),ph{iframe},lhw(framesize),sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)-lhw(framesize)+shift:cframe(iframe)-1+shift) = sin_model;
        partials(cframe(iframe)-lhw(framesize)+shift:cframe(iframe)-1+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)-lhw(framesize)+shift:cframe(iframe)-1+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)-lhw(framesize)+shift:cframe(iframe)-1+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME TO CFRAME+HOPSIZE (RIGHT HALF OF FIRST WINDOW)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % [new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase{iframe},new_phase{iframe+1}] = peak_matching(amp{iframe},amp{iframe+1},freq{iframe},freq{iframe+1},ph{iframe},ph{iframe+1},delta,hopsize,sr);
        [new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase{iframe},new_phase{iframe+1}] = peak_matching_tracks(amp{iframe},amp{iframe+1},freq{iframe},freq{iframe+1},ph{iframe},ph{iframe+1},delta,hopsize,sr);
        
        % Parameter interpolation & Additive resynthesis
        [sin_model,partial_model,amp_model,freq_model] = parameter_interpolation(new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase{iframe},new_phase{iframe+1},hopsize,sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)+shift:cframe(iframe+1)-1+shift) = sin_model;
        partials(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)+shift:cframe(iframe+1)-1+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        
    elseif iframe == nframe-1 && cframe(iframe) < nsample
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME TO CFRAME+RHW(WINSIZE) (RIGHT HALF OF LAST WINDOW)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Parameter interpolation & Additive resynthesis (with linear ph estimation)
        [sin_model,partial_model,amp_model,freq_model] = parameter_interpolation(amp{iframe},amp{iframe},freq{iframe},freq{iframe},ph{iframe},ph{iframe}+(freq{iframe}*2*pi*(nsample-cframe(iframe)+1)/sr),nsample-cframe(iframe)+1,sr);
        
        % Concatenation into final synthesis vector
        sinusoidal(cframe(iframe)+shift:nsample+shift) = sin_model;
        partials(cframe(iframe)+shift:nsample+shift,1:size(partial_model,2)) = partial_model;
        amplitudes(cframe(iframe)+shift:nsample+shift,1:size(amp_model,2)) = amp_model;
        frequencies(cframe(iframe)+shift:nsample+shift,1:size(freq_model,2)) = freq_model/(2*pi);
        
    else
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FROM CFRAME TO CFRAME+HOPSIZE (BETWEEN CENTER OF CONSECUTIVE WINDOWS)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Peak matching
        % [new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase{iframe},new_phase{iframe+1}] = peak_matching(amp{iframe},amp{iframe+1},freq{iframe},freq{iframe+1},ph{iframe},ph{iframe+1},delta,hopsize,sr);
        [new_amp{iframe},new_amp{iframe+1},new_freq{iframe},new_freq{iframe+1},new_phase{iframe},new_phase{iframe+1}] = peak_matching_tracks(amp{iframe},amp{iframe+1},freq{iframe},freq{iframe+1},ph{iframe},ph{iframe+1},delta,hopsize,sr);
        
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
sinusoidal = sinusoidal(1+shift:nsample+shift);
partials = partials(1+shift:nsample+shift,:);
amplitudes = amplitudes(1+shift:nsample+shift,:);
frequencies = frequencies(1+shift:nsample+shift,:);

a = 1;

% % Remove extra partials
% partials = partials(partials~=0);
% amplitudes = amplitudes(amplitudes~=0);
% frequencies = frequencies(frequencies~=0);

end