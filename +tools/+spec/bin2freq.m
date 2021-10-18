function freq = bin2freq(bin,fs,nfft,nnflag)
%BIN2FREQ Convert bin number to frequency in Hz.
%   F = BIN2FREQ(K,Fs,NFFT) converts the bin number K into frequency F in
%   Hertz for the sampling frequency given by Fs, where NFFT is the size of
%   the DFT. The DFT bins are Fs/NFFT Hertz apart, so the conversion is
%   F = (K * Fs)/NFFT. Fractional bin numbers will result in frequencies
%   between the bins of the DFT. Negative bin numbers are accepted as long
%   as -NFFT/2+1 <= K <= NFFT/2. Positive bins must be 0 <= K <= NFFT - 1.
%
%   F = BIN2FREQ(K,Fs,NFFT,NNFLAG) uses NNFLAG to handle fractional bin
%   numbers because fractional bins result in frequencies F between the
%   bins of the DFT. NNFLAG = TRUE rounds off fractional bins prior to the
%   conversion and NNFLAG = FALSE simply performs the conversion. NNFLAG =
%   FALSE is the default and F = BIN2FREQ(K,Fs,NFFT,FALSE) is equivalent to
%   F = BIN2FREQ(K,Fs,NFFT).
%
%   See also FREQ2BIN, FREQ2IND, IND2FREQ, BIN2IND, IND2BIN, MKFREQ, NYQ_FREQ

% 2016 MCaetano
% 2020 MCaetano SMT 0.1.1 (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(3,4);

% Check number of input arguments
nargoutchk(0,1);

if nargin == 3
    
    nnflag = false;
    
end

% Validate BIN
validateattributes(bin,{'numeric'},{'nonempty','finite','nonnan','real','>=',-ceil(nfft/2)+1,'<=',nfft-1},mfilename,'BIN',1)

% Validate Fs
validateattributes(fs,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'Fs',2)

% Validate NFFT
validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',3)

% Validate NNFLAG
validateattributes(nnflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NNFLAG',4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nnflag
    
    bin = round(bin);
    
end

% Conversion
freq = (bin * fs) / nfft;

end
