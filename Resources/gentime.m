function t = gentime(siglen,fs)
%GENTIME Generate time vector in seconds.
%   T = GENTIME(L,SR) generates a time vector T in seconds corresponding to
%   the length L in samples using the sample rate SR as T = (0:L-1)/SR.

% M Caetano

% Generate samples up to signal length
samples = (1:siglen)';

% Generate time in seconds
t = (samples-1)/fs;

end