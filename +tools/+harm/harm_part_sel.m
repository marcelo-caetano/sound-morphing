function [is_active_harm,is_harm_part,maxnharm] = harm_part_sel(dist_mat,freq_part,max_harm_num,npart,nframe,nchannel,...
    max_harm_dev,harm_thresh,harmpartflag)
%HARM_PART_SEL Harmonic selection of partial tracks.
%   [H,P,MAXNHARM] = HARM_PART_SEL(D,F,MAX_HARM_NUM,NPART,NFRAME,NCHANNEL,
%   MAX_HARM_DEV,HARM_THRESH,HARMPARTFLAG) returns the _active harmonics_ H
%   and the partial tracks that are harmonic P. Both H and P are arrays of
%   logicals. The _active harmonics_ are the harmonic numbers that have
%   partial tracks within HARM_THRESH of the harmonic template. D is the
%   distance between the harmonic template and the partial tracks, F is the
%   frequencies of the partials, MAX_HARM_NUM is the highest harmonic
%   number in F, NPART is the number of partials, NFRAME is the number of
%   frames, and NCHANNEL is the number of channels.
%
%   [H,P,MAXNHARM] = HARM_PART_SEL(D,F,MAX_HARM_NUM,NPART,NFRAME,NCHANNEL,
%   MAX_HARM_DEV) uses MAX_HARM_DEV as the maximum harmonic deviation in
%   cents to consider a frequency peak as harmonic. The default is
%   MAX_HARM_DEV = 100.
%
%   [H,P,MAXNHARM] = HARM_PART_SEL(D,F,MAX_HARM_NUM,NPART,NFRAME,NCHANNEL,
%   MAX_HARM_DEV,HARM_THRESH) uses HARM_THRESH as the normalized harmonic
%   threshold. HARM_THRESH = 0 will select all partials regardless of 
%   MAX_HARM_DEV. HARM_THRESH = 1 will only select partials that have 100% 
%   of the frequency peaks within MAX_HARM_DEV. Ideally, HARM_THRESH should
%   allow for a small percentage of the frequency values to be outside of
%   MAX_HARM_DEV. The default is HARM_THRESH = 0.8.
%
%   [H,P,MAXNHARM] = HARM_PART_SEL(D,F,MAX_HARM_NUM,NPART,NFRAME,NCHANNEL,
%   MAX_HARM_DEV,HARM_THRESH,HARMPARTFLAG) uses HARMPARTFLAG to select the
%   algorithm to resolve conflicts in harmonic selection. HARMPARTFLAG =
%   'COUNT' selects the partials with the highest relative number of
%   harmonic peaks across all frames and HARMPARTFLAG = 'MEAN' selects the 
%   partials with the smallest average harmonic distance across all frames.
%
%    See also HARM_PEAK_SEL, HARMONIC SELECTION

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


narginchk(6,9)
nargoutchk(0,3)

if nargin == 6
    
    max_harm_dev = 100;
    harm_thresh = 0.8;
    harmpartflag = 'count';
    
elseif nargin == 7
    
    harm_thresh = 0.8;
    harmpartflag = 'count';
    
elseif nargin == 8
    
    harmpartflag = 'count';
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ALGORITHMIC STEPS
%
% Each partial track may have active (F) and inactive (NaN) peaks
%
% Spectral peaks are compared to a harmonic grid
%
% Spectral peaks whose harmonic deviation from the grid is smaller than
% MAX_HARM_DEV are considered to be harmonic
%
% Each partial track is given a _harmonic score_ calculated as follows
% HARM_SCORE = NHARM_PEAK/NACTIVE_PEAK
%
% Partial tracks whose HARM_SCORE >= HARM_THRESH are considered to be
% _harmonic_
%
% Potential conflicts (more than one partial track assigned to the same
% harmonic) are resolved
%
% Harmonic partial tracks are assigned to the corresponding harmonic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 1: DECIDE WHICH PARTIAL TRACK IS HARMONIC AND WHICH IS SPURIOUS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SELECTING THE DISTANCES BELOW THE THRESHOLD WILL GIVE TRUE ONLY FOR THE
% PEAKS THAT ARE WITHIN THE MAXIMUM HARMONIC DEVIATION
% NPART x NPART x NFRAME x NCHANNEL
is_dist_below_thresh = dist_mat <= max_harm_dev;

% Number of harmonic peaks per partial track
% NPART x NPART x NCHANNEL
nharm_peak = permute(sum(is_dist_below_thresh,3),[1 2 4 3]);

% Each partial track may have active (F) and inactive (NaN) peaks
% Number of active peaks per partial track repeated for all harmonics
% NOTE: Simply repeat the number of active peaks per partial track for
% all harmonics because NHARM_PEAK_PART_TRACK contains 0 where no harmonic
% peaks are present, resulting in the right HARM_SCORE
nactive_peak = repmat(permute(sum(~isnan(freq_part),2),[2 1 3]),max_harm_num,1);

% HARM_SCORE: Relative number of harmonic peaks in a partial track
% NPART x NPART x NCHANNEL
harm_score = nharm_peak./nactive_peak;

% COLUMN NUMBER: which partial is harmonic
% ROW NUMBER: which harmonic is present
% Repetitions in ROWS indicate that more than one partial track is below
% MAX_HARM_DEV for the harmonic ROW
% Repetitions in COLUMNS indicate that the partial track COL is below
% MAX_HARM_DEV for more than one harmonic
% NPART x NPART x NCHANNEL
is_above_harm_thresh = harm_score >= harm_thresh;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 2: RESOLVE CONFLICTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch harmpartflag
    
    case 'count'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % RESOLVE CONFLICTING PARTIALS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % There are conflicting partials whe more than one column is TRUE
        % in a single row of IS_ABOVE_HARM_THRESH
        
        lin_ind_part = selHighNumHarmPeak(2,npart,false);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % RESOLVE CONFLICTING HARMONICS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % There are conflicting harmonics when more than one row is TRUE in
        % a single column of IS_ABOVE_HARM_THRESH
        
        lin_ind_harm = selHighNumHarmPeak(1,max_harm_num,true);
        
    case 'mean'
        
        % Average distance d(H,F) across frames
        av_harm_dist = mean(dist_mat,3,'omitnan');
        
        % Minimum across rows gives which partial is closest to each harmonic
        [~,lin_ind_part] = min(av_harm_dist,[],2,'omitnan','linear');
        
        % Minimum across columns gives which harmonic is closest to each
        % peak
        [~,lin_ind_harm] = min(av_harm_dist,[],1,'omitnan','linear');
        
end

is_max_harm = false(max_harm_num,npart,nchannel);
is_max_part = false(max_harm_num,npart,nchannel);

% NOTE: LIND_IND_HARM is size NPART x 1 x 1 x NCHANNEL, whereas
% IS_MAX_REL_HARM is size NPART NPART NCHANNEL, requiring the
% conversion LIN_IND_HARM(:) when NCHANNEL > 1
is_max_harm(lin_ind_part(:)) = true;
is_max_part(lin_ind_harm(:)) = true;

% TRUE at row (harmonic), column (partial), and page (frame)
is_harm = is_above_harm_thresh & is_max_harm & is_max_part;

% ANY across columns gives which partial is harmonic
is_harm_part = repmat(permute(any(is_harm),[2 1 3]),1,nframe);

% ANY across rows gives which harmonic is active (i.e., there is a partial
% close to that harmonic)
is_active_harm = repmat(any(is_harm,2),1,nframe);

% Linear indices of active harmonics
harmonic_number = find(is_active_harm,1,'last');

% The highest harmonic number (row subscript) is the maximum number of
% harmonics present
[maxnharm,~,~] = ind2sub([max_harm_num,nframe,nchannel],harmonic_number(end));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NESTED FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select by highest number of harmonic peaks per track
    function lin_ind = selHighNumHarmPeak(dim,num,permflag)
        
        % Minimum across rows gives which partial is closest to each
        % harmonic for each frame
        % Minimum across columns gives which harmonic is closest to each
        % partial for each frame
        % SUB_IND is the row corresponding to the closest harmonic
        % number or the column corresponding to the closest partial
        [~,sub_ind] = min(dist_mat,[],dim,'omitnan');
        
        if permflag
            ind = (1:num)';
        else
            ind = 1:num;
        end
        
        % TRUE in the column corresponding to the peak closest to each
        % harmonic number (rows) for each frame (page). For example, TRUE
        % in 3rd column, 2nd row, 5th page means that the 3rd partial is
        % closest to the 2nd harmonic in the 5th frame
        is_closest = sub_ind==ind;
        
        % Each position (H,F) contains the number of times the partial
        % track F (column) is closest to the harmonic H (row) across frames
        % For example: (1,2) == 3 means that the 2nd partial was closest to
        % the 1st harmonic 3 times
        % NOTE: sum(,2) == nframe
        ntrack_closest = sum(is_closest & ~isnan(dist_mat),3);
        
        % Maximum across rows gives which column (partial track) has the
        % most peaks closest to each harmonic (rows)
        % Maximum across columns gives which row (harmonic) has the
        % most peaks closest to each partial track (column)
        [~,lin_ind] = max(ntrack_closest,[],dim,'omitnan','linear');
        
    end

end
