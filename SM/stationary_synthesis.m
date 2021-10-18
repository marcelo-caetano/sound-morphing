function [amplitude,frequency,phase_argument,synthwin] = stationary_synthesis(amp,freq,ph,framelen,fs,cframe,winflag)
%STATIONARY_SYNTHESIS Synthesis of stationary sinusoids inside each frame.
%   [AMP,FREQ,PH,SWIN] = STATIONARY_SYNTHESIS(A,F,P,M,Fs,CFR,WINFLAG)
%   synthesizes each partial as s(n) = A*cos(2*pi*F*M/Fs + THETA)
%   THETA is the phase shift calculated as THETA = P - 2*pi*f*M/Fs, where M
%   is the frame length and Fs is the sampling rate.
%
%   See also PARAMETER_INTERPOLATION, FREQUENCY_INTEGRATION

% 2017 M Caetano; Revised 2019
% 2020 MCaetano SMT 0.2.0
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(7,7);

% Check number of output arguments
nargoutchk(0,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make samples spanning frame framelen
samples = (cframe-tools.dsp.leftwin(framelen):cframe+tools.dsp.rightwin(framelen))';

% Make synthesis window
synthwin = tools.ola.mkcolawin(framelen,winflag);

% Calculate phase shift (using causalflag of frame as reference)
phase_shift = ph - (2*pi*cframe/fs)*freq;

% Calculate phase argument
phase_argument = 2*pi*samples/fs*freq' + repmat(phase_shift',framelen,1);

% Constant amplitude across frame
amplitude = repmat(amp',framelen,1);

% Get frequencies as derivative of phases
frequency = gradient(phase_argument);

end
