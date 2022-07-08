function bin = freq2bin(freq,fs,nfft,nnflag)
%FREQ2BIN Convert frequency in Hz to bin number.
%   K = FREQ2BIN(F,Fs,NFFT) converts the frequency F in Hertz into bin
%   numbers K for the sampling frequency given by Fs and 0 <= K <= NFFT - 1,
%   where NFFT is the size of the DFT. The DFT bins are Fs/NFFT Hertz apart,
%   so the conversion is K = (F * NFFT)/Fs.
%
%   K = FREQ2BIN(F,Fs,NFFT,NNFLAG) uses NNFLAG to handle fractional
%   bin numbers since frequencies F between the DFT bins will result in
%   fractional bin numbers. NNFLAG = TRUE returns "nearest neighbor"
%   estimations of K and NNFLAG = FALSE returns fractional bin numbers.
%   NNFLAG = FALSE is the default and K = FREQ2BIN(F,Fs,NFFT,FALSE) is
%   equivalent to K = FREQ2BIN(F,Fs,NFFT).
%
%   See also BIN2FREQ, IND2FREQ, FREQ2IND, BIN2IND, IND2BIN, MKFREQ, NYQ_FREQ

% 2016 MCaetano
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input argumrnts
narginchk(3,4);

% Check number of output arguments
nargoutchk(0,1);

% Flag to handle fractional bins
if nargin == 3
    
    nnflag = false;
    
end

validateattributes(freq,{'numeric'},{'nonempty','real'},mfilename,'FREQ',1)

minfreq = fs*(-ceil(nfft/2)+1)/nfft;
maxfreq = fs*(nfft-1)/nfft;

% Keep the logic to guarantee that NaN will not cause error
% Numerical comparisons with NaN always return FALSE
bool_min = freq < minfreq;
bool_max = freq > maxfreq;

% Validate range separately due to possible NaN (validateattributes throws error)
if any(bool_min(:) | bool_max(:))
    
    error('SMT:FREQ2BIN:InvalidArgument',...
        ['Invalid input argument value.\n'...
        'All frequencies must be %2.5g <= FREQ <= %2.5g'],...
        minfreq,maxfreq)
    
end

validateattributes(fs,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'Fs',2)

validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',3)

validateattributes(nnflag,{'numeric','logical'},{'scalar','finite','nonnan','binary'},mfilename,'NNFLAG',4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Conversion
bin = ((freq * nfft) / fs);

% Round off fractional bins
if nnflag
    
    bin = round(bin);
    
end

end
