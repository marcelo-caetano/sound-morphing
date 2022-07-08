function [s1,s2] = zp2max(s1,s2)
%ZP2MAX Zeropad to maximum duration.
%   [M1,M2] = ZP2MAX(S1,S2) zero-pads the shorter of S1 and S2 so that both
%   M1 and M2 have the same number of samples. Both S1 and S2 are converted
%   to column vectors.
%
%   See also FLEXPAD

% 2019 M Caetano (SMT 0.1.1)
% 2020 MCaetano SMT 0.2.1
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


% Convert to column vector
s1 = s1(:);
s2 = s2(:);

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
