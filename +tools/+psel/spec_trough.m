function [ampTroughLeft,ampTroughRight,freqTroughLeft,freqTroughRight] = spec_trough(fft_frame,indmaxnpeak,nfft,fs,...
    nframe,nchannel,npeakflag)
%SPEC_TROUGH Amplitudes and frequencies of spectral troughs to the right and to the left of spectral peaks.
%   [AL,AR,FL,FR] = SPEC_TROUGH(FFTFR,INDMAXNPEAK,NFFT,Fs,NFRAME,NCHANNEL,NPEAKFLAG)
%
%   See also

% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(7,7);

% Check number of output arguments
nargoutchk(0,4);

% TODO: VALIDATE ARGUMENTS

validateattributes(fft_frame,{'numeric'},{'nonempty','finite'},mfilename,'FFRFR',1)
validateattributes(indmaxnpeak,{'numeric'},{'nonempty','finite','real','integer','increasing'},mfilename,'INDMAXNPEAK',2)
validateattributes(nfft,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'NFFT',3)
validateattributes(fs,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'Fs',4)
validateattributes(nframe,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NFRAME',5)
validateattributes(nchannel,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NCHANNEL',6)
validateattributes(npeakflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NPEAKFLAG',7)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Frequency bins
[freqbin,nbin] = tools.spec.mkfreq(nfft,fs,nframe,nchannel,'pos');

nrgflag = true;
posmagspec = tools.fft2.fft2pos_mag_spec(fft_frame,nfft,nrgflag);
bool_trough = tools.psel.istrough(posmagspec);
bool_peak = tools.sin.ispeak(posmagspec);

% Check if NTROUGH == NPEAK+1 for all frames
ind_frame_fix = checkNPeakNTrough(bool_peak,bool_trough);

if ~isempty(ind_frame_fix)
    
    [posmagspec,bool_peak,bool_trough] = fixBrokenFrames(posmagspec,bool_peak,bool_trough,ind_frame_fix,nbin,nframe,nchannel);
    
end

% Initialize trough
freq_trough_left = nan(nbin,nframe,nchannel);
amp_trough_left = nan(nbin,nframe,nchannel);
freq_trough_right = nan(nbin,nframe,nchannel);
amp_trough_right = nan(nbin,nframe,nchannel);

% Linear indices of troughs
ind_trough = find(bool_trough);

% Linear indices of first/last trough in each frame (across channels)
[ind_first_trough,ind_last_trough] = tools.algo.findIndFirstLastTrueVal(bool_trough,nbin,nframe,nchannel);

% Linear indices of troughs to the left of peaks
ind_trough_left = setdiff(ind_trough,ind_last_trough);

% Linear indices of troughs to the right of peaks
ind_trough_right = setdiff(ind_trough,ind_first_trough);

% Assign AMP/FREQ of trough left to the same positions as peaks
amp_trough_left(bool_peak) = posmagspec(ind_trough_left);
freq_trough_left(bool_peak) = freqbin(ind_trough_left);

% Assign AMP/FREQ of trough right to the same positions as peaks
amp_trough_right(bool_peak) = posmagspec(ind_trough_right);
freq_trough_right(bool_peak) = freqbin(ind_trough_right);

if npeakflag
    
    % Return MAXNPEAK x NFRAME x NCHANNEL
    ampTroughLeft = amp_trough_left(indmaxnpeak);
    ampTroughRight = amp_trough_right(indmaxnpeak);
    freqTroughLeft = freq_trough_left(indmaxnpeak);
    freqTroughRight = freq_trough_right(indmaxnpeak);
    
else
    
    % Initialize with size NBIN x NFRAME x NCHANNEL
    ampTroughLeft = nan(nbin,nframe,nchannel);
    freqTroughLeft = nan(nbin,nframe,nchannel);
    ampTroughRight = nan(nbin,nframe,nchannel);
    freqTroughRight = nan(nbin,nframe,nchannel);
    
    % Assign only to MAXNPEAK positions per frame
    ampTroughLeft(indmaxnpeak) = amp_trough_left(indmaxnpeak);
    ampTroughRight(indmaxnpeak) = amp_trough_right(indmaxnpeak);
    freqTroughLeft(indmaxnpeak) = freq_trough_left(indmaxnpeak);
    freqTroughRight(indmaxnpeak) = freq_trough_right(indmaxnpeak);
    
end

end

% LOCAL FUNCTION TO CHECK IF NTROUGH == NPEAK+1
function indFrame = checkNPeakNTrough(boolPeak,boolTrough)
% CHECK IF NTROUGH == NPEAK+1
% RETURN LINEAR INDICES OF FRAMES (ACROSS CHANNELS) WHEN NTROUGH != NPEAK+1
% AS A COLUMN VECTOR OR RETURN EMPTY WHEN ALL FRAMES NTROUGH == NPEAK+1

% NPEAK for all frames
NPeak = sum(boolPeak);

% NTROUGH for all frames
NTrough = sum(boolTrough);

% TRUE when NTROUGH == NPEAK+1
boolN = NPeak + 1 == NTrough;

% NPEAK == 0 for frames with all NaN
boolNPeakNaN = NPeak == 0;

% NTROUGH == 0 for frames with all NaN
% boolNTroughNaN = NTrough == 0;

% Sanity check: Make sure both have the same number of frames with all NaN
% isequal(boolNPeakNaN,boolNTroughNaN)

% TRUE
boolCheck = boolN | boolNPeakNaN;

% Check if SUMPEAK == 0 only for frames with all NaN
if all(boolCheck(:))
    
    indFrame = [];
    
else
    
    indFrame = find(~boolCheck);
    
end

end

% LOCAL FUNCTION TO FIX FRAMES THAT VIOLATE CONDITION NTROUGH == NPEAK+1
function [posMagSpec,boolPeak,boolTrough] = fixBrokenFrames(posMagSpec,boolPeak,boolTrough,indFrameFix,NBin,NFrame,NChannel)
% FIX FRAMES THAT VIOLATE CONDITION NTROUGH == NPEAK+1
% SHUT ENTIRE FRAME WHEN SPECTRAL ENERGY IS BELOW -120 dB POWER
% OTHERWISE, RETAIN ONLY NPEAK+1 TROUGHS IN BROKEN FRAMES SO NTROUGH == NPEAK+1

[nFrameFix,~] = size(indFrameFix);

logMagSpec = tools.math.lin2log(posMagSpec,'dbp');

boolSpecNRG = logMagSpec(:,indFrameFix) < -120;

if all(boolSpecNRG(:))
    
    boolPeak(:,indFrameFix) = false;
    boolTrough(:,indFrameFix) = false;
    
    indFix = sub2ind([NBin,NFrame,NChannel],repmat((1:NBin)',1,nFrameFix),ones(NBin,nFrameFix).*indFrameFix');
    posMagSpec(indFix) = nan(1);
    
else
    % WARNING! CHECK IF THE LOGIC HOLDS FOR STEREO
    NPeak = sum(boolPeak(:,indFrameFix));
    NTrough = sum(boolTrough(:,indFrameFix));
    
    % Use peaks as reference
    warning('SMT:SPEC_TROUGH:IncompatibleArraySize',...
        ['Incompatible number of peaks NPEAK and number of troughs NTROUGH.\n'...
        'The condition NPEAK + 1 == NTROUGH must be met for every frame.'...
        'Found NPEAK = %d and NTROUGH = %d.\n'...
        'Retaining only NPEAK+1 troughs.'],NPeak,NTrough)
    
    % Linear indices of all troughs (across channels)
    indTrough = find(boolTrough(:,indFrameFix));
    
    if NTrough > NPeak
        
        boolTrough(indTrough(NPeak+2:NTrough),indFrameFix) = false;
        
    else
        
        % MUST ADD NPEAK-NTROUGH TIME TRUE
        warning('SMT:SPEC_TROUGH:IncompatibleArraySize',...
            ['Incompatible number of peaks NPEAK and number of troughs NTROUGH.\n'...
            'The condition NPEAK + 1 == NTROUGH must be met for every frame.'...
            'Found NPEAK = %d and NTROUGH = %d.\n'...
            'Relax hard-codded condition logMagSpec < -120 dB'],NPeak,NTrough)
        
    end
    
end

end
