function [harmonic_number,ind_harm_part,nharm] = harm_peak_sel(dist_mat,max_harm_num,npart,nframe,nchannel,max_harm_dev)
%HARM_PEAK_SEL Harmonic selection of spectral peaks.
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


narginchk(5,6)
nargoutchk(0,3)

if nargin == 5
    
    max_harm_dev = 100;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 1: DECIDE WHICH PARTIAL IS HARMONIC AND WHICH IS SPURIOUS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MINIMUM DISTANCE ACROSS ROWS GIVES WHICH PARTIAL IS CLOSEST TO EACH
% HARMONIC
% IND_PARTIAL IS THE COLUMN CORRESPONDING TO THE PARTIAL
[min_dist_harm2part,sub_ind_partial] = min(dist_mat,[],2,'omitnan');

% Convert to linear indices of size MAX_HARM_NUM x NFRAME x NCHANNEL to
% access all the pages corresponding to the original frames
% IMPORTANT! LIN_IND_PARTIAL is used to index FREQ_PART to select the
% harmonic partials
lin_ind_partial = sub2ind([npart nframe nchannel],sub_ind_partial,...
    permute(repmat([1:nframe],max_harm_num,1,nchannel),[1 4 2 3]),...
    permute(permute([1:nchannel],[1 3 2]).*ones(max_harm_num,nframe),[1 4 2 3]));

% SELECTING THE DISTANCES BELOW THE THRESHOLD WILL GIVE TRUE ONLY FOR THE
% PEAKS THAT ARE (CLOSE TO) HARMONIC
is_below_thresh = min_dist_harm2part <= max_harm_dev;

% LINEAR INDEX OF PARTIALS THAT ARE HARMONIC
ind_harm_part = lin_ind_partial(is_below_thresh);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 2: CHECK WHICH HARMONICS ARE PRESENT AMONG PARTIALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MINIMUM DISTANCE ACROSS COLUMNS GIVES WHICH HARMONIC IS CLOSEST TO EACH
% PARTIAL
% SUB_IND_HARMONIC is the row corresponding to the harmonic, i.e. the
% harmonic number
[~,sub_ind_harm] = min(dist_mat,[],1,'omitnan');

% Convert to linear indices of size MAX_HARM_NUM x NFRAME x NCHANNEL
lin_ind_harm = sub2ind([max_harm_num nframe nchannel],sub_ind_harm,...
    permute(repmat([1:nframe]',1,npart,nchannel),[4 2 1 3]),...
    permute(permute([1:nchannel],[1 3 2]).*ones(nframe,npart),[4 2 1 3]));

% SELECT ONLY PARTIALS THAT ARE HARMONIC TO GET THE LINEAR INDEX OF THE
% HARMONICS PRESENT AMONG THE PARTIALS
% HARMONIC_NUMBER is the linear index of the harmonics in FREQ_PART
harmonic_number = lin_ind_harm(ind_harm_part);

% The highest harmonic number is the number of harmonics
[nharm,~,~] = ind2sub([max_harm_num nframe nchannel],max(sub_ind_harm(:)));

end
