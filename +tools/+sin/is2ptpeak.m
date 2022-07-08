function boolpeak = is2ptpeak(mag)
% IS2PTPEAK True for symmetrical peaks of the magnitude spectrum.
%   BOOL = IS2PTPEAK(MAG) returns a logical vector BOOL with the
%   positions of the symmetrical peaks of MAG. BOOL is the same size as MAG
%   and contains TRUE for positions that correspond to symmetrical peaks
%   and FALSE otherwise. A symmetrical peak is defined as a spectral
%   magnitude MAG that is equal to its immediate neighbor to the left and
%   greater than its immediate neighbor to the right.
%
%   See also IS3PTPEAK, ISPEAK

% 2016 M Caetano;
% Revised 2019 SMT 0.1.1
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2021 M Caetano SMT (Stereo processing)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of frames and number of channels
[~,nframe,nchannel] = size(mag);

% Positions of the symmetrical peaks of the magnitude spectrum
% boolpeak = [false(1,nframe,nchannel) ; mag(1:end-2,:,:) == mag(2:end-1,:,:) & mag(2:end-1,:,:) > mag(3:end,:,:) ; false(1,nframe,nchannel)];

% First and last positions are always FALSE (No symmetrical peaks in DC or Nyquist)
inopeak = false(1,nframe,nchannel);

% TRUE when left MAG is equal to right MAG
ileft = mag(1:end-2,:,:) == mag(2:end-1,:,:);

% TRUE when right MAG is lower than left MAG
iright = mag(2:end-1,:,:) > mag(3:end,:,:);

% TRUE for symmetrical peak (Left MAG is equal and right MAG is lower)
ipeak = ileft & iright;

% Concatenate vertically
% boolpeak = cat(1,inopeak,ipeak,inopeak);
% boolpeak = vertcat(inopeak,ipeak,inopeak);
boolpeak = [inopeak ; ipeak ; inopeak];

end
