function zeroph = lin_phase2zero_phase(linph,framelen)
%LIN2ZERO Linear phase to zero phase.
%   ZP = LIN2ZERO(LP,FRAMELEN) flips the linear phase signal LP around
%   the center of the window with FRAMELEN samples. The sample at the
%   center of the window CW is CW = TOOLS.DSP.CENTERWIN(FRAMELEN,'CAUSAL').
%
%   See also ZERO2LIN, FFTFLIP, IFFTFLIP

% 2016 MCaetano
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2021 M Caetano SMT (Revised for stereo)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK FUNCTION INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,2);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Left half of the window
winleft = tools.dsp.leftwin(framelen);

% Flip left and right halves
zeroph = [linph(winleft+1:end,:,:);linph(1:winleft,:,:)];

end
