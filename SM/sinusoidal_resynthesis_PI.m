function [sinusoidal,partial,amplitude,frequency,phase] = sinusoidal_resynthesis_PI(amp,freq,ph,framelen,hop,fs,nsample,center_frame,...
    npartial,nframe,causalflag,dispflag)
%SINUSOIDAL_RESYNTHESIS_PI_VEC Sinusoidal resynthesis by parameter
%interpolation as described in [1].
%   [SIN,PART,AMP,PH,FREQ] = SINUSOIDAL_RESYNTHESIS_PI(A,F,P,M,H,Fs,NSAMPLE,CFR,NPEAK,NFRAME,CAUSALFLAG,DISPFLAG)
%   resynthesizes the sinusoidal model SIN from the output parameters of
%   SINUSOIDAL_ANALYSIS (A,F,P), where A=amplitude, F=frequency, and
%   P=phases estimated with a hop H and a frame size of M. DELTA
%   determines the frequency difference for peak continuation as described
%   in [1].
%
%   See also SINUSOIDAL_RESYNTHESIS_OLA, SINUSOIDAL_RESYNTHESIS_PRFI
%
% [1] McAulay and Quatieri (1986) Speech Analysis/Synthesis Based on a
% Sinusoidal Representation, IEEE Transactions on Acoustics,
% Speech, and Signal Processing ASSP-34(4),744-754.

% 2016 M Caetano
% Revised 2019 (SM 0.1.1)
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(11,12);

% Check number of output arguments
nargoutchk(0,5);

if nargin == 11
    
    dispflag = false;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zero-padding at start and end for frame-based processing
shift = tools.dsp.causal_zeropad(framelen,causalflag);

% Preallocate
sinusoidal = zeros(nsample+2*shift,1);
partial = zeros(nsample+2*shift,npartial);
amplitude = zeros(nsample+2*shift,npartial);
frequency = zeros(nsample+2*shift,npartial);
phase = zeros(nsample+2*shift,npartial);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FROM CFRAME-LEFTWIN(WINSIZE) TO CFRAME (LEFT HALF OF FIRST WINDOW)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Range of time samples (including SHIFT)
range_row = center_frame(1)-tools.dsp.leftwin(framelen)+shift:center_frame(1)-1+shift;
range_col = 1:npartial;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimation for LEFT HALF OF FIRST WINDOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Constant amplitude
amp_leftwin = cat(2,amp(:,1),amp(:,1));

% Constant frequency
freq_leftwin = cat(2,freq(:,1),freq(:,1));

% Linear phase
phase_leftwin = cat(2,ph(:,1)-(freq(:,1)*2*pi*tools.dsp.leftwin(framelen)/fs),ph(:,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADDITIVE SYNTHESIS BY PARAMETER INTERPOLATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameter interpolation
[amplitude(range_row,range_col),frequency(range_row,range_col),phase(range_row,range_col)] = ...
    parameter_interpolation(amp_leftwin,freq_leftwin,phase_leftwin,tools.dsp.leftwin(framelen),fs);

% Additive resynthesis
[sinusoidal(range_row,1),partial(range_row,range_col)] = PI_resynthesis(amplitude(range_row,range_col),phase(range_row,range_col));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FROM CFRAME TO CFRAME+HOPSIZE (BETWEEN CENTERS OF CONSECUTIVE WINDOWS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iframe = 1:nframe-1
    
    if dispflag
        
        fprintf(1,'PI synthesis between frame %d and %d of %d\n',iframe,iframe+1,nframe);
        
    end
    
    % Range of time samples (including SHIFT)
    range_row = center_frame(iframe)+shift:center_frame(iframe+1)-1+shift;
    range_col = 1:npartial;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ADDITIVE SYNTHESIS BY PARAMETER INTERPOLATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Parameter interpolation (linear phase estimation)
    [amplitude(range_row,range_col),frequency(range_row,range_col),phase(range_row,range_col)] = ...
        parameter_interpolation(amp(:,iframe:iframe+1),freq(:,iframe:iframe+1),ph(:,iframe:iframe+1),hop,fs);
    
    % Additive resynthesis
    [sinusoidal(range_row,1),partial(range_row,range_col)] = PI_resynthesis(amplitude(range_row,range_col),phase(range_row,range_col));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FROM CFRAME TO CFRAME+RIGHTWIN(WINSIZE) (RIGHT HALF OF LAST WINDOW)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Range of time samples (including SHIFT)
range_row = center_frame(nframe)+shift:nsample+shift;
range_col = 1:npartial;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimation for RIGHT HALF OF LAST WINDOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Constant amplitude
amp_rightwin = cat(2,amp(:,nframe),amp(:,nframe));

% Constant frequency
freq_rightwin = cat(2,freq(:,nframe),freq(:,nframe));

% Linear phase
phase_rightwin = cat(2,ph(:,nframe),ph(:,nframe) + (freq(:,nframe)*2*pi*(nsample-center_frame(nframe)+1)/fs));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADDITIVE SYNTHESIS BY PARAMETER INTERPOLATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameter interpolation
[amplitude(range_row,range_col),frequency(range_row,range_col),phase(range_row,range_col)] = ...
    parameter_interpolation(amp_rightwin,freq_rightwin,phase_rightwin,nsample-center_frame(nframe)+1,fs);

% Additive resynthesis
[sinusoidal(range_row,1),partial(range_row,range_col)] = PI_resynthesis(amplitude(range_row,range_col),phase(range_row,range_col));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRIM EXTRA TIME SAMPLES INRODUCED BY SHIFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Remove zero-padding
sinusoidal = sinusoidal(1+shift:nsample+shift);
partial = partial(1+shift:nsample+shift,:);
amplitude = amplitude(1+shift:nsample+shift,:);
frequency = frequency(1+shift:nsample+shift,:);
phase = phase(1+shift:nsample+shift,:);

end
