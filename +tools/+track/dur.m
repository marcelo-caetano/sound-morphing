function [dur_seq,ind_dur] = dur(bool_seq,fun,npart,nframe,nchannel)
%DUR Duration of consecutive sequences of non-zero elements.
%   [DUR,IND] = DUR(BOOL,FUN,NPART,NFRAME,NCHANNEL)
%
%   See also TRIMTRACK, DURTRACK, DURGAP, DUR

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(5,5);

% Check number of output arguments
nargoutchk(0,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Difference across time frames (COLUMNS)
val_diff = diff([false(1,npart,nchannel); bool_seq; false(1,npart,nchannel)]);

% VAL_DIFF == +1 marks the position where the partial "is born"
ind_birth = getLinearIndexEvent(val_diff,1);

% VAL_DIFF == -1 marks the positions where the partial "dies"
ind_death = getLinearIndexEvent(val_diff,-1);

% Duration of each partial from BIRTH to DEATH
ind_dur = ind_death - ind_birth;

% Repeat IND_DUR times each value in vector IND_DUR
dur_vec = tools.algo.callArrayFunReturnArray(fun,ind_dur,ind_dur);

% Assign to positions of original sequences
dur_seq = nan(nframe,npart,nchannel);
dur_seq(bool_seq) = dur_vec;

end

% LOCAL FUNCTION TO RETURN LINEAR INDICES WHERE VAL == EVENTFLAG
function indEvent = getLinearIndexEvent(val,eventFlag)

boolEvent = val == eventFlag;

indEvent = find(boolEvent);

end
