function [amp,freq,ph] = partial_track_duration(amp,freq,ph,hop,fs,npartial,nframe,nchannel,durthres,gapthres,timescaleflag)
%PARTIAL_TRACK_DURATION Partial track selection using duration.
%   [Ad,Fd,Pd] = PARTIAL_TRACK_DURATION(A,F,P,H,Fs,NPART,NFRAME,NCHANNEL,DURTHRES,GAPTHRES)
%   trims segments of partial tracks whose duration is shorter than
%   DURTHRES ms and that have gaps (before and after) that are longer than
%   GAPTHRES ms. A, F, and P are respectively the amplitudes, frequencies,
%   and phases of the sinusoids _after partial tracking_, H is the hop size
%   in samples, and Fs is the sampling frequency in samples/s. NFRAME is
%   the number of frames and NCHANNEL is the number of channels.
%
%   See also PARTIAL_TRACKING

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(10,11);

% Check number of output arguments
nargoutchk(0,3);

if nargin == 10
    
    timescaleflag = 'ms';
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amp,freq,ph] = tools.track.trimtrack(amp,freq,ph,hop,fs,npartial,nframe,nchannel,durthres,gapthres,timescaleflag);

end
