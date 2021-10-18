function [fft_frame,center_frame,nsample,nframe,nchannel,dc] = stft(wav,framelen,hop,nfft,winflag,causalflag,normflag,zphflag)
%STFT Short-Time Fourier Transform.
%   [ST,CFR,NSAMPLE,NFRAME,NCHANNEL,DC] = STFT(S,M,H,NFFT,WINFLAG,CAUSALFLAG)
%   returns the STFT of signal S calculated with a WINFLAG window of length
%   M and a hop size of H samples. NFFT is the size of the FFT. Each frame
%   is zero-padded if NFFT > M. If NFFT < M, NFFT defaults to the first
%   power of two that satisfies NFFT > M (otherwise FFT truncates the frames
%   resulting in loss of information).
%
%   CAUSALFLAG is a text flag that determines the causality of the first
%   analysis window. CAUSALFLAG can be NON, CAUSAL, or ANTI.
%
%   STFT returns the short-term FFT in the columns of ST, the original
%   length NSAMPLE of S (in samples), the dc value DC of S, the array CFR
%   with the samples corresponding to the center of the frames of ST, and
%   the number of frames NFRAME.
%
%   [ST,...] = STFT(S,M,H,NFFT,WINFLAG,CAUSALFLAG,NORMFLAG) returns ST
%   calculated with a normalized window (normalized energy). NORMFLAG =
%   TRUE normalizes and NORMFLAG = FALSE does not. When NORMFLAG is not
%   specified, it defaults to TRUE.
%
%   [ST,...] = STFT(S,M,H,NFFT,WINFLAG,CAUSALFLAG,NORMFLAG,ZPHFLAG) returns ST
%   calculated with a zero-phase window. ZPHFLAG = TRUE uses a zero-phase
%   window and ZPHFLAG = FALSE does not. When ZPHFLAG is not specified, it
%   defaults to TRUE.
%
%   See also ISTFT

% 2016 M Caetano; Revised 2019
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0 (Revised)
% 2021 M Caetano SMT (Revised for stereo)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% TODO: CHECK INPUT ARGUMENTS (NaN,class, etc)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(6,8);

% Check number of output arguments
nargoutchk(0,6);

if nargin == 6
    
    normflag = true;
    
    zphflag = true;
    
elseif nargin == 7
    
    zphflag = true;
    
end

if nfft < framelen
    
    nfft_err = nfft;
    
    nfft = tools.dsp.fftsize(framelen);
    
    warning('SMT:STFT:InvalidInputArgument',...
        ['Input argument NFFT does not match the dimensions of the STFT.\n'...
        'Zero padding requires NFFT > FRAMELEN.\nNFFT entered was %d.\n'...
        'NFFT entered was %d.\nUsing NFFT = %d'],nfft_err,framelen,nfft);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make overlapping time frames
[time_frame,center_frame,nsample,nframe,nchannel,dc] = sof(wav,framelen,hop,winflag,causalflag,normflag);

% Zero pad time frames
zpad_frame = tools.dsp.zeropad(time_frame,nfft);


% zero phase
if zphflag
    
    zph_frame = tools.dsp.lin_phase2zero_phase(zpad_frame,framelen);
    
else
    
    zph_frame = zpad_frame;
    
end

% Calculate the Short-Time Fourier Transform
fft_frame = fft(zph_frame,nfft);

end
