function posspec = full_spec2pos_spec(fft_frame,nfft,nrgflag)
%FULL_SPEC2POS_SPEC Full spectrum to positive spectrum.
%   PS = FULL_SPEC2POS_SPEC(FFT_FRAME) returns the _non-negative_
%   frequency half of the complex FFT_FRAME array. FFT_FRAME is size
%   NFFT x NFRAME x NCHANNEL, where NFFT is the DFT size, NFRAME is the
%   number of STFT frames, and NCHANNEL is the number of audio channels.
%   When called with one input argument, FULL_SPEC2POS_SPEC uses the number
%   of rows of FFT_FRAME as NFFT.
%
%   PS = FULL_SPEC2POS_SPEC(FFT_FRAME,NFFT) uses NFFT as the size of the
%   DFT use in FFT_FRAME instead of the number of rows of FFT_FRAME. A
%   warning is issued if NROW != NFFT.
%
%   PS = FULL_SPEC2POS_SPEC(F,NFFT,NRGFLAG) uses the logical
%   flag NRGFLAG to specify if PS should also contain the spectral energy
%   of the negative frequency bins. NRGFLAG = TRUE adds the energy of the
%   negative frequency bins to the positive spectrum and NRGFLAG = FALSE
%   does not. The default is NRGFLAG = FALSE for the previous syntaxes.
%
%   See also POS_SPEC2FULL_SPEC,
%   FFT2POS_MAG_SPEC, FFT2POS_PHASE_SPEC

% 2020 M Caetano SMT 0.1.2
% 2021 M Caetano SMT (Revised for stereo)
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,3);

% Check number of output arguments
nargoutchk(0,1);

% Defaults
if nargin == 1
    
    % Assume FFT_FRAME is NFFT X NFRAME x NCHANNEL
    [nfft,~,~] = size(fft_frame);
    
    % Do not compensate for the energy of negative frequencies
    nrgflag = false;
    
elseif nargin == 2
    
    % Do not compensate for the energy of negative frequencies
    nrgflag = false;
    
end

% Check that NFFT == SIZE(FFT_FRAME,1)
[nrow,nframe,nchannel] = size(fft_frame);

if nfft ~= nrow
    
    warning('SMT:FULL_SPEC2POS_SPEC:wrongInputArgument',...
        ['Input argument NFFT does not match the dimensions of FFT_FRAME\n'...
        'FFT_FRAME must be NFFT x NFRAME x NCHANNEL\n'...
        'Size of FFT_FRAME entered was %d x %d x %d\n'...
        'NFFT entered was %d\n'],nrow,nfft,nchannel,nfft);
    
end

% Validate FFT_FRAME
validateattributes(fft_frame,{'numeric'},{'3d','nonempty','nonsparse'},mfilename,'FFT_FRAME',1)

% Validate NFFT
validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',2)

% Validate NNFLAG
validateattributes(nrgflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NRGFLAG',3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Index of upper bound of positive frequency band (Nyquist bin)
inyq = tools.spec.pos_freq_band(nfft);

if nrgflag
    
    % Handle even/odd NFFT separately
    if tools.misc.iseven(nfft)
        
        posspec = posSpecEvenNFFT(fft_frame,nfft,inyq,nframe,nchannel);
        
    else
        
        posspec = posSpecOddNFFT(fft_frame,nfft,inyq,nframe,nchannel);
        
    end
    
else
    
    % Just return positive half of FFT_FRAME
    posspec = fft_frame(1:inyq,:,:);
    
end

end

% LOCAL FUNCTION FOR EVEN NFFT
function ps = posSpecEvenNFFT(fftfr,nfft,inyq,nframe,nchannel)

% Initialize POSSPEC
ps = zeros(inyq,nframe,nchannel);

% Positive frequency half of the spectrum
spec_posfreq = fftfr(2:inyq-1,:,:);

% Negative frequency half of the spectrum
spec_negfreq = fftfr(inyq+1:nfft,:,:);

% Complex conjugate of negative half of spectrum
conj_negfreq = conj(spec_negfreq);

% Flip around frequency axis
flipped_conj_negfreq = flip(conj_negfreq,1);

% Add spectral energy of positive and (flipped complex conjugate of) negative halves
ps(2:inyq-1,:,:) = spec_posfreq + flipped_conj_negfreq;

% Add DC and Nyquist
ps([1 inyq],:,:) = fftfr([1 inyq],:,:);

end

% LOCAL FUNCTION FOR ODD NFFT
function ps = posSpecOddNFFT(fftfr,nfft,inyq,nframe,nchannel)

% Initialize POSSPEC
ps = zeros(inyq,nframe,nchannel);

% Positive frequency half of the spectrum
spec_posfreq = fftfr(2:inyq,:,:);

% Negative frequency half of the spectrum
spec_negfreq = fftfr(inyq+1:nfft,:,:);

% Complex conjugate of negative half of spectrum
conj_negfreq = conj(spec_negfreq);

% Flip around frequency axis
flipped_conj_negfreq = flip(conj_negfreq,1);

% Add spectral energy of positive and (flipped complex conjugate of) negative halves
ps(2:inyq,:,:) = spec_posfreq + flipped_conj_negfreq;

% Add DC
ps(1,:,:) = fftfr(1,:,:);

end
