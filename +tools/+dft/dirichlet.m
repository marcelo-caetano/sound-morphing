function dirich_kernel = dirichlet(bin,framelen,nfft,normflag,zphflag)
%DIRICHLET Dirichlet kernel.
%   D = DIRICHLET(BIN,FRAMELEN,NFFT,NORMFLAG,ZPHFLAG) returns the Dirichlet
%   kernel of degree FRAMELEN evaluated at the frequency bins BIN sampled
%   at NFFT. BIN can be positive or negative real numbers. The positive
%   integer FRAMELEN is the number of equally spaced extrema of D in the
%   interval 0 to 2*pi. NFFT is the sampling of the discrete frequency axis
%   given by OMEGA = 2*pi*k/NFFT. NORMFLAG is a logical flag that
%   determines if D is normalized by FRAMELEN. NORMFLAG = TRUE sets
%   normalization and NORMFLAG = FALSE does not. ZPHFLAG is a logical flag
%   that determines if D is zero phase or linear phase. ZPHFLAG = TRUE sets
%   zero-phase and ZPHFLAG = FALSE sets linear-phase.
%
%   The Dirichlet kernel is generated as
%       D(BIN) = exp(-1i*(FRAMELEN-1)*pi*BIN/NFFT).*sin(FRAMELEN*pi*BIN/NFFT)./FRAMELEN*(sin(pi*BIN/NFFT))
%   for all OMEGA not a multiple of 2*pi and +1 or -1 for OMEGA a multiple
%   of 2*pi (depending on limit).
%
%   [1] F. J. Harris, "On the use of windows for harmonic analysis with the
%   discrete Fourier transform," in Proceedings of the IEEE, vol. 66, no. 1,
%   pp. 51-83, Jan. 1978.
%
%   See also DIRIC, TOOLS.DFT.RECTWIN

% 2019 M Caetano
% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check the number of input arguments
narginchk(5,5);

% Check the number of output arguments
nargoutchk(0,1);

validateattributes(bin,{'numeric'},{'real'},mfilename,'BIN',1)

validateattributes(framelen,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'FRAMELEN',2)

validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',3)

validateattributes(normflag,{'numeric','logical'},{'scalar','finite','nonnan','binary'},mfilename,'NORMFLAG',4)

validateattributes(zphflag,{'numeric','logical'},{'scalar','finite','nonnan','binary'},mfilename,'ZPHFLAG',5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Normalized Dirichlet kernel
dirich_kernel = dirichletKernel(bin,framelen,nfft);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NORMALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Revert normalization by FRAMELEN
if ~normflag
    
    dirich_kernel = framelen*dirich_kernel;
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHASE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~zphflag
    % Causal
    ph_shift = (framelen - 1)/2;
    
elseif tools.misc.iseven(framelen)
    % Zero-phase (even)
    ph_shift = -1/2;
    
else
    % Zero-phase (odd)
    ph_shift = 0;
    
end

% Complex phase
phase = tools.dft.phasedft(bin,nfft,ph_shift);

% Add phase to kernel
dirich_kernel = phase.*dirich_kernel;


end

% LOCAL FUNCTION TO CALCULATE THE DIRICHLET KERNEL
function dkernel = dirichletKernel(bin,framelen,nfft)

% Initialize dirich_kernel (otherwise DKERNEL becomes row vector with assignement DKERNEL(isDivZero)
dkernel = nan(size(bin));

% Normalized frequencies
norm_freq = tools.dft.normfreq(bin,nfft);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INTEGER MULTIPLES OF 2*PI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find indices with potential division by zero (integer multiples of 2*pi)
isDivZero = isIntegerMultiple2PI(norm_freq);

% Normalized kernel for integer multiples of 2*pi
dkernel(isDivZero) = dirichletKernelIntegerMultiple2PI(norm_freq(isDivZero),framelen);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DIRICHLET KERNEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Numerator
num = sin(framelen*norm_freq(~isDivZero)/2);

% Denominator
den = framelen * sin(norm_freq(~isDivZero)/2);

% Normalized Dirichlet kernel
dkernel(~isDivZero) = num ./ den;

end

% Local function to find integer multiples of 2*PI
function isIntMult = isIntegerMultiple2PI(normFreq)

% Tolerance for floating point arithmetic
tol = 1e-11;

% Invert frequency normalization to get BIN/NFFT
intFreq = normFreq/(2*pi);

% Find all integer values
remIntFreq = rem(intFreq,1);

% Handle positive or negative integers
absRemIntFreq = abs(remIntFreq);

% TRUE for remainder smaller than TOL
isIntMult = absRemIntFreq < tol;

end

% Local function to calculate problematic values for the Dirichlet kernel
function dkernel = dirichletKernelIntegerMultiple2PI(normFreq,framelen)

% L'Hopital for lim_{x->2*pi} D_M(omega)
dkernel = sign(cos((framelen + 1)*normFreq/2));

end
