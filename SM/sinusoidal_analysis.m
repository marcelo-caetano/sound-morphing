function [amplitude,frequency,phase,nsample,dc,cframe] = sinusoidal_analysis(sig,hopsize,framesize,wintype,nfft,fs,cfwflag,normflag,zphflag,magflag,maxnpeak,thresframe,threstotal,dispflag)
%SINUSOIDAL_ANALYSIS perform sinusoidal analysis.
%   [A,F,P,L,DC,C] = SINUSOIDAL_ANALYSIS(S,H,M,WINTYPE,NFFT,FS,CFWFLAG,NORMFLAG,ZPHFLAG,MAGFLAG,MAXNPEAK,THRESFRAME,THRESTOTAL)
%   splits the input sound S into overlapping frames of length M with a hop
%   size H and returns the amplitudes A, frequencies F, and phases P of the
%   partials estimated at the frequencies defined by FREQ.
%
%   See also SINUSOIDAL_RESYNTHESIS

% 2016 M Caetano; Revised 2019

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number if input arguments
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
[fft_frame,nsample,dc,cframe] = stft(sig,hopsize,framesize,wintype,nfft,cfwflag,normflag,zphflag);

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
        mindb(amplitude{iframe},frequency{iframe},phase{iframe},thresframe);
    
end

% Select peaks with amplitude at most THRESTOTAL below maximum across frames
maxlevel = 20*log10(max(cellfun(@max,amplitude)));

% SELECT PEAKS WITH ABSOLUTE AMPLITUDE HIGHER THAN THRESTOTAL
for iframe = 1:nframe
    
    indminfreq = 20*log10(amplitude{iframe}) < -(abs(maxlevel) + abs(threstotal));
    
    if not(isempty(amplitude{iframe}(indminfreq)))
        
        amplitude{iframe}(indminfreq) = 0;
        
    end
    
end

end
