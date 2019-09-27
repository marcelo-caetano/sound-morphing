function f = genfreq(nfft,fs,freqlimflag,frequnitflag)
%GENFREQ Generate frequency vector in bins or in hertz.
%   F = GENFREQ(NFFT,SR,FLIMFLAG,FUNITFLAG) generates a frequency vector
%   F in bins or in Hertz. The flags FLIMFLAG and FUNITFLAG control
%   respectively the limits of the frequency axis and the final units.
%
%   FLIMFLAG is one of the following strings: POS, FULL, NEGPOS.
%   FLIMFLAG = 'POS' generates frequencies from 0 to Nyquist. Use 'POS' to
%   get the positive half of the spectrum.
%   FLIMFLAG = 'FULL' generates frequencies from 0 to NFFT. Use 'FULL' to
%   get the full frequency range output by the FFT.
%   FLIMFLAG = 'NEGPOS' generates the negative and positive halves. Use
%   'NEGPOS' to get the full frequency range with the zero-frequency
%   component in the middle of the spectrum. Use FFTSHIFT to plot the
%   spectrum.
%
%   FUNITFLAG is a logical value that determines the unit of the frequency
%   vector. FUNITFLAG = TRUE outpouts frequencies in Hertz and FUNITFLAG =
%   FALSE outputs frequencies in bins of the FFT.

% M Caetano

if rem(nfft,2) ~= 0
    
    error('Size of DFT must be a power of 2');
    
end

switch lower(freqlimflag)
    
    case 'pos'
        
        samples = (1:nfft/2+1)';
        
    case 'full'
        
        samples = (1:nfft)';
        
    case 'negpos'
        
        samples = (-nfft/2+2:nfft/2+1)';
        
    otherwise
        
        samples = (1:nfft)';
        
end

if frequnitflag
    
    f = bin2freq(samples-1,fs,nfft);
    
else
    
    f = samples-1;
    
end

end