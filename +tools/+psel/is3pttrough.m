function bool_trough = is3pttrough(mag)
% IS3PTTROUGH True for spectral troughs of the magnitude spectrum.
%   BOOL = IS3PTTROUGH(MAG) returns a logical vector BOOL with the
%   positions of the spectral troughs of MAG. BOOL is the same size as MAG
%   and contains TRUE for positions that correspond to spectral troughs
%   and FALSE otherwise. A spectral peak is defined as a spectral
%   magnitude MAG that is greater than both its immediate neighbors.
%
%   See also IS2PTTROUGH, ISTROUGH

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

% % Number of frames and number of channels
% [~,nframe,nchannel] = size(mag);

% Positions of the troughs of the magnitude spectrum
% bool_trough = [mag(1,:,:) < mag(2,:,:) ; mag(1:end-2,:,:) > mag(2:end-1,:,:) & mag(2:end-1,:,:) < mag(3:end,:,:) ; mag(end-1,:,:) > mag(end,:,:)];

% First is trough if second is higher
bool_first = mag(1,:,:) < mag(2,:,:);

% Last is trough if last is lower
bool_last = mag(end-1,:,:) > mag(end,:,:);

% TRUE when left MAG is higher than right MAG
bool_left = mag(1:end-2,:,:) > mag(2:end-1,:,:);

% TRUE when right MAG is higher than left MAG
bool_right = mag(2:end-1,:,:) < mag(3:end,:,:);

% TRUE for trough (Both left and righ MAG are higher)
bool_lr = bool_left & bool_right;

% Concatenate vertically
% bool_trough = cat(1,notrough,bool_lr,notrough);
% bool_trough = vertcat(notrough,bool_lr,notrough);
bool_trough = [bool_first ; bool_lr ; bool_last];

end
