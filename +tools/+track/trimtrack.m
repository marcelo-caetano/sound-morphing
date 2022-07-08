function [amp,freq,ph] = trimtrack(amp,freq,ph,hop,fs,npartial,nframe,nchannel,durthres,gapthres,timescaleflag)
%TRIMTRACK Trim partial track segments according to duration.
%   [A,F,P] = TRIMTRACK(A,F,P,H,Fs,NPART,NFRAME,NCHANNEL,DURTHRES,GAPTHRES,TIMESCALEFLAG)
%   only keeps the segments of partial tracks that are loger than DURTHRES
%   or that are preceded and followed by a gap shorter than GAPTHRES. A, F,
%   and P are respectively the amplitudes, frequencies, and phases of the
%   partial track segments. H is the hop size, Fs is the sampling frequency,
%   NPART is the number of partials, NFRAME is the number of frames, and
%   NCHANNEL is the number of audio channels. DURTHRESH is the minimum
%   duration threshold for partials in ms and GAPTHRES is the maximum
%   duration of gaps before and after the segments of partials to connect
%   over. DURGAP allows to keep partial track segments that are shorter
%   than DURTHRES as long as the gaps _before and after_ are shorter than
%   GAPTHRES.
%
%   See also DURTRACK, DURGAP, DUR

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(11,11);

% Check number of output arguments
nargoutchk(0,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Transpose (for "normal" column-wise operations)
amp_transp = tools.poly.pagetranspose(amp);

[dur_peak_transp,dur_prev_gap_transp,dur_next_gap_transp] = tools.track.durtrack(amp_transp,hop,fs,npartial,nframe,nchannel,timescaleflag);

% Revert transposition
dur_peak = tools.poly.pagetranspose(dur_peak_transp);
dur_next_gap = tools.poly.pagetranspose(dur_next_gap_transp);
dur_prev_gap = tools.poly.pagetranspose(dur_prev_gap_transp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Keep peaks that are loger than DURTHRES or are preceded and followed by a
% gap shorter than GAPTHRES

% Find peaks with DURPEAK < DURTHRES
bool_dur_peak = dur_peak > durthres;

% Find duration of gaps before & after peaks
bool_dur_next_gap = dur_next_gap < gapthres;
bool_dur_prev_gap = dur_prev_gap < gapthres;

% Keep peaks with DURPEAK > DURTHRES | DURGAP < GAPTHRES before & after
bool_dur = ~(bool_dur_peak | (bool_dur_next_gap & bool_dur_prev_gap));

amp(bool_dur) = nan(1);
freq(bool_dur) = nan(1);
ph(bool_dur) = nan(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
