function [amplitude,frequency,phase,indmaxnpeak] = sinusoidal_parameter_estimation(fft_frame,framelen,nfft,fs,...
    nframe,nchannel,maxnpeak,winflag,paramestflag,frequnitflag,npeakflag)
%SINUSOIDAL_PARAMETER_ESTIMATION Spectral estimation of the parameters of sinusoids.
%   [A,F,P] = SINUSOIDAL_PARAMETER_ESTIMATION(FFTFR,M,NFFT,Fs,NFRAME,NCHANNEL,
%   MAXNPEAK,WINFLAG,PARAMESTFLAG) returns the amplitudes A, frequencies F,
%   and phases P of the MAXNPEAK underlying sinusoids (spectral peaks) for
%   each frame of the STFT in FFTFR.
%
%   The size of the multi-dimensional array FFTFR is M x NFFT x NCHANNEL,
%   where M is the frame length, NFFT is the size of the FFT, and NCHANNEL
%   is the number of channels. A, F, and P are size NBIN x NFRAME x NCHANNEL
%   with at most MAXNPEAK values per column and NaN filling the remaining
%   NBIN positive frequency bins. The number of peaks NPEAK in a column can
%   be NPEAK < MAXNPEAK if the frame originally had fewer than MAXNPEAK
%   values. WINFLAG is a numerical flag that determines the window used in
%   the STFT. PARAMESTFLAG is a text flag that indicates the amplitude
%   scale of the magnitude spectrum for sinusoidal parameter estimation.
%   PARAMESTFLAG can be 'NNE', 'LIN', 'LOG', or 'POW'.
%
%   [A,F,P] = SINUSOIDAL_PARAMETER_ESTIMATION(FFTFR,M,NFFT,Fs,NFRAME,NCHANNEL,
%   MAXNPEAK,WINFLAG,PARAMESTFLAG,FREQUNITFLAG) uses the logical flag
%   FREQUNITFLAG to control the unit of the frequency estimates in F.
%   FREQUNITFLAG = TRUE outputs F in Hz and FREQUNITFLAG = FALSE in
%   frequency bin number. The default is FREQUNITFLAG = TRUE for the
%   previous syntaxes.
%
%   [A,F,P] = SINUSOIDAL_PARAMETER_ESTIMATION(FFTFR,M,NFFT,Fs,NFRAME,NCHANNEL,
%   MAXNPEAK,WINFLAG,PARAMESTFLAG,FREQUNITFLAG,NPEAKFLAG) uses the logical
%   flag NPEAKFLAG to specify whether the output should have MAXNPEAK rows
%   instead of NBIN rows. NPEAKFLAG = TRUE sets A, F, and P to have size
%   MAXNPEAK x NFRAME x NCHANNEL and NPEAKFLAG = FALSE outputs NBIN rows.
%   The default is NPEAKFLAG = FALSE when MAXNUMPEAK is called with the
%   syntax above. Note that A, F, and P might still have NaN across columns
%   that had fewer peaks than MAXNPEAK.
%
%   See also SINUSOIDAL_PARTIAL_SELECTION, PARTIAL_TRACKING

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(9,11);

% Check number of output arguments
nargoutchk(0,4);

if nargin == 9
    
    frequnitflag = true;
    
    npeakflag = false;
    
elseif nargin == 10
    
    npeakflag = false;
    
end

validateattributes(fft_frame,{'numeric'},{'nonempty','finite'},mfilename,'FFRFR',1)
validateattributes(framelen,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'FRAMELEN',2)
validateattributes(nfft,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'NFFT',3)
validateattributes(fs,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'Fs',4)
validateattributes(nframe,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NFRAME',5)
validateattributes(nchannel,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NCHANNEL',6)
validateattributes(maxnpeak,{'numeric'},{'nonempty','scalar','real','positive'},mfilename,'MAXNPEAK',7)
validateattributes(winflag,{'numeric'},{'scalar','integer','nonempty','>=',1,'<=',8},mfilename,'WINFLAG',8)
validateattributes(paramestflag,{'string','char'},{'scalartext','nonempty'},mfilename,'NORMFLAG',9)
validateattributes(frequnitflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'ZPHFLAG',10)
validateattributes(npeakflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NPEAKFLAG',11)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Scale the magnitude spectrum (Linear, Log, Power)
pos_mag_spec = mag_spec_scaling(fft_frame,framelen,nfft,winflag,paramestflag);

% Unwrap the phase spectrum
pos_ph_spec = tools.fft2.fft2unwrapped_phase_spec(fft_frame,nfft,true);

% Peak picking
[amp_peak,freq_peak,ph_peak] = peak_picking(pos_mag_spec,pos_ph_spec,nfft,fs,nframe,'pos',frequnitflag);

% Estimate parameters
if strcmpi(paramestflag,'nne')
    
    % No interpolation for NNE (nearest neighbor estimation)
    amp = amp_peak.peak;
    freq = freq_peak.peak;
    ph = ph_peak.peak;
    
else
    
    % Magnitude interpolation (quadratic)
    [amp,freq] = interp_mag_spec(amp_peak,freq_peak);
    
    % Phase interpolation (linear)
    ph = interp_phase_spec(freq_peak,ph_peak,freq);
    
    % Revert magnitude spectrum scaling
    amp = revert_mag_spec_scaling(amp,framelen,winflag,paramestflag);
    
end

% Return MAXNPEAK peaks with highest energy
[amplitude,frequency,phase,indmaxnpeak] = trunc_spec_peak(amp,freq,ph,maxnpeak,nfft,nframe,nchannel,npeakflag);

end
