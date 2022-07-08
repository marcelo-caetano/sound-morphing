function dftwin = mkwin(binfreq,binamp,binph,binrange,binspan,framelen,nfft,winflag,posfreqflag,realsigflag,normflag,zphflag)
%MKDFTWIN Make the DFT of a window modulated by a stationary sinusoid.
%   W = MKDFTWIN(F,A,P,RANGE,FRAMELEN,NFFT,WINFLAG,POSFREQFLAG,REALSIGFLAG,NORFLAG,ZPHFLAG)
%   makes the DFT of a window modulated by a sinusoid with frequency F,
%   amplitude A, and initial phase P. FRAMELEN is the length of the
%   window W in samples and NFFT is the size of the DFT. The numerical
%   flag WINFLAG specifies the window type. The possibilities for
%   WINFLAG are:
%
%   1 - Rectangular
%   2 - Bartlett
%   3 - Hann
%   4 - Hanning
%   5 - Blackman
%   6 - Blackman-Harris
%   7 - Hamming
%   8 - Bartlett-Hann
%   9 - Gaussian
%   10 - Slepian
%   11 - Kaiser-Bessel
%   12 - Nuttall
%   13 - Dolph-Chebychev
%   14 - Tukey
%
%   POSFREQFLAG is a logical flag that specifies if the modulating sinusoid
%   has positive or negative frequency. POSFREQFLAG = TRUE for positive
%   frequency and POSFREQFLAG = FALSE for negative frequency.
%
%   REALSIGFLAG is a logical flag that specifies if the modulating sinusoid
%   is real or complex. REALSIGFLAG = TRUE for real and REALSIGFLAG = FALSE
%   for complex. The value of POSFREQFLAG is ignored when REALSIGFLAG = TRUE
%   because real signals have both positive and negative frequency
%   components.
%
%   NORMFLAG is a logical flag that determines if W is normalized. Use
%   NORMFLAG = TRUE for normalized and NORMFLAG = FALSE for non-normalized.
%
%   ZPHFLAG is a logical flag that determines if W is zero-phase. Use
%   ZPHFLAG = TRUE for zero-phase and ZPHFLAG = FALSE for linear phase.
%
%   The window W is carefully designed to ensure that the center of W is
%   an integer sample number. Even FRAMELEN results in periodic windows,
%   whereas odd FRAMELEN results in symmetric windows. See the help for
%   each window given by WINFLAG for further information.
%
%   See also RECTWIN, HANNWIN, HAMMINGWIN, BLACKMANWIN, BLACKMANHARRISWIN

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(12,12);

% Check number of output arguments
nargoutchk(0,1);

validateattributes(binfreq,{'numeric'},{'3d','nonempty','real','nonnegative'},mfilename,'BINFREQ',1)
validateattributes(binamp,{'numeric'},{'3d','nonempty','real','nonnegative'},mfilename,'BINAMP',2)
validateattributes(binph,{'numeric'},{'3d','nonempty','real'},mfilename,'BINPH',3)
validateattributes(binrange,{'numeric'},{'real'},mfilename,'BINRANGE',4)
validateattributes(binspan,{'numeric'},{'scalar','integer','real'},mfilename,'BINSPAN',5)
validateattributes(framelen,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'FRAMELEN',6)
validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',7)
validateattributes(winflag,{'numeric'},{'scalar','integer','nonempty','>=',1,'<=',8},mfilename,'WINFLAG',8)
validateattributes(posfreqflag,{'numeric','logical'},{'nonempty','scalar','finite','nonnan','binary'},mfilename,'POSFREQFLAG',9)
validateattributes(realsigflag,{'numeric','logical'},{'nonempty','scalar','finite','nonnan','binary'},mfilename,'REALSIGFLAG',10)
validateattributes(normflag,{'numeric','logical'},{'nonempty','scalar','finite','nonnan','binary'},mfilename,'NORMFLAG',11)
validateattributes(zphflag,{'numeric','logical'},{'nonempty','scalar','finite','nonnan','binary'},mfilename,'ZPHFLAG',12)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Phase advance to the center of the window (~=0 for zero phase window)
phadv = tools.dft.ph_advance(binfreq,framelen,nfft,zphflag);

base = tools.psel.mkbinrange(binrange(:,:,:,1),binrange(:,:,:,2),binspan);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POSITIVE FREQUENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bin.pos = base - binfreq;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEGATIVE FREQUENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bin.neg = base - (nfft - binfreq);

switch winflag
    
    % RECTANGULAR
    case 1
        
        mag = tools.dft.rect(bin,framelen,nfft,normflag,zphflag);
        
        % BARTLETT
    case 2
        
        warning('SMT:MKDFTWIN:ToBeImplemented',...
            ['Window to be implemented\n'...
            'WINFLAG = %d corresponds to ' upper(tools.dsp.infowin(winflag))...
            ' window which will be implemented soon.\n'...
            'Using default HANN window instead.\n'],...
            winflag);
        
        mag = tools.dft.hann(bin,framelen,nfft,normflag,zphflag);
        
        % HANN
    case 3
        
        mag = tools.dft.hann(bin,framelen,nfft,normflag,zphflag);
        
        % HANNING
    case 4
        
        warning('SMT:MKDFTWIN:ToBeImplemented',...
            ['Window to be implemented\n'...
            'WINFLAG = %d corresponds to ' upper(tools.dsp.infowin(winflag))...
            ' window which will be implemented soon.\n'...
            'Using default HANN window instead.\n'],...
            winflag);
        
        mag = tools.dft.hann(bin,framelen,nfft,normflag,zphflag);
        
        % BLACKMAN
    case 5
        
        mag = tools.dft.blackman(bin,framelen,nfft,normflag,zphflag);
        
        % BLACKMAN-HARRIS
    case 6
        
        mag = tools.dft.blackmanharris(bin,framelen,nfft,normflag,zphflag);
        
        % HAMMING
    case 7
        
        mag = tools.dft.hamming(bin,framelen,nfft,normflag,zphflag);
        
        % BARTLETT-HANN
    case 8
        
        warning('SMT:MKDFTWIN:ToBeImplemented',...
            ['Window to be implemented\n'...
            'WINFLAG = %d corresponds to ' upper(tools.dsp.infowin(winflag))...
            ' window which will be implemented soon.\n'...
            'Using default HANN window instead.\n'],...
            winflag);
        
        mag = tools.dft.hann(bin,framelen,nfft,normflag,zphflag);
        
        % GAUSSIAN
    case 9
        
        warning('SMT:MKDFTWIN:ToBeImplemented',...
            ['Window to be implemented\n'...
            'WINFLAG = %d corresponds to ' upper(tools.dsp.infowin(winflag))...
            ' window which will be implemented soon.\n'...
            'Using default HANN window instead.\n'],...
            winflag);
        
        mag = tools.dft.hann(bin,framelen,nfft,normflag,zphflag);
        
        % SLEPIAN
    case 10
        
        warning('SMT:MKDFTWIN:NoAnalyticDFT',...
            ['Selected window has no analytic DFT\n'...
            'WINFLAG = %d corresponds to ' upper(tools.dsp.infowin(winflag))...
            ' window which has no known analytical DFT formula.\n'...
            'Using default HANN window instead.\n'],...
            winflag);
        
        mag = tools.dft.hann(bin,framelen,nfft,normflag,zphflag);
        
        % KAISER-BESSEL
    case 11
        
        warning('SMT:MKDFTWIN:ToBeImplemented',...
            ['Window to be implemented\n'...
            'WINFLAG = %d corresponds to ' upper(tools.dsp.infowin(winflag))...
            ' window which will be implemented soon.\n'...
            'Using default HANN window instead.\n'],...
            winflag);
        
        mag = tools.dft.hann(bin,framelen,nfft,normflag,zphflag);
        
        % NUTTALL
    case 12
        
        warning('SMT:MKDFTWIN:ToBeImplemented',...
            ['Window to be implemented\n'...
            'WINFLAG = %d corresponds to ' upper(tools.dsp.infowin(winflag))...
            ' window which will be implemented soon.\n'...
            'Using default HANN window instead.\n'],...
            winflag);
        
        mag = tools.dft.hann(bin,framelen,nfft,normflag,zphflag);
        
        % DOLPH-CHEBYCHEV
    case 13
        
        warning('SMT:MKDFTWIN:ToBeImplemented',...
            ['Window to be implemented\n'...
            'WINFLAG = %d corresponds to ' upper(tools.dsp.infowin(winflag))...
            ' window which will be implemented soon.\n'...
            'Using default HANN window instead.\n'],...
            winflag);
        
        mag = tools.dft.hann(bin,framelen,nfft,normflag,zphflag);
        
        % TUKEY
    case 14
        
        warning('SMT:MKDFTWIN:ToBeImplemented',...
            ['Window to be implemented\n'...
            'WINFLAG = %d corresponds to ' upper(tools.dsp.infowin(winflag))...
            ' window which will be implemented soon.\n'...
            'Using default HANN window instead.\n'],...
            winflag);
        
        mag = tools.dft.hann(bin,framelen,nfft,normflag,zphflag);
        
end

% Phase
ph.pos = tools.dft.init_ph(-(binph+phadv));
ph.neg = conj(ph.pos);

pos = ph.pos.*mag.pos;

neg = ph.neg.*mag.neg;

if realsigflag
    
    % Magnitude
    dftwin = (binamp/2).*(pos + neg);
    
    % Positive frequencies
elseif posfreqflag
    
    % DFT of rectangular window
    dftwin = binamp.*pos;
    
    % Negative frequencies
else
    
    % DFT of rectangular window
    dftwin = binamp.*neg;
    
end

end
