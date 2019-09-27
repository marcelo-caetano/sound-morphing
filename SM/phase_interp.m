function yp = phase_interp(x,y,xp)
%PHASE_INTERP Linear interpolation of phase value across frequency
%   Detailed explanation goes here

% (y-y0) = m(x-x0)
if xp < x(2)
    m = (y(2)-y(1))/(x(2)-x(1));
    if m == 0
        yp = y(2);
    else
        yp = y(2) - (x(2)-xp)*m;
    end
else
    m = (y(3)-y(2))/(x(3)-x(2));
    if m == 0
        yp = y(2);
    else
        yp = y(3)-(x(3)-xp)*m;
    end
end

end