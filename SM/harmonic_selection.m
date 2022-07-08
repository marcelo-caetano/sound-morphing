function [harm_amp,harm_freq,harm_ph,maxnharm,inharm] = harmonic_selection(amp_part,freq_part,ph_part,npart,nframe,nchannel,f0,...
    max_harm_dev,harm_thresh,harmalgflag,harmpartflag,tvarf0flag)
%HARMONIC_SELECTION Selection of harmonic partials.
%   [Ah,Fh,Ph] = HARMONIC_SELECTION(A,F,P,NPART,NFRAME,NCHANNEL,F0,
%   MAX_HARM_DEV,HARM_THRESH,HARMPARTFLAG) returns the harmonic amplitudes
%   Ah, harmonic frequencies Fh, and harmonic phases Ph of the partial
%   track amplitudes A, frequencies F, and phases P. NPART is the number of
%   partials, NFRAME is the number of frames, NCHANNEL is the number of
%   channels, and F0 is the reference fundamental frequency.
%
%   [Ah,Fh,Ph] = HARMONIC_SELECTION(A,F,P,NPART,NFRAME,NCHANNEL,F0,
%   MAX_HARM_DEV) uses MAX_HARM_DEV as the maximum harmonic deviation in
%   cents to consider a frequency peak as harmonic. The default is
%   MAX_HARM_DEV = 100.
%
%   [Ah,Fh,Ph] = HARMONIC_SELECTION(A,F,P,NPART,NFRAME,NCHANNEL,F0,
%   MAX_HARM_DEV,HARM_THRESH) uses HARM_THRESH as the normalized harmonic
%   threshold. HARM_THRESH = 0 will select all partials regardless of
%   MAX_HARM_DEV. HARM_THRESH = 1 will only select partials that have 100%
%   of the frequency peaks within MAX_HARM_DEV. Ideally, HARM_THRESH should
%   allow for a small percentage of the frequency values to be outside of
%   MAX_HARM_DEV. The default is HARM_THRESH = 0.8.
%
%   [Ah,Fh,Ph] = HARMONIC_SELECTION(A,F,P,NPART,NFRAME,NCHANNEL,F0,
%   MAX_HARM_DEV,HARM_THRESH,HARMPARTFLAG) uses HARMPARTFLAG to select the
%   algorithm to resolve conflicts in harmonic selection. HARMPARTFLAG =
%   'COUNT' selects the partials with the highest relative number of
%   harmonic peaks across all frames and HARMPARTFLAG = 'MEAN' selects the
%   partials with the smallest average harmonic distance across all frames.
%
%   [Ah,Fh,Ph,MAXNHARM] = HARMONIC_SELECTION(_) also returns the highest
%   harmonic number MAXNHARM. Note that MAXNHARM is not necessarily the
%   number of active harmonics since there may be missing harmonics.
%
%   [Ah,Fh,Ph,MAXNHARM,INHARM] = HARMONIC_SELECTION(_) also returns the
%   inharmonic partials in the structure INHARM with fields INHARM.AMP for
%   the amplitudes, INHARM.FREQ for the frequencies, and INHARM.PH for the
%   phases. The fields may be empty if there are no inharmonic partials.
%
%    See also HARM_PART_SEL, HARM_PEAK_SEL

% 2022 MCaetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

narginchk(7,12)

nargoutchk(0,5)

if nargin == 7
    
    % Interval in cents
    % 100 cents = 1 semitone
    % 200 cents = 1 whole tone
    % 1200 cents = 1 octave
    max_harm_dev = 100;
    harm_thresh = 0.8;
    harmalgflag = 'part';
    harmpartflag = 'count';
    tvarf0flag = false;
    
elseif nargin == 8
    
    harm_thresh = 0.8;
    harmalgflag = 'part';
    harmpartflag = 'count';
    tvarf0flag = false;
    
elseif nargin == 9
    
    harmalgflag = 'part';
    harmpartflag = 'count';
    tvarf0flag = false;
    
elseif nargin == 10
    
    harmpartflag = 'count';
    tvarf0flag = false;
    
elseif nargin == 11
    
    tvarf0flag = false;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAXIMUM HARMONIC NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

harm_num = ceil(freq_part ./ f0);

max_harm_num = max(harm_num(:),[],'omitnan');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TIME-VARYING F0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if tvarf0flag
    
    freq_diff = abs(freq_part - f0);
    % Minimum frequency difference/frame
    min_freq_diff = min(freq_diff,[],2,'omitnan');
    % Index of partial with minimum frequency difference
    [~,indf0] = min(min_freq_diff,[],'omitnan');
    % Time-varying f0
    time_var_f0 = freq_part(indf0,:,:);
    
else
    
    time_var_f0 = f0;
    
end

harmonic_series = permute(tools.harm.mkharm(time_var_f0,max_harm_num,nframe,nchannel),[1 4 2 3]);

cand_freq = permute(freq_part,[4 1 2 3]);

harm_dist = @(ref,cand) abs(tools.mus.hertz2cents(cand,ref));

% DISTANCE USING HARMONICS AS REFERENCE: d(H,freq)
% d(H,F) distance from Hth harmonic (row) to Fth frequency partial (column)
% Row index of DIST_MAT give harmonic number
% Column index of DIST_MAT give partial track number
dist_mat = harm_dist(harmonic_series,cand_freq);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HARMONIC SELECTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(harmalgflag)
    
    case 'part'
        
        % WARNING! HARM_NUMBER and IHARM_PART are _LOGICAL_ indices here
        [harm_number,iharm_part,maxnharm] = tools.harm.harm_part_sel(dist_mat,freq_part,max_harm_num,...
            npart,nframe,nchannel,max_harm_dev,harm_thresh,harmpartflag);
        
    case 'peak'
        
        % WARNING! HARM_NUMBER and IHARM_PART are _LINEAR_ indices here
        [harm_number,iharm_part,maxnharm] = tools.harm.harm_peak_sel(dist_mat,max_harm_num,npart,nframe,nchannel,max_harm_dev);
        
    otherwise
        
        warning('SMT:HARMONIC_SELECTION:invalidArgument',...
            ['Invalid HARMALGFLAG\n'...
            'HARMALGFLAG must be either PART or PEAK\n'...
            'HARMALGFLAG entered was %s\n'...
            'Using default PEAK'],harmalgflag)
        % WARNING! HARM_NUMBER and IHARM_PART are _LINEAR_ indices here
        [harm_number,iharm_part,maxnharm] = tools.harm.harm_peak_sel(dist_mat,max_harm_num,npart,nframe,nchannel,max_harm_dev);
        
end

% Initialize HARMONIC_PARTIAL so the assignment below will keep the shape
% of HARMONIC_PARTIAL the same as size(FREQ_PART)
harm_amp = nan(max_harm_num,nframe,nchannel);
harm_freq = nan(max_harm_num,nframe,nchannel);
harm_ph = nan(max_harm_num,nframe,nchannel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ASSIGN HARMONIC PARTIALS TO CORRESPONDING HARMONIC NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

harm_amp(harm_number) = amp_part(iharm_part);
harm_freq(harm_number) = freq_part(iharm_part);
harm_ph(harm_number) = ph_part(iharm_part);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ONLY RETURN MAXNHARM HARMONICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

harm_amp(maxnharm+1:end,:,:) = [];
harm_freq(maxnharm+1:end,:,:) = [];
harm_ph(maxnharm+1:end,:,:) = [];

if strcmpi(harmalgflag,'part')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % KEEP REMAINING INHARMONIC PARTIAL TRACKS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % TRUE for harmonic partial tracks
    is_harm = all(harm_number,2);
    
    % Number of (active) harmonic tracks per channel
    % NOTE: Use [row,col] = find(_) syntax to return subscript indices
    % because the syntax k = find(_) returns linear indices (across
    % channels)
    [nrow,ncol] = find(is_harm(1:maxnharm,:,:));
    nharm = length(nrow(ncol==1));
    
    % Number of remaining inharmonic tracks
    ninharm = npart - nharm;
    
    if ninharm > 0
        
        % Initialize INHARM so the assignment below will keep the shape
        % of INHARMONIC_PARTIAL the same as size(FREQ_PART)
        inharm.amp = nan(ninharm,nframe,nchannel);
        inharm.freq = nan(ninharm,nframe,nchannel);
        inharm.ph = nan(ninharm,nframe,nchannel);
        ind_inharm_part = (1:ninharm*nframe*nchannel)';
        
        inharm.amp(ind_inharm_part) = amp_part(~iharm_part);
        inharm.freq(ind_inharm_part) = freq_part(~iharm_part);
        inharm.ph(ind_inharm_part) = ph_part(~iharm_part);
        
    else
        
        inharm.amp = [];
        inharm.freq = [];
        inharm.ph = [];
        
    end
    
else
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DISCARD ALL INHARMONIC PEAKS (POTENTIAL ARTIFACTS)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    inharm.amp = [];
    inharm.freq = [];
    inharm.ph = [];
    
end

end
