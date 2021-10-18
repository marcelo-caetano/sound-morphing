function [sinusoidal,partial,amplitude,frequency,phase] = sinusoidal_resynthesis_OLA(amp,freq,ph,framelen,hop,fs,nsample,center_frame,...
    npartial,nframe,winflag,causalflag,dispflag)
%SINUSOIDAL_RESYNTHESIS_OLA Overlap-add resynthesis for sinusoidal analysis.
%   [SIN,PART,AMP,FREQ,PH] = SINUSOIDAL_RESYNTHESIS_OLA(A,F,P,M,H,Fs,NSAMPLE,CFR,WINFLAG,CAUSALFLAG,DISPFLAG)
%   resynthesizes the frames resulting from the sinusoidal analysis via
%   overlap-add and returns the result in SIN. PART has the partials, AMP
%   has the amplitudes, FREQ has the frequencies, and PH has the phases of
%   the partials individually.
%
%   See also SINUSOIDAL_RESYNTHESIS_PI, SINUSOIDAL_RESYNTHESIS_PRFI

% 2016 M Caetano;
% Revised 2019 SMT 0.1.1
% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number if input arguments
narginchk(12,13);

% Check number if output arguments
nargoutchk(0,5);

if nargin == 12
    
    dispflag = false;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize variables
time_frame = zeros(framelen,nframe);
partial_frame = zeros(framelen,nframe,npartial);
amplitude_frame = zeros(framelen,nframe,npartial);
frequency_frame = zeros(framelen,nframe,npartial);
phase_frame = zeros(framelen,nframe,npartial);

for iframe = 1:nframe
    
    if dispflag
        
        fprintf(1,'OLA synthesis frame %d of %d\n',iframe,nframe);
        
    end
    
    % Stationary synthesis inside each frame
    [amplitude_frame(:,iframe,:),frequency_frame(:,iframe,:),phase_frame(:,iframe,:),synthwin] = stationary_synthesis(amp(:,iframe),freq(:,iframe),ph(:,iframe),framelen,fs,center_frame(iframe),winflag);
    
    % OLA resynthesis
    [time_frame(:,iframe),partial_frame(:,iframe,:)] = OLA_resynthesis(squeeze(amplitude_frame(:,iframe,:)),squeeze(phase_frame(:,iframe,:)),synthwin);
    
end

% OLA scaling factor
sc = tools.ola.colasum(winflag)*(framelen/2)/hop;

% Overlap-add time_frame
sinusoidal = ola(time_frame,framelen,hop,nsample,center_frame,nframe,winflag,causalflag)/sc;

% Overlap-add partials
partial = ola(partial_frame,framelen,hop,nsample,center_frame,nframe,winflag,causalflag)/sc;

% Overlap-add amplitude
amplitude = ola(amplitude_frame,framelen,hop,nsample,center_frame,nframe,winflag,causalflag)/sc;

% Overlap-add frequency
frequency = ola(amplitude_frame,framelen,hop,nsample,center_frame,nframe,winflag,causalflag)/sc;

% Overlap-add phase
phase = ola(amplitude_frame,framelen,hop,nsample,center_frame,nframe,winflag,causalflag)/sc;

end
