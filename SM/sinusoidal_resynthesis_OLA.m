function [sinusoidal,partials,amplitudes,phases] = sinusoidal_resynthesis_OLA...
    (amp,freq,phase,hopsize,framesize,wintype,fs,nsample,cframe,cfwflag,dispflag)
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

% Number of frames
nframe = length(cframe);

% Initialize variables
frames = zeros(framesize,nframe);
partials = cell(nframe,1);
amplitudes = cell(nframe,1);
phases = cell(nframe,1);

for iframe = 1:nframe
    
    if strcmpi(dispflag,'v')
        
        fprintf(1,'OLA synthesis frame %d of %d\n',iframe,nframe);
        
    end
    
    [frames(:,iframe),partials{iframe},amplitudes{iframe},phases{iframe}] = ...
        stationary_synthesis(amp{iframe},freq{iframe},phase{iframe},framesize,fs,wintype,cframe(iframe));
    
end

% Overlap-add frames
[olasin] = ola(frames,nsample,wintype,cfwflag,cframe);

% Scaling factor
sc = colasum(wintype)*(framesize/2)/hopsize;

% Scale OLA
sinusoidal = olasin/sc;

% Get frequencies as derivative of phases
% frequencies = gradient(phases);

end