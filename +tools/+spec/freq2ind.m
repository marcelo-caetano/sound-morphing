function ind = freq2ind(freq,fs,nfft)
%FREQ2IND Convert frequency in Hz to array index.
%   IND = FREQ2IND(F,Fs,NFFT) converts the frequency F in Hertz into array
%   indices IND for the sampling frequency given by Fs and 1 <= IND <= NFFT,
%   where NFFT is the size of the DFT. The DFT bins are Fs/NFFT Hertz apart,
%   so the conversion is IND = (F * NFFT)/Fs + 1.
%
%   Frequencies F between the DFT bins will result in fractional indices.
%   FREQ2IND returns "nearest neighbor" approximations so IND is integer.
%   Use FREQ2BIN for fractional bin number support.
%
%   See also IND2FREQ, FREQ2BIN, BIN2FREQ, BIN2IND, IND2BIN, MKFREQ, NYQ_FREQ

% 2020 MCaetano SMT 0.1.1
% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input argumrnts
narginchk(3,3);

% Check number of output arguments
nargoutchk(0,1);

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

% Validate Fs
validateattributes(fs,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'Fs',2)

% Validate NFFT
validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Round off fractional indices
nnflag = true;

% Convert from frequency to bin number
bin = tools.spec.freq2bin(freq,fs,nfft,nnflag);

% TRUE when bin < 0
isbinshift = bin < 0;

% Convert from bin number to array index
if any(isbinshift(:))
    
    % Shift zero-frequency bin to the center of the spectrum
    ind = tools.spec.bin2ind(bin,nfft);
    
else
    
    ind = tools.spec.bin2ind(bin);
    
end

end
