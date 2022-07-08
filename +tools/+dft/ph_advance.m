function phadv = ph_advance(bincenter,framelen,nfft,zphflag)
%PH_ADVANCE Phase advance to the center of the window.
%   Detailed explanation goes here

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


% TODO: CHECK ATTRIBUTES OF INPUT ARGUMENTS
% TODO: ADD HELP

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check the number of input arguments
narginchk(4,4);

% Check the number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if zphflag
    
    % Discrete normalized frequency
    norm_freq = tools.dft.normfreq(bincenter,nfft);
    
    % Length of left side of window in samples (number of samples from the
    % beggining to the center of the window)
    nsampleleft = tools.dsp.leftwin(framelen);
    
    % Phase advance (phase relative to the center of the window)
    phadv = rem(norm_freq*nsampleleft,2*pi);
    
else
    
    % No phase advance (phase relative to the beginning of the window)
    phadv = 0;
    
end
end
