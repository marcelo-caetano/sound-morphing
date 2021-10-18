function inyq = nyq_ind(nfft)
%NYQ_IND Array index corresponding to Nyquist frequency.
%   N = NYQ_IND(NFFT) returns the array index corresponding to the
%   Nyquist frequency of an FFT with size NFFT.
%
%   See also NYQ_BIN, NYQ_FREQ, NYQ

% 2020 MCaetano SMT 0.1.1
% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

% Validate NFFT
validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Retrieve Nyquist bin
knyq = tools.spec.nyq_bin(nfft);

% BNYQ is fractional when NFFT is odd
if tools.misc.isodd(nfft)
    
    knyq = floor(knyq);
    
end

% Convert to index
inyq = tools.spec.bin2ind(knyq);

end
