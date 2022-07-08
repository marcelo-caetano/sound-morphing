function [dur_peak,dur_prev_gap,dur_next_gap] = durtrack(amp_transp,hop,fs,npart,nframe,nchannel,timescaleflag)
%DURPART Duration of segments of partial tracks and of gaps before and after.
%   [PEAK,PREV_GAP,NEXT_GAP] = DURTRACK(PART,H,Fs,NPART,NFRAME,NCHANNEL,TIMEFLAG)
%
%   See also TRIMTRACK, DURGAP, DUR

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
narginchk(6,7)

nargoutchk(0,3)

if nargin == 6
    
    timescaleflag = 'frame';
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(timescaleflag)
    
    case 'frame'
        
        hopsize = 1;
        timeflag = false;
        timemult = 1;
        
    case 'hop'
        
        hopsize = hop;
        timeflag = false;
        timemult = 1;
        
    case 's'
        
        hopsize = hop;
        timeflag = true;
        timemult = 1;
        
    case 'ms'
        
        hopsize = hop;
        timeflag = true;
        timemult = 1e3;
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REPEATFUN(X,N): Anonymous function that repeats N times the quantity X
repeatFun = @(x,n) x*ones(n,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NaN means that no peak is present at the frequency bin
% NaN only present in the beginning until BIRTH == 0
% bool_attack_transp = isnan(amp_transp);
% dur_attack_transp = tools.track.dur(bool_attack_transp,repeatFun,npart,nframe,nchannel);

% 0 means that a peak died or was/will be born
% 0 indicates gaps in the partial track
% DUR_GAP has the durations at positions corresponding to BOOL_GAP
bool_gap_transp = amp_transp == 0;
dur_gap = tools.track.dur(bool_gap_transp,repeatFun,npart,nframe,nchannel);

% Neither 0 nor NaN means that there is a peak at the frequency bin
% DUR_PEAK has the durations at positions corresponding to BOOL_PEAK
bool_peak_transp = amp_transp > 0;
[dur_peak,ind_peak] = tools.track.dur(bool_peak_transp,repeatFun,npart,nframe,nchannel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find duration of gaps BEFORE each peak
% DUR_PREV_GAP has the durations of the gaps before each peak segment at
% the positions corresponding to BOOL_PEAK
dur_prev_gap = tools.track.durgap(dur_gap,bool_peak_transp,ind_peak,repeatFun,npart,nframe,nchannel,'before');

% Find duration of gaps AFTER each peak
% DUR_NEXT_GAP has the durations of the gaps after each peak segment at
% the positions corresponding to BOOL_PEAK
dur_next_gap = tools.track.durgap(dur_gap,bool_peak_transp,ind_peak,repeatFun,npart,nframe,nchannel,'after');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Apply HOP (except for TIMESCALEFLAG == 'FRAME')
dur_peak = hopsize*dur_peak;
dur_prev_gap = hopsize*dur_prev_gap;
dur_next_gap = hopsize*dur_next_gap;

% Return in s or ms
if timeflag
    
    dur_prev_gap = timemult*dur_prev_gap/fs;
    dur_next_gap = timemult*dur_next_gap/fs;
    dur_peak = timemult*dur_peak/fs;
    
end

end
