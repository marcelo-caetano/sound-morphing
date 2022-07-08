function ph = phasedft(bin,nfft,shift)
%PHASEDFT Phase of the discrete Fourier transform.
%   P = PHASEDFT(K,NFFT,SHIFT) returns the complex phase P of the discrete
%   Fourier transform as P = exp(-1j*(F*SHIFT)), where F is the normalized 
%   frequency and SHIFT is the corresponding time domain shift. The
%   normalized frequency is F = 2*pi*K/NFFT, where K is the vector of
%   frequency bins and NFFT is the size of the DFT.
%
%   See also DIRICHFUNC, DIRICHLET

% 2019 M Caetano
% 2021 M Caetano SMT (Revised)
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


% TODO: CHECK ATTRIBUTES OF INPUT ARGUMENTS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check the number of input arguments
narginchk(3,3);

% Check the number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Normalized frequencies
norm_freq = tools.dft.normfreq(bin,nfft);

% Complex phase
ph = exp(-1j*(norm_freq*shift));

end
