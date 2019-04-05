function [fftfr,duration,dc,cframe] = stft(sig,hopsize,winlen,wintype,center,nfft,normflag,zphflag)
%SHORT_FFT Short-Time Fourier Transform.
%
%   [ST,L,DC,CFR] = STFT(S,H,M,WINTYPE,CENTER) returns the
%   STFT of signal S calculated with a WINTYPE window of length M and a
%   hopsize of H samples. The flag CENTER determines the sample
%   corresponding to the center of the first analysis window. CENTER can be
%   ONE, HALF, or NHALF. The size of the FFT defaults to M???
%
%   STFT returns the short-term FFT in the columns of ST, the original
%   length L of S (in samples), the dc value DC of S, and the vector CFR
%   with the samples corresponding to the center of the frames of ST.
%
%   [ST,CFRAME,L,DC] = STFT(S,H,M,WINTYPE,CENTER,NFFT) uses NFFT as the
%   size of the FFT. Each frame is zero-padded if M < NFFT but NFFT is
%   ignored if M > NFFT (no loss of information.)
%
%   [ST,CFRAME,L,DC] = STFT(S,H,M,WINTYPE,CENTER,NFFT,NORM) returns ST
%   calculated with a normalized window (normalized energy). NORM = 1
%   normalizes and NORM = 0 does not. The default is ???.
%
%   [ST,CFRAME,L,DC] = STFT(S,H,M,WINTYPE,CENTER,NFFT,NORM,ZPH) returns ST
%   calculated with a zero-phase window. ZPH = 1 specifies zero-phase and
%   ZPH = 0 specifies otherwise.

% M Caetano

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPLIT INTO OVERLAPPING FRAMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[frames,duration,dc,cframe] = sof(sig,hopsize,winlen,wintype,center,normflag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROCESS FRAMES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% zero pad
if nfft > winlen
    
    zpadfr = zpad(frames,winlen,nfft);
    
elseif nfft == winlen
    
    zpadfr = frames;
    
else
    
    nfft = 2^nextpow2(winlen);
    
    zpadfr = zpad(frames,winlen,nfft);
    
end

% zero phase
if zphflag
    
    zphfr = lp2zp(zpadfr,winlen);
    
else
    
    zphfr = zpadfr;
    
end

% Calculate the Short-Time Fourier Transform
fftfr = fft(zphfr,nfft);

%R = ifft(fftfr.^2);

end