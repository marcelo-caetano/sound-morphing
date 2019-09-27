function [s1,s2] = zp2max(s1,s2)
%ZP2MAX Zeropad to maximum duration
%   Detailed explanation goes here

% Duration of sound 1
dur1 = size(s1,1);

% Duration of sound 2
dur2 = size(s2,1);

% Zeropad shorter sound to duration of longer one (in samples)
if isequal(dur1,dur2)
    
    return
    
elseif dur1 > dur2
    
    s2 = [s2;zeros(dur1-dur2,1)];
    
else
    
    s1 = [s1;zeros(dur2-dur1,1)];
    
end

end
