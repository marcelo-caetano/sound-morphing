function sample = f2s(frame,cfw,hopsize)
%F2S Frame to sample.
%
%   S = F2S(F,CFW,R) returns the samples S at the center of the frames F 
%   obtained with an M-sample long sliding window by hops of R samples.
%   The sample S(1) corresponding to the center of the first window is
%   obtained as CFW = cfw(M,C), C is a flag that specifies the center of 
%   the first window to be 'ONE', 'HALF', or 'NHALF'.
%   
%   See also s2f

sample = cfw + (frame - 1) .* hopsize;

end