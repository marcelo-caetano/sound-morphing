function [amplitude,frequency,phase_argument] = stationary_synthesis(amp,freq,ph,framelen,fs,cframe,nchannel)
%STATIONARY_SYNTHESIS Synthesis of stationary sinusoids inside each frame.
%   [AMP,FREQ,PH,SWIN] = STATIONARY_SYNTHESIS(A,F,P,M,Fs,CFR,NCHANNEL)
%   synthesizes each partial as s(n) = A*cos(2*pi*F*M/Fs + THETA)
%   THETA is the phase shift calculated as THETA = P - 2*pi*f*M/Fs, where M
%   is the frame length and Fs is the sampling rate.
%
%   See also PARAMETER_INTERPOLATION, FREQUENCY_INTEGRATION

% 2017 M Caetano; Revised 2019
% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(7,7);

% Check number of output arguments
nargoutchk(0,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Length of left half of frame
leftlen = tools.dsp.leftwin(framelen);
% Length of right half of frame
rightlen = tools.dsp.rightwin(framelen);

sample_vec = (cframe - leftlen:cframe + rightlen)';

% FRAMELEN x NCHANNEL
time_sample = repmat(sample_vec,1,nchannel);

% Use center of frame as reference: NPART x 1 x NCHANNEL
phase_shift = ph - 2*pi*cframe*freq/fs;

% TIME_SAMPLE: FRAMELEN x NCHANNEL x 1
% permute(FREQ,[2 3 1]) == permute(PHASE_SHIFT,[2 3 1]): 1 x NCHANNEL x NPARTIAL
% repmat(permute(PHASE_SHIFT,[2 3 1]),framelen,1,1): FRAMELEN x NCHANNEL x NPARTIAL
% PHASE_ARGUMENT: FRAMELEN x NCHANNEL x NPARTIAL
phase_argument = 2*pi*time_sample.*permute(freq,[2 3 1])/fs + repmat(permute(phase_shift,[2 3 1]),framelen,1,1);

% repmat(permute(AMP,[2 3 1]),framelen,1,1): FRAMELEN x NCHANNEL x NPARTIAL
amplitude = repmat(permute(amp,[2 3 1]),framelen,1,1);

% Get frequencies as derivative of phases
frequency = gradient(phase_argument);

end
