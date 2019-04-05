function [sinusoidal,partials,amplitudes,phases] = sinusoidal_resynthesis_OLA(amp,freq,phase,hopsize,winlen,sr,duration,wintype,center,cframe)

% hopsize = fix(winlen/8);


% Number of frames
nframe = length(cframe);

% % Initialize variables
% frames = zeros(winlen,nframe);
% partials = zeros(winlen,nframe);
% amplitudes = zeros(winlen,nframe);
% phases = zeros(winlen,nframe);

% Initialize variables
frames = zeros(winlen,nframe);
partials = cell(nframe,1);
amplitudes = cell(nframe,1);
phases = cell(nframe,1);

for iframe = 1:nframe
    
    % fprintf(1,'OLA synthesis frame %d of %d\n',iframe,nframe);
    
    [frames(:,iframe),partials{iframe},amplitudes{iframe},phases{iframe}] = stationary_synthesis(amp{iframe},freq{iframe},phase{iframe},winlen,sr,wintype,cframe(iframe));
    
end

% Overlap-add frames
[olasin] = ola(frames,duration,wintype,center,cframe);

% Scaling factor
sc = colasum(wintype)*(winlen/2)/hopsize;

% Scale OLA
sinusoidal = olasin/sc;

end