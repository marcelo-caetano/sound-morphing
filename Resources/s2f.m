function frame = s2f(sample,cfw,hopsize)
%S2F    sample to frame
%
%   F = S2F(S,CFW,R) returns the frame numbers F for each sample S
%   corresponding to the center of an M-sample long sliding window by hops 
%   of R samples. The sample S(1) corresponding to the center of the first
%   window is CFW = cfw(M,C), C is a flag that specifies the center of 
%   the first window to be 'ONE', 'HALF', or 'NHALF'.
%   
%   See also s2f

frame = (sample - cfw) ./ hopsize + 1;

end