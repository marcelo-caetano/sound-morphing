function [olasynth,olawin] = ola(time_frame,framelen,hop,nsample,center_frame,nframe,winflag,causalflag)
%OLA Overlap-Add time frames to resynthesize waveform.
%   SYNTH = OLA(FR,M,H,NSAMPLE,CFR,NFRAME,WINFLAG,CAUSALFLAG) overlap-adds
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
% 2020 MCaetano SMT 0.2.0% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number if input arguments
narginchk(8,8);

% Check number if output arguments
nargoutchk(0,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% Number of channels/partials
nchannel = size(time_frame,3);

% Zero-padding at start and end for frame-based processing
shift = tools.dsp.causal_zeropad(framelen,causalflag);

% Preallocate with zero-padding
olasynth = zeros(nsample+2*shift,nchannel);
olawin = zeros(nsample+2*shift,nchannel);

% Make synthesis window
synthesis_window = tools.ola.mkcolawin(framelen,winflag);

% Center of first window
center_win = tools.dsp.centerwin(framelen,causalflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OVERLAP-ADD PROCEDURE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for cf = center_frame'
    
    % Frame number
    iframe = tools.dsp.sample2frame(cf,center_win,hop);
    
    fprintf(1,'Frame %d\n',iframe);
    
    % Overlap-Add TIME_FRAME
    olasynth(cf-tools.dsp.leftwin(framelen)+shift:cf+tools.dsp.rightwin(framelen)+shift,:) = ...
        olasynth(cf-tools.dsp.leftwin(framelen)+shift:cf+tools.dsp.rightwin(framelen)+shift,:) + ...
        squeeze(time_frame(:,iframe,:));
    
    % Overlap-Add SYNTHESIS_WINDOW
    olawin(cf-tools.dsp.leftwin(framelen)+shift:cf+tools.dsp.rightwin(framelen)+shift,:) = ...
        olawin(cf-tools.dsp.leftwin(framelen)+shift:cf+tools.dsp.rightwin(framelen)+shift,:) + ...
        repmat(synthesis_window,1,nchannel);
    
end

% Remove zero-padding
olasynth = olasynth(1+shift:nsample+shift,:);
olawin = olawin(1+shift:nsample+shift,:);

end
