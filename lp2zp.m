function zp = lp2zp(lp,winlen)
%LP2ZP linear phase to zero phase.
%   ZP = LP2ZP(LP,WINLEN) flips the linear phase signal LP around
%   the center CW of the window with WINLEN samples. CW = CFW(W,'HALF').
%
%   See also zp2lp

leftwin = lhw(winlen);

zp = [lp(leftwin+1:end,:);lp(1:leftwin,:)];

end
