function [sinusoidal,partial,amplitude,frequency,phase] = sinusoidal_resynthesis_PRFI(amp,freq,framelen,hop,fs,nsample,center_frame,...
    npartial,nframe,causalflag,dispflag)
%SINUSOIDAL_RESYNTHESIS_PRFI Sinusoidal resynthesis via phase
%reconstruction by frequency integration (PRFI) as described in [1].
%   [SIN,PART,At,Ft] = SINUSOIDAL_RESYNTHESIS_PRFI(A,F,Delta,M,H,Fs,NSAMPLE,
%   CFR,MAXNPEAK,CAUSALFLAG,DISPFLAG) synthesizes the sinusoidal model SIN
%   from the amplitude A and frequency F returned by
%   SINUSOIDAL_ANALYSIS. DELTA determines the frequency difference for peak
%   continuation as described in [1]. All other parameters come from the
%   frame-by-frame analysis step. Type HELP SINUSOIDAL_ANALYSIS for further
%   information on analysis and HELP SINUSOIDAL_RESYNTHESIS for synthesis.
%
%   Besides the sinusoidal model SIN, SINUSOIDAL_RESYNTHESIS_PRFI also
%   returns PART containing the individual partial that comprise SIN when
%   combined, At with the time-varying amplitude of PART and Ft with the
%   time-varying frequency.
%
%   See also SINUSOIDAL_RESYNTHESIS, SINUSOIDAL_RESYNTHESYS_PI,
%   SINUSOIDAL_RESYNTHESIS_OLA, SINUSOIDAL_ANALYSIS
%
%   [1] McAulay,R., Quatieri,T. (1984) Magnitude-only reconstruction using
%   a sinusoidal speech model. Proc. ICASSP. vol. 9, pp. 441-444.

% 2016 M Caetano
% 2020 MCaetano SMT 0.1.2 (Revised)
% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(10,11);

% Check number of output arguments
nargoutchk(0,5);

if nargin == 10
    
    dispflag = false;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zero-padding at start and end for frame-based processing
shift = tools.dsp.causal_zeropad(framelen,causalflag);

% Preallocate for NFRAME
ph_cont = nan(npartial,nframe);

% Preallocate
sinusoidal = zeros(nsample+2*shift,1);
partial = zeros(nsample+2*shift,npartial);
amplitude = zeros(nsample+2*shift,npartial);
frequency = zeros(nsample+2*shift,npartial);
phase = zeros(nsample+2*shift,npartial);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FROM CFRAME-LEFTWIN(WINSIZE) TO CFRAME (LEFT CAUSAL OF FIRST WINDOW)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Range of time samples (including SHIFT)
range_row = center_frame(1)-tools.dsp.leftwin(framelen)+shift:center_frame(1)-1+shift;
range_col = 1:npartial;

%%%%%%%%%%%%%%%%%%%%
% Estimation for LEFTWIN
%%%%%%%%%%%%%%%%%%%%

% Constant amplitude
amp_leftwin = cat(2,zeros(npartial,1),amp(:,1));

% Constant frequency
freq_leftwin = cat(2,freq(:,1),freq(:,1));

% When FREQUENCY_INTEGRATION uses COS for resynthesis
% ph_cont = -freq(:,1)*2*pi*tools.dsp.leftwin(framelen)/fs -pi/2*ones(npartial,1);

% Phase continuation (FREQUENCY_INTEGRATION uses SIN for resynthesis)
phase_leftwin = -freq(:,1)*2*pi*tools.dsp.leftwin(framelen)/fs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADDITIVE SYNTHESIS BY PHASE RECONSTRUCTION BY FREQUENCY INTEGRATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Frequency integration
[amplitude(range_row,range_col),frequency(range_row,range_col),phase(range_row,range_col)] = frequency_integration...
    (amp_leftwin,freq_leftwin,phase_leftwin,tools.dsp.leftwin(framelen),fs);

% Additive resynthesis (with linear phase estimation)
[sinusoidal(range_row),partial(range_row,range_col)] = PRFI_resynthesis(amplitude(range_row,range_col),phase(range_row,range_col));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FROM CFRAME TO CFRAME+HOPSIZE (BETWEEN CENTER OF CONSECUTIVE WINDOWS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iframe = 1:nframe-1
    
    if dispflag
        
        fprintf(1,'PRFI synthesis between frame %d and %d of %d\n',iframe,iframe+1,nframe);
        
    end
    
    % Phase continuation (FREQUENCY_INTEGRATION uses SIN for resynthesis)
    ph_cont(:,iframe) = phase(center_frame(iframe)-1+shift,:)';
    
    % Range of time samples (including SHIFT)
    range_row = center_frame(iframe)+shift:center_frame(iframe+1)-1+shift;
    range_col = 1:npartial;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ADDITIVE SYNTHESIS BY PHASE RECONSTRUCTION BY FREQUENCY INTEGRATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Frequency integration
    [amplitude(range_row,range_col),frequency(range_row,range_col),phase(range_row,range_col)] = frequency_integration...
        (amp(:,iframe:iframe+1),freq(:,iframe:iframe+1),ph_cont(:,iframe),hop,fs);
    
    % Additive resynthesis
    [sinusoidal(range_row),partial(range_row,range_col)] = PRFI_resynthesis(amplitude(range_row,range_col),phase(range_row,range_col));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FROM CFRAME TO CFRAME+RIGHTWIN(WINSIZE) (RIGHT CAUSAL OF LAST WINDOW)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Range of time samples (including SHIFT)
range_row = center_frame(nframe)+shift:nsample+shift;
range_col = 1:npartial;

%%%%%%%%%%%%%%%%%%%%
% Estimation for RIGHTWIN
%%%%%%%%%%%%%%%%%%%%

% Constant amplitude
amp_rightwin = cat(2,amp(:,nframe),amp(:,nframe));

% Constant frequency
freq_rightwin = cat(2,freq(:,nframe),freq(:,nframe));

% Phase continuation (FREQUENCY_INTEGRATION uses SIN for resynthesis)
phase_rightwin = phase(center_frame(nframe)-1+shift,:)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADDITIVE SYNTHESIS BY PHASE RECONSTRUCTION BY FREQUENCY INTEGRATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Frequency integration
[amplitude(range_row,range_col),frequency(range_row,range_col),phase(range_row,range_col)] = frequency_integration...
    (amp_rightwin,freq_rightwin,phase_rightwin,nsample-center_frame(nframe)+1,fs);

% Additive resynthesis (with linear phase estimation)
[sinusoidal(range_row),partial(range_row,range_col)] = PRFI_resynthesis(amplitude(range_row,range_col),phase(range_row,range_col));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRIM EXTRA TIME SAMPLES INRODUCED BY SHIFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sinusoidal = sinusoidal(1+shift:nsample+shift);
partial = partial(1+shift:nsample+shift,:);
amplitude = amplitude(1+shift:nsample+shift,:);
frequency = frequency(1+shift:nsample+shift,:);
phase = phase(1+shift:nsample+shift,:);

end
