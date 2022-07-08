function [amp_morph,freq_morph,npartial_morph] = partial_interpolation(amp_source,freq_source,f0_source,npartial_source,...
    amp_target,freq_target,f0_target,npartial_target,nframe,nchannel,morph_factor,interpflag)
%PARTIAL_INTERPOLATION Interpolate amplitudes and frequencies of partials.
%   [A,F] = INTERP_SIN(AMP_S,FREQ_S,F0_S,NPART_S,AMP_T,FREQ_T,F0_T,
%   NPART_T,NFRAME,NCHANNEL,ALPHA,INTERPFLAG) interpolates the amplitudes
%   AMP_S and AMP_T and the frequencies FREQ_S and FREQ_T of two sets of
%   parameters resulting from the sinusoidal analysis of two sounds with
%   the function SINUSOIDAL_ANALYSIS. PARTIAL_INTERPOLATION uses the
%   number of partials P1 and P2 and the fundamental frequencies F01 and
%   F02 to interpolate unmatched partials. F is the total number of frames and
%   ALPHA is the interpolation factor varying between 0 and 1. When ALPHA=0
%   M=S and when ALPHA=1 M=T. Intermediate values of ALPHA generate M
%   between S and T. AMPFLAG is a character string that sets the scale of
%   amplitude interpolation to either 'LIN' for linear or 'LOG' for
%   logarithmic. The default is 'LOG'.

% 2019 M Caetano (SMT 0.0.1)
% 2020 MCaetano SMT 0.1.1
% 2021 M Caetano SMT
% 2022 M Caetano SMT (Rewritten)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(10,12);

% Check number of output arguments
nargoutchk(0,3);

if nargin == 11
    
    interpflag = 'log';
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose amplitude interpolation function
switch lower(interpflag)
    
    case 'lin'
        
        ampinterp = @lininterp;
        ampmin = 0;
        
    case 'log'
        
        ampinterp = @loginterp;
        ampmin = tools.math.log2lin(-120,'dbp');
        
    case 'nrg'
        
        ampinterp = @nrginterp;
        ampmin = 0;
        
    otherwise
        
        ampinterp = @loginterp;
        ampmin = tools.math.log2lin(-120,'dbp');
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EQUALIZE NUMBER OF PARTIALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

harmonic_source = tools.harm.mkharm(f0_source,max(npartial_source,npartial_target),nframe,nchannel);
harmonic_target = tools.harm.mkharm(f0_target,max(npartial_source,npartial_target),nframe,nchannel);

if npartial_source > npartial_target
    
    missing_harmonic = (npartial_target+1:npartial_source)';
    
    amp_target(missing_harmonic,:) = nan(npartial_source-npartial_target,nframe,nchannel);
    freq_target(missing_harmonic,:) = nan(npartial_source-npartial_target,nframe,nchannel);
    
elseif npartial_source < npartial_target
    
    missing_harmonic = (npartial_source+1:npartial_target)';
    
    amp_source(missing_harmonic,:,:) = nan(npartial_target-npartial_source,nframe,nchannel);
    freq_source(missing_harmonic,:,:) = nan(npartial_target-npartial_source,nframe,nchannel);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REPLACE NaN BEFORE INTERPOLATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Replace NaN to interpolate partials that only exist in one
% Keep NaN when partial is missing in both
isnan_source = isnan(amp_source);
isnan_target = isnan(amp_target);
isnan_both = isnan_source & isnan_target;

amp_source(isnan_source & ~isnan_both) = ampmin;
freq_source(isnan_source & ~isnan_both) = harmonic_source(isnan_source & ~isnan_both);

amp_target(isnan_target & ~isnan_both) = ampmin;
freq_target(isnan_target & ~isnan_both) = harmonic_target(isnan_target & ~isnan_both);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERFORM INTERPOLATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Interpolate the number of partials
npartial_morph = round(morph_factor*npartial_source+(1-morph_factor)*npartial_target);

% Interpolate amplitudes (linearly, logarithmically, or quadratically)
amp_morph = ampinterp(amp_source(1:npartial_morph,:,:),amp_target(1:npartial_morph,:,:),morph_factor);

% Interpolate frequency logarithmically (intervals in cents)
freq_morph = centinterp(freq_source(1:npartial_morph,:,:),freq_target(1:npartial_morph,:,:),morph_factor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REPLACE NaN AFTER INTERPOLATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

isnan_morph = amp_morph <= ampmin;
amp_morph(isnan_morph) = NaN;
freq_morph(isnan_morph) = NaN;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOCAL FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Interpolation in frequency cents
function morph = centinterp(source,target,morphFactor)

morph = source.*pow2((1-morphFactor).*log2(target./source));

end

% Interpolation of amplitudes
function morph = lininterp(source,target,morphFactor)

morph = morphFactor.*source + (1-morphFactor).*target;

end

% Interpolation of spectral energy
function morph = nrginterp(source,target,morphFactor)

morph = sqrt(target.^2 + morphFactor.*(source-target).*(source+target));

end

% Interpolation in decibels
function morph = loginterp(source,target,morphFactor)

morph = source.*10.^((1-morphFactor).*log10(target./source));

end
