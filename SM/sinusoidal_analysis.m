function [amplitude,frequency,phase,nsample,dc,cframe] = ...
    sinusoidal_analysis(sig,hopsize,framesize,wintype,nfft,fs,maxnpeak,...
    thresfr,threstot,cfwflag,normflag,zphflag,magflag,dispflag)
%SINUSOIDAL_ANALYSIS perform sinusoidal analysis [1].
%   [A,F,P,L,DC,C] = SINUSOIDAL_ANALYSIS(S,H,M,WINTYPE,NFFT,FS,MAXNPEAK,THRESFRAME,THRESTOTAL,CFWFLAG,NORMFLAG,ZPHFLAG,MAGFLAG,DISPFLAG)
%   splits the input sound S into overlapping frames of length M with a hop
%   size H and returns the amplitudes A, frequencies F, and phases P of the
%   partials assumed to be the MAXNPEAK peaks with maximum power spectral 
%   amplitude.
%
%   See also SINUSOIDAL_RESYNTHESIS
% 
% [1] McAulay and Quatieri (1986) Speech Analysis/Synthesis Based on a 
% Sinusoidal Representation, IEEE TRANSACTIONS ON ACOUSTICS, SPEECH,
% AND SIGNAL PROCESSING, VOL. ASSP-34, NO. 4.

% 2016 M Caetano;
% Revised 2019 SMT 0.1.1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(13,14);

if nargin == 13
    
    dispflag = 's';
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Sinusoidal Analysis')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % SHORT-TIME FOURIER TRANSFORM
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Short-Time Fourier Transform
[fft_frame,nsample,dc,cframe] = smt_stft(sig,hopsize,framesize,wintype,nfft,cfwflag,normflag,zphflag);

% Number of frames
[nframe] = size(cframe,2);

% Scale the magnitude spectrum (Linear, Log, Power)
[mag_spec,p] = scale_magspec(abs(fft_frame(1:nfft/2+1,:)),framesize,wintype,magflag);

% Unwrap the phase spectrum
phase_spec = unwrap(angle(fft_frame(1:nfft/2+1,:)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS PER FRAME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Preallocate output variables
amplitude = cell(1,nframe);
frequency = cell(1,nframe);
phase = cell(1,nframe);

% Frame-by-frame sinusoidal analysis
for iframe = 1:nframe
    
    if strcmpi(dispflag,'v')
        
        fprintf(1,'Analyzing frame %d of %d\n',iframe,nframe);
        
    end
    
    % Analize frame and return AMPLITUDE, FREQUENCY, and PHASE for MAXNPEAK peaks
    [amplitude{iframe},frequency{iframe},phase{iframe}] = ...
        sinusoidal_analysis_frame(mag_spec(:,iframe),phase_spec(:,iframe),nfft,fs,maxnpeak,magflag,p);
    
    % Select only peaks with amplitude at most THRESFRAME dB below the maximum amplitude found in the frame
    [amplitude{iframe},frequency{iframe},phase{iframe}] = ...
        mindb(amplitude{iframe},frequency{iframe},phase{iframe},thresfr);
    
end

% Select peaks with amplitude at most THRESTOTAL below maximum across frames
maxlevel = 20*log10(max(cellfun(@max,amplitude)));

% SELECT PEAKS WITH ABSOLUTE AMPLITUDE HIGHER THAN THRESTOTAL
for iframe = 1:nframe
    
    indminfreq = 20*log10(amplitude{iframe}) < -(abs(maxlevel) + abs(threstot));
    
    if not(isempty(amplitude{iframe}(indminfreq)))
        
        amplitude{iframe}(indminfreq) = 0;
        
    end
    
end

end
