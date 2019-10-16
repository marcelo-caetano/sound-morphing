function [fft_frame,nsample,dc,cframe] = stft(sig,hopsize,framesize,wintype,nfft,cfwflag,normflag,zphflag)
%STFT Short-Time Fourier Transform.
%   [ST,L,DC,CFR] = STFT(S,H,M,WINTYPE,CENTER) returns the
%   STFT of signal S calculated with a WINTYPE window of length M and a
%   hopsize of H samples. The flag CENTER determines the sample
%   corresponding to the cfwflag of the first analysis window. CENTER can be
%   ONE, HALF, or NHALF. The size of the FFT defaults to M???
%
%   STFT returns the short-term FFT in the columns of ST, the original
%   length L of S (in samples), the dc value DC of S, and the vector CFR
%   with the samples corresponding to the cfwflag of the frames of ST.
%
%   [ST,CFRAME,L,DC] = STFT(S,H,M,WINTYPE,NFFT,CENTER) uses NFFT as the
%   size of the FFT. Each frame is zero-padded if M < NFFT but NFFT is
%   ignored if M > NFFT (no loss of information.)
%
%   [ST,CFRAME,L,DC] = STFT(S,H,M,WINTYPE,NFFT,CENTER,NORM) returns ST
%   calculated with a normalized window (normalized energy). NORM = 1
%   normalizes and NORM = 0 does not. The default is ???.
%
%   [ST,CFRAME,L,DC] = STFT(S,H,M,WINTYPE,NFFT,CENTER,NORM,ZPH) returns ST
%   calculated with a zero-phase window. ZPH = 1 specifies zero-phase and
%   ZPH = 0 specifies otherwise.

% 2016 M Caetano; Revised 2019 (SMT 0.1.1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPLIT INTO OVERLAPPING FRAMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[frames,nsample,dc,cframe] = sof(sig,hopsize,framesize,wintype,cfwflag,normflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROCESS FRAMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% zero pad
if nfft > framesize
    
    zpad_frame = zpad(frames,framesize,nfft);
    
elseif nfft == framesize
    
    zpad_frame = frames;
    
else
    
    nfft = 2^nextpow2(framesize);
    
    zpad_frame = zpad(frames,framesize,nfft);
    
end

% zero phase
if zphflag
    
    zph_frame = lp2zp(zpad_frame,framesize);
    
else
    
    zph_frame = zpad_frame;
    
end

% Calculate the Short-Time Fourier Transform
fft_frame = fft(zph_frame,nfft);

end