function [amp,freq,ph] = trunc_spec_peak(peak_amp,peak_freq,peak_ph,maxnpeak,nfft,nframe,nchannel,npeakflag)
%TRUNC_SPEC_PEAK Maximum number of peaks.
%   [A,F,P] = TRUNC_SPEC_PEAK(Ap,Fp,Pp,MAXNPEAK,NFFT,NFRAME,NCHANNEL)
%   selects up to MAXNPEAK peaks per frame with the highest amplitude Ap.
%   Fp and Pp are the corresponding frequencies and phases of the spectral
%   peaks. Ap, Fp, and Pp are NBIN x NFRAME X NCHANNEL multi-dimensional
%   arrays, where NBIN is the number of positive frequency bins, NFRAME is
%   the number of frames, and NCHANNEL is the number of channels. A, F, and
%   P are arrays of size NBIN x NFRAME x NCHANNEL with at most MAXNPEAK
%   original peak values per column and NaN filling the remaining bins.
%
%   [A,F,P] = TRUNC_SPEC_PEAK(Ap,Fp,Pp,MAXNPEAK,NFFT,NFRAME,NCHANNEL,NPEAKFLAG)
%   uses the logical flag NPEAKFLAG to specify whether the output should
%   have MAXNPEAK rows instead of NBIN rows. NPEAKFLAG = TRUE sets A, F,
%   and P to have size MAXNPEAK x NFRAME x NCHANNEL and NPEAKFLAG = FALSE
%   leaves the size of the input untouched. The default is NPEAKFLAG = FALSE
%   when MAXNUMPEAK is called with the syntax above. Note that A, F, and P
%   might still have NaN across columns that had fewer peaks than MAXNPEAK.
%
%   See also TRUNC_SPEC_PEAK, ABSDB, RELDB

% 2020 MCaetano SMT 0.1.2 (Revised)
% 2021 M Caetano SMT (Revised)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK FUNCTION INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(7,8);

% Check number of output arguments
nargoutchk(0,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 7
    
    % Flag to return NBIN rows when TRUE and MAXNPEAK rows when FALSE
    npeakflag = false;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of positive frequency bins
nbin = tools.spec.pos_freq_band(nfft);

% Inf >= integer: always TRUE
if maxnpeak >= nbin
    
    % Return the inputs
    amp = peak_amp;
    freq = peak_freq;
    ph = peak_ph;
    
else
    
    % Return only up to MAXNPEAK peaks in AMP, FREQ, and PH
    [amp,freq,ph] = tools.sin.maxnumpeak(peak_amp,peak_freq,peak_ph,maxnpeak,nbin,nframe,nchannel,npeakflag);
    
end

end
