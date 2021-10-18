function linmag = pow2lin(powmag,pow,tol)
%POW2LIN Convert from power to linear amplitude.
%   LINMAG = POW2LIN(POWMAG,POW) scales the power magnitude spectrum
%   POWMAG back to the linear scale using the root of POW. POW2LIN always
%   assumes that LINMAG is real, so POWMAG can be real or complex. POW2LIN
%   returns negative real LINMAG for complex POWMAG appropriately.
%
%   LINMAG = POW2LIN(POWMAG,POW,TOL) uses TOL to handle the sign of LINMAG
%   when POWMAG is complex. The default is TOL = 1.0e-10 for the previous
%   syntax with two input arguments. The value of TOL depends on the
%   magnitude of POW. Large POW requires larger TOL to correctly handle the
%   sign of LINMAG. The default value works for ABS(POW) <= 100. However,
%   large POW will also result in floating point errors in LINMAG.
%
%   See also LIN2POW, LIN2LOG, LOG2LIN

% 2021 MCaetano SMT
% 2021 M Caetano SMT (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


% TODO: Check inputs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,3);

% Check number of output arguments
nargoutchk(0,1);

if nargin == 2
    
    tol = 1e-10;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Inverse power operation
linmag = powmag .^ (1/pow);

% Handle real conversions
if isreal(linmag)
    
    if pow == 0
        
        warning('SMT:POW2LIN:wrongConversion',...
            ['Conversion error.\n'...
            'POW2LIN cannot retrieve the original values when POW = 0.\n']);
        
    elseif tools.misc.isint(pow) && tools.misc.iseven(pow)
        
        warning('SMT:POW2LIN:conversionError',...
            ['Potential conversion error.\n'...
            'POW2LIN cannot retrieve the original sign when POW is even.\n']);
        
    end
    
    % Handle complex conversions
else
    
    % Copy result into dummy variable
    dummy = linmag;
    
    % Reinitialize LINMAG
    linmag = zeros(size(dummy));
    
    % Indices of real roots
    ireal = isImagPartNegligible(dummy,tol);
    
    % Indices of complex roots
    icomplex = ~ireal;
    
    % Real part of real roots
    linmag(ireal) = real(dummy(ireal));
    
    % Absolute value of complex roots
    linmag(icomplex) = -sign(real(dummy(icomplex))).*abs(dummy(icomplex));
    
end

end

% Local function to check if imaginary part is negligible
function bool = isImagPartNegligible(num,tol)

% TRUE when magnitude of imaginary part is smaller than TOL
bool = abs(imag(num)) < tol;

end
