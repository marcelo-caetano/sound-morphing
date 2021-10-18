function negbin = binshift(bin,nfft)
%BINSHIFT Shift zero-frequency bin to the center of the spectrum.
%   SBIN = BINSHIFT(BIN,NFFT) shifts the zero-frequency bin in BIN to the
%   center of the frequency spectrum. BIN is size NFFT x NFRAME x NCHANNEL,
%   so the shift depends on the FFT size NFFT.
%
%   See also FFTFLIP, NYQ, BIN2IND, BIN2FREQ

% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,2);

% Check number of output arguments
nargoutchk(0,1);

% Validate BIN
validateattributes(bin,{'numeric'},{'3d','nonempty','finite','nonnan','real','nonnegative'},mfilename,'BIN',1)

% Validate NFFT
validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Nyquist frequency bin
nyqbin = tools.spec.nyq_bin(nfft);

% Odd NFFT results in fractional NYQBIN
if tools.misc.isodd(nfft)
    
    % Roud down NYQBIN
    nyqbin = floor(nyqbin);
    
    shift = -nyqbin;
    
else
    
    shift = -nyqbin + 1;
    
end

negbin = bin + shift;

end
