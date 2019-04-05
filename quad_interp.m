function [xm,ym,a] = quad_interp(x,y)


% y-ym = a(x-xm)^2

% xm = ((y2-y1)(x3-x1)(x3+x1)+(y1-y3)(x2-x1)(x2+x1))/(2(y3-y2)(x1-x2)+(y1-y2)(x1-x3));
%         a = (y2-y1)/((x2-x1)(x1+x2-2*xm));
%         ym = y1-a*(x1-xm)^2;
% 
% %Maximum
% xm = x0/(2*a);
% 
% ym = a*(xm-x0)^2+y0;

xm = ((y(2)-y(1))*(x(3)-x(1))*(x(3)+x(1))+(y(1)-y(3))*(x(2)-x(1))*(x(2)+x(1)))/(2*((y(3)-y(1))*(x(1)-x(2))+(y(1)-y(2))*(x(1)-x(3))));
a = (y(2)-y(1))/((x(2)-x(1))*(x(1)+x(2)-2*xm));
ym = y(1)-a*(x(1)-xm)^2;

% M Caetano