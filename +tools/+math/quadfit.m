function [xm,ym,conc] = quadfit(x1,x2,x3,y1,y2,y3,tol)
%THREEPT_QUADFIT Three-point quadratic fit.
%   [Xm,Ym] = THREEPT_QUADFIT(X1,X2,X3,Y1,Y2,Y3) returns the points (Xm,Ym)
%   corresponding to the vertex of the parabola fit to the pairs of points
%   (X1 X2 X3) and (Y1 Y2 Y3).
%
%   For a parabola given by the general equation Y-Ym = CONC(X-Xm)^2, Xm is
%   the abscissae of the vertex, Ym is the ordinates of the vertex, and
%   CONC is the concavity of the parabola.
%
%   Given X1, X2, and X3 with their corresponding Y1, Y2, and Y3, the
%   parameters of the parabola Xm, Ym, and CONC cab be obtained
%   respectively as:
%
%   Xm = ((Y2-Y1)(X3-X1)(X3+X1)+(Y1-Y3)(X2-X1)(X2+X1))/(2*(Y1-Y2)(X1-X3)+(Y3-Y1)(X1-X2)).
%
%   CONC = (Y2-Y1)/((X2-X1)(X1+X2-2*Xm)).
%
%   Ym = Y1-CONC*(X1-Xm)^2.
%
%   [Xm,Ym] = THREEPT_QUADFIT(X1,X2,X3,Y1,Y2,Y3,TOL) uses the tolerance TOL
%   to avoid division by zero when X1 and X3 are symmetrical around Xm. The
%   values of Y1 and Y3 are used as ABS(Y1-Y3) < TOL.
%
%   [Xm,Ym,CONC] = QUADFIT(...) also returns the concavities CONC.
%
%   See also LINFIT

% 2016 M Caetano
% 2019 MCaetano SMT 0.1.0 (Revised)
% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(6,7);

% Check number of output arguments
nargoutchk(0,3);

if nargin == 6
    
    tol = 1e-10;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ABSCISSAE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Numerator of the abscissae
num_abs = (y2 - y1).*(x3 - x1).*(x3 + x1) + (y1 - y3).*(x2 - x1).*(x2 + x1);

% Denominator of the abscissae
den_abs = 2*( (y1 - y2).*(x1 - x3) + (y3 - y1).*(x1 - x2) );

% Abscissae of maxima
xm = num_abs ./ den_abs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONCAVITIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Function handle array for two-point peak
concavity.twopt = {@(X1,X2,X3,Y1,Y2,Y3) Y2-Y1, @(X1,X2,X3,Y1,Y2,Y3,Xm) (X2-X1).*(X1+X2-2*Xm)};

% Function handle array for three-point peak
concavity.threept = {@(X1,X2,X3,Y1,Y2,Y3) Y3-Y1, @(X1,X2,X3,Y1,Y2,Y3,Xm) (X3-X1).*(X1+X3-2*Xm)};

% TRUE for two-point peak (within floating point tolerance)
bool = abs(y1-y3) < tol;

% If any symmetrical case
if any(bool(:))
    
    % Initialize variables
    num_conc = nan(size(bool));
    den_conc = nan(size(bool));
    
    % TWO-POINT PEAK
    
    % Numerator of concavities
    num_conc(bool) = concavity.twopt{1}(x1(bool),x2(bool),x3(bool),y1(bool),y2(bool),y3(bool));
    
    % Denominator of concavities
    den_conc(bool) = concavity.twopt{2}(x1(bool),x2(bool),x3(bool),y1(bool),y2(bool),y3(bool),xm(bool));
    
    % THREE-POINT PEAK
    
    % Numerator of concavities
    num_conc(~bool) = concavity.threept{1}(x1(~bool),x2(~bool),x3(~bool),y1(~bool),y2(~bool),y3(~bool));
    
    % Denominator of concavities
    den_conc(~bool) = concavity.threept{2}(x1(~bool),x2(~bool),x3(~bool),y1(~bool),y2(~bool),y3(~bool),xm(~bool));
    
else
    
    % Numerator of concavities
    num_conc = concavity.threept{1}(x1,x2,x3,y1,y2,y3);
    
    % Denominator of concavities
    den_conc = concavity.threept{2}(x1,x2,x3,y1,y2,y3,xm);
    
end

% Concavity
conc = num_conc ./ den_conc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDINATES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ordinates of the maxima
ym = y1 - conc.*(x1 - xm).^2;

end
