function [freq] = bin2freq(bin,fs,nfft)
%BIN2FREQ Bin number to frequency in Hz
%   F = BIN2FREQ(K,Fs,N) converts the bin number K into frequency F in
%   Hertz for the sampling frequency given by Fs and 0 <= K <= N-1, where
%   N is the size of the DFT. The DFT bins are Fs/N Hertz apart, so the
%   conversion is F = (K * Fs)/N. Fractional bin numbers will result in
%   frequencies between the bins of the DFT.
%
%   See also FREQ2BIN

freq = bin*fs/nfft;

end

