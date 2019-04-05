function [amplitude,frequency,phase,duration,dc,cframe] = sinusoidal_analysis_test(insig,freqs,nfft,hopsize,winlen,wintype,center,normflag,zphflag,magflag,maxnpeak,thresframe,threstotal)
%SINUSOIDAL_ANALYSIS perform sinusoidal analysis.
%   [A,F,P,L,DC,C] = SINUSOIDAL_ANALYSIS(S,FREQ,NFFT,H,M,WINTYPE,CENTER,NORMWIN,ZPH,MAG,MAXPEAK)
%   splits the input sound S into overlapping frames of length M with a hop
%   size H and returns the amplitudes A, frequencies F, and phases P of the
%   partials estimated at the frequencies defined by FREQ.
%
%   See also SINUSOIDAL_RESYNTHESIS

% M Caetano

disp('Sinusoidal Analysis')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % SHORT-TIME FOURIER TRANSFORM
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Short-Time Fourier Transform
[stftfr,duration,dc,cframe] = stft(insig,hopsize,winlen,wintype,center,nfft,normflag,zphflag);

[nframe] = size(cframe,2);

% Scale the magnitude spectrum
switch lower(magflag)
    
    case 'log'
        
        % disp('Log')
        p = 1;
        mag_spec = 20*log10(abs(stftfr(1:nfft/2+1,:)));
        
    case 'lin'
        
        % disp('Lin')
        p = 1;
        mag_spec = abs(stftfr(1:nfft/2+1,:));
        
    case 'pow'
        
        % disp('Power')
        p = xqifft(winlen,wintype);
        mag_spec = abs(stftfr(1:nfft/2+1,:)).^p;
        
    otherwise
        
        warning(['InvalidMagFlag: Invalid Magnitude Scaling Flag.\n'...
            'Flag for magnitude scaling must be LOG, LIN, or POW.\n'...
            'Using default magnitude scaling flag LOG'])
        
        mag_spec = 20*log10(abs(stftfr(1:nfft/2+1,:)));
        
end

% Unwrap the phase spectrum
phase_spec = unwrap(angle(stftfr(1:nfft/2+1,:)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS PER FRAME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Preallocate output variables
amplitude = cell(1,nframe);
frequency = cell(1,nframe);
phase = cell(1,nframe);

% Frame-by-frame sinusoidal analysis
for iframe = 1:nframe
    
    % fprintf(1,'Analyzing frame %d of %d\n',iframe,nframe);
    
    % Analize frame and return AMPLITUDE, FREQUENCY, and PHASE for MAXNPEAK peaks
    [amplitude{iframe},frequency{iframe},phase{iframe}] = ...
        sinusoidal_analysis_frame(mag_spec(:,iframe),phase_spec(:,iframe),freqs,winlen,wintype,maxnpeak,magflag,p);
    
    % Select only peaks with amplitude at most THRESFRAME dB below the maximum amplitude found in the frame
    [amplitude{iframe},frequency{iframe},phase{iframe}] = mindb(amplitude{iframe},frequency{iframe},phase{iframe},thresframe);
    
end

% Select only peaks with amplitude at most THRESTOTAL below maximum across
% all frames
maxlevel = 20*log10(max(cellfun(@max,amplitude)));

% SELECT PEAKS WITH ABSOLUTE AMPLITUDE HIGHER THAN THRESTOTAL
for iframe = 1:nframe
    
    indminfreq = 20*log10(amplitude{iframe}) < -(abs(maxlevel) + abs(threstotal));
    
    if not(isempty(amplitude{iframe}(indminfreq)))
        
        amplitude{iframe}(indminfreq) = 0;
        
    end
    
end

a=1;

end
