function [sinusoidal,partial,amplitude,frequency,phase] = sinusoidal_resynthesis_OLA(amp,freq,ph,framelen,hop,fs,winflag,...
    nsample,center_frame,npartial,nframe,nchannel,causalflag,dispflag)
%SINUSOIDAL_RESYNTHESIS_OLA Overlap-add resynthesis for sinusoidal analysis.
%   [SIN,PART,AMP,FREQ,PH] = SINUSOIDAL_RESYNTHESIS_OLA(A,F,P,M,H,Fs,WINFLAG,NSAMPLE,CFR,NPART,NFR,NCH,CAUSALFLAG,DISPFLAG)
%   resynthesizes the frames resulting from the sinusoidal analysis via
%   overlap-add and returns the result in SIN. PART has the partials, AMP
%   has the amplitudes, FREQ has the frequencies, and PH has the phases of
%   the partials individually.
%
%   See also SINUSOIDAL_RESYNTHESIS_PI, SINUSOIDAL_RESYNTHESIS_PRFI

% 2016 M Caetano;
% Revised 2019 SMT 0.1.1
% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number if input arguments
narginchk(13,14);

% Check number if output arguments
nargoutchk(0,5);

if nargin == 13
    
    dispflag = false;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_frame = zeros(framelen,nframe,nchannel);
partial_frame = zeros(framelen,nframe,nchannel,npartial);
amplitude_frame = zeros(framelen,nframe,nchannel,npartial);
frequency_frame = zeros(framelen,nframe,nchannel,npartial);
phase_frame = zeros(framelen,nframe,nchannel,npartial);

synthwin = tools.ola.mkcolawin(framelen,winflag);

for iframe = 1:nframe
    
    if dispflag
        
        fprintf(1,'OLA synthesis frame %d of %d\n',iframe,nframe);
        
    end
    
    % Stationary synthesis inside each frame
    [amplitude_frame(:,iframe,:,:),frequency_frame(:,iframe,:,:),phase_frame(:,iframe,:,:)] = stationary_synthesis(amp(:,iframe,:),freq(:,iframe,:),ph(:,iframe,:),...
        framelen,fs,center_frame(iframe),nchannel);
    
    % OLA resynthesis
    [time_frame(:,iframe,:),partial_frame(:,iframe,:,:)] = OLA_resynthesis(amplitude_frame(:,iframe,:,:),phase_frame(:,iframe,:,:),synthwin,framelen,npartial,nchannel);
    
end

% OLA scaling factor
sc = tools.ola.colasum(winflag)*(framelen/2)/hop;

% Overlap-add time_frame
sinusoidal = tools.ola.ola(time_frame,framelen,winflag,nsample,center_frame,nframe,nchannel,causalflag)/sc;

% Overlap-add partials
partial = tools.ola.ola(partial_frame,framelen,winflag,nsample,center_frame,nframe,nchannel,causalflag)/sc;

% Overlap-add amplitude
amplitude = tools.ola.ola(amplitude_frame,framelen,winflag,nsample,center_frame,nframe,nchannel,causalflag)/sc;

% Overlap-add frequency
frequency = tools.ola.ola(frequency_frame,framelen,winflag,nsample,center_frame,nframe,nchannel,causalflag)/sc;

% Overlap-add phase
phase = tools.ola.ola(phase_frame,framelen,winflag,nsample,center_frame,nframe,nchannel,causalflag)/sc;

end
