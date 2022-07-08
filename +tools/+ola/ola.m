function [olasynth,olawin] = ola(time_frame,framelen,winflag,nsample,center_frame,nframe,nchannel,causalflag,dispflag)
%OLA Overlap-Add time frames to resynthesize waveform.
%   SYNTH = OLA(FR,M,WINFLAG,NSAMPLE,CFR,NFRAME,NCHANNEL,CAUSALFLAG) overlap-adds
%   the time frames FR by M - H, where M is the frame length and H is the
%   hop size used to make the time frames and returns SYNTH.
%
%   NSAMPLE is the length of the original signal in samples. NSAMPLE is
%   usually different than CENTERWIN+(NFRAME-1)*H because the last frame is
%   always zero-padded to M. Therefore, SYNTH must be truncated to NSAMPLE
%   to recover the original signal length.
%
%   CFR is an array with the samples corresponding to the center of the
%   frames.
%
%   NFRAME is the number of time frames FR. FR is size NSAMPLE x NFRAME.
%
%   WINFLAG is a numeric flag that specifies the following windows
%
%   1 - Rectangular
%   2 - Bartlett
%   3 - Hann
%   4 - Hanning
%   5 - Blackman
%   6 - Blackman-Harris
%   7 - Hamming
%
%   CAUSALFLAG is a character flag that determines the causality of the
%   window. CAUSALFLAG can be 'ANTI', 'NON', or 'CAUSAL' for anti-causal,
%   non-causal, or causal respectively. The sample CENTERWIN corresponding
%   to the center of the first window is obtained as
%   CENTERWIN = tools.dsp.centerwin(M,CAUSALFLAG). Type help
%   tools.dsp.centerwin for further details.
%
%   [SYNTH,OLAWIN] = OLA(...) also returns the overlap-added window OLAWIN
%   specified by WINFLAG.
%
%   See also SOF

% 2016 M Caetano
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number if input arguments
narginchk(8,9);

% Check number if output arguments
nargoutchk(0,2);

if nargin == 8
    
    dispflag = false;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NPARTIAL ~= 1 when overlap-adding partials
[~,~,~,npartial] = size(time_frame);

% Ensure CENTER_FRAME is a column vector
if size(center_frame,1) == 1
    center_frame = center_frame';
end

if ~isequal(length(center_frame),nframe)
    
    warning('SMT:OLA:WrongArrayDim',['Wrong number of frames.\n'...
        'Input number of frames was %d.\n'...
        'Length of CFR is %d.\n'...
        'Using NFRAME = LENGTH(CFR)'],nframe,length(center_frame));
    
    nframe = length(center_frame);
    
end

% Zero-padding at start and end of original signal (compensate for causality of first window)
zpad_len = tools.dsp.causal_zeropad(framelen,causalflag);

% Length of left half of frame
leftlen = tools.dsp.leftwin(framelen);

% Length of right half of frame
rightlen = tools.dsp.rightwin(framelen);

% Preallocate with zero-padding
olasynth = zeros(nsample+2*zpad_len,nchannel,npartial);
olawin = zeros(nsample+2*zpad_len,nchannel,npartial);

synthesis_window = tools.ola.mkcolawin(framelen,winflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OVERLAP-ADD PROCEDURE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iframe = 1:nframe
    
    if dispflag
        
        fprintf(1,'Frame %d\n',iframe);
        
    end
    
    % Time sample at the beginning of IFRAME
    begfr = center_frame(iframe) - leftlen + zpad_len;
    
    % Time sample at the end of IFRAME
    endfr = center_frame(iframe) + rightlen + zpad_len;
    
    % Overlap-Add TIME_FRAME
    olasynth(begfr:endfr,:,:) = olasynth(begfr:endfr,:,:) + reshape(time_frame(:,iframe,:,:),[framelen, nchannel, npartial]);
    
    % Overlap-Add SYNTHESIS_WINDOW
    olawin(begfr:endfr,:,:) = olawin(begfr:endfr,:,:) + repmat(synthesis_window,1,nchannel,npartial);
    
end

% Remove extra time samples added to compensate for causality
time_sample = 1 + zpad_len:nsample + zpad_len;

% Remove zero-padding
olasynth = olasynth(time_sample,:,:);
olawin = olawin(time_sample,:,:);

end
