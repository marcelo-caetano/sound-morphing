function [amp,freq,ph] = maxnumpeak(peak_amp,peak_freq,peak_ph,maxnpeak,nbin,nframe,nchannel,npeakflag)
%MAXNUMPEAK Maximum number of peaks.
%   [A,F,P] = MAXNUMPEAK(Ap,Fp,Pp,MAXNPEAK,NBIN,NFRAME,NCHANNEL) selects up
%   TO MAXNPEAK peaks per frame with the highest amplitude. Ap are the
%   amplitudes of the spectral peaks returned by PEAK_PICKING, Fp are the
%   frequencies of the spectral peaks, and Pp are the phases. Ap, Fp, and
%   Pp are NBIN x NFRAME X NCHANNEL multi-dimensional arrays, where NBIN is
%   the number of positive frequency bins, NFRAME is the number of frames,
%   and NCHANNEL is the number of channels. A, F, and P are arrays of size
%   NBIN x NFRAME x NCHANNEL with at most MAXNPEAK original peak values per
%   column and NaN filling the remaining bins.
%
%   [A,F,P] = MAXNUMPEAK(Ap,Fp,Pp,MAXNPEAK,NBIN,NFRAME,NCHANNEL,NPEAKFLAG)
%   uses the logical flag NPEAKFLAG to specify whether the output should
%   have MAXNPEAK rows instead of NBIN. NPEAKFLAG = TRUE sets A, F, and P
%   to have size MAXNPEAK x NFRAME x NCHANNEL and NPEAKFLAG = FALSE leaves
%   the size of the input untouched. The default is NPEAKFLAG = FALSE when
%   MAXNUMPEAK is called with the syntax above. Note that A, F, and P might
%   still have NaN across columns that had fewer peaks than MAXNPEAK.
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

% Sort peaks by DESCENDING amplitudes (placing NaN last)
[~,index_sorted] = sort(peak_amp,1,'descend','MissingPlacement','last');

% Get indices of MAXNPEAK peaks per frame
trunc_index = index_sorted(1:maxnpeak,:,:);

% Recover original position (ascending index == original frequency)
sort_trunc_index = sort(trunc_index,1,'ascend');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONVERT FROM SUBSCRIPT INDICES TO LINEAR INDICES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% IMPORTANT! This step is necessary to address row and column correctly
% PEAK_AMP(SORT_TRUNC_INDEX) with numerical indices requires linear
% indexing but SORT sorts each column independently and returns indices
% relative to each column (i.e., only the subscripts for the rows).

% Subscripts for the columns
colsub = repmat(1:nframe,maxnpeak,1,nchannel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PAGE SUBSCRIPTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cell array for comma separated list
ipage = num2cell(1:nchannel);

% Subscripts for the pages
pagesub = repmat(cat(3,ipage{:}),maxnpeak,nframe);

% Convert from subscript indices to linear indices
sort_trunc_linear_index = sub2ind([nbin,nframe,nchannel],sort_trunc_index,colsub,pagesub);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERFORM ASSIGNMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if npeakflag
    
    % Return MAXNPEAK amplitudes (with at most MAXNPEAK values)
    amp = peak_amp(sort_trunc_linear_index);
    
    % Return MAXNPEAK frequencies (with at most MAXNPEAK values)
    freq = peak_freq(sort_trunc_linear_index);
    
    % Return MAXNPEAK phases (with at most MAXNPEAK values)
    ph = peak_ph(sort_trunc_linear_index);
    
else
    
    % Initialize variables
    amp = nan(nbin,nframe,nchannel);
    freq = nan(nbin,nframe,nchannel);
    ph = nan(nbin,nframe,nchannel);
    
    % Return NBIN amplitudes (with at most MAXNPEAK values)
    amp(sort_trunc_linear_index) = peak_amp(sort_trunc_linear_index);
    
    % Return NBIN frequencies (with at most MAXNPEAK values)
    freq(sort_trunc_linear_index) = peak_freq(sort_trunc_linear_index);
    
    % Return NBIN phases (with at most MAXNPEAK values)
    ph(sort_trunc_linear_index) = peak_ph(sort_trunc_linear_index);
    
end

end
