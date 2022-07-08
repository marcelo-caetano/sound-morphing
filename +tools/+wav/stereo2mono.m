function mono = stereo2mono(stereo)
%STEREO2MONO Dowmix stereo audio to mono.
%   M = STEREO2MONO(S) downmixes stereo audio in S into mono audio in M.
%
%   S has one channel per column as returned by audioread. So S is NSAMPLE
%   by NCHANNEL, where NSAMPLE is the total number of samples of the audio
%   file and NCHANNEL is the number of channels.
%
%   M = S when N = 1. M = 0.5*S(:,1)+0.5*S(:,2) when NCHANNEL = 2. Finally,
%   STEREO2MONO returns an error whenever NCHANNEL > 2.
%
%   See also DOWNMIX

% 2016 MCaetano (Revised)
% 2019 MCaetano SMT 0.1.0
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,1);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~,nchannel] = size(stereo);

if isequal(nchannel,2)
    
    % Downmix from stereo to mono
    mono = 0.5*stereo(:,1) + 0.5*stereo(:,2);
    
elseif isequal(nchannel,1)
    
    % Bypass
    mono = stereo;
    
else
    
    error('SMT:STEREO2MONO:WrongNumChan',['Wrong number of Channels.\n'...
        'Stereo sounds must have two channels.\n'...
        'Input sound has %d channels.'],nchannel)
    
end

end
