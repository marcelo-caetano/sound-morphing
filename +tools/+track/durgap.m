function dur_gap_event = durgap(dur_gap,bool_gap,ind_peak,repeatFun,npart,nframe,nchannel,eventflag)
%DURGAP Duration of each gap before/after a segment of partial.
%   [DUR_GAP] = DURGAP(DUR,BOOL,IND,FUN,NPART,NFRAME,NCHANNEL,EVENTFLAG)
%
%   See also TRIMTRACK, DURTRACK, DUR

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(8,8);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(eventflag)
    
    case 'before'
        
        event = 1;
        
    case 'after'
        
        event = -1;
        
    otherwise
        
        error('SMT:DURGAP:InvalidArgument',...
            ['Invalid argument'...
            'EVENTFLAG must be ''BEFORE'' or ''AFTER''\n'...
            'EVENTFLAG entered was %s\n'],eventflag)
        
end

% Difference across time frames (COLUMNS)
% VAL_DIFF == +1 marks the position where the gap "is born"
% VAL_DIFF == -1 marks the positions where the gap "dies"
val_diff = diff([false(1,npart,nchannel); bool_gap; false(1,npart,nchannel)]);

% Linear indices of durations of gaps BEFORE/AFTER each peak
% NOTE: EVENTFLAG == BEFORE => EVENT == 1 => IND - 1
% NOTE: EVENTFLAG == AFTER => EVENT == -1 => IND + 1
ind_event_gap = getIndEvent(val_diff,event);

% The row with zeros is necessary to get a gap duration of 0 whenever the
% peak is the FIRST/LAST event
if strcmp(eventflag,'after')
    
    % Append 1 row with zeros
    ext_dur_gap = [dur_gap; zeros(1,npart,nchannel)];
    
elseif strcmp(eventflag,'before')
    
    % Prepend 1 row with zeros
    ext_dur_gap = [zeros(1,npart,nchannel); dur_gap];
    
end

% Vector: Duration of gap before/after each peak
dur_event_gap = ext_dur_gap(ind_event_gap);

% Vector: Durations of gaps before/after each peak repeated IND_PEAK times
dur_event_gap_rep = tools.algo.callArrayFunReturnArray(repeatFun,dur_event_gap,ind_peak);

% Assign durations of gaps to positions of peaks
dur_gap_event = nan(nframe,npart,nchannel);
dur_gap_event(bool_gap) = dur_event_gap_rep;

end

% LOCAL FUNCTION TO GET LINEAR INDEX OF EVENT
function indEventGap = getIndEvent(val,eventFlag)

% Move FIRST/LAST row to position BEFORE/AFTER
eventShift = circshift(val,eventFlag);

indEvent = find(eventShift == eventFlag);

indEventGap = indEvent - eventFlag;

end
