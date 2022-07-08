function zpadframe = zeropad(frame,nfft)
%ZPAD Zero padding.
%   ZP = ZPAD(FR,NFFT) zero pads the columns of the time frames FR up to
%   NFFT. FR is size M x NFRAME x NCHANNEL, where M is the frame length,
%   NFRAME is the number of frames, and NCHANNEL is the number of channels.
%
%   If NFFT > M, ZP is size NFFT x NFRAME x NCHANNEL with zeros from M+1 to
%   NFFT.
%
%   If NFFT <= M, ZP == FR.
%
%   See also IZPAD, FLEXPAD

% 2016 M Caetano
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,3);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Window length, number of frames, number of channels
[framelen,nframe,nchannel] = size(frame);

if framelen < nfft
    
    % Call FLEXPAD
    zpadframe = tools.dsp.flexpad(frame,nfft);
    
else
    
    zpadframe = frame;
    
end

end
