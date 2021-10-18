function [sinusoidal,partial,amplitude,frequency,phase] = sinusoidal_resynthesis(amp,freq,ph,framelen,hop,fs,nsample,center_frame,...
    npartial,nframe,delta,winflag,causalflag,synthflag,ptrackflag,dispflag)
%SINUSOIDAL_RESYNTHESIS Resynthesis from the output of sinusoidal analysis [1].
%   [SIN,PART,AMP,FREQ,PH] = SINUSOIDAL_RESYNTHESIS(A,F,P,M,H,FS,NSAMPLE,...
%   CFR,NPARTIAL,NFRAME,DELTA,WINFLAG,CAUSALFLAG,SYNTHFLAG,PTRACKFLAG,DISPFLAG)
%   resynthesizes the sinusoidal model SIN from the output parameters of
%   SINUSOIDAL_ANALYSIS (A,F,P), where A=amplitude, F=frequency, and
%   P=phases estimated with a hop H and a frame size of M. DELTA
%   determines the frequency difference for peak continuation for PI and
%   PRFI resynthesis in case of no partial tracking.
%
%   See also SINUSOIDAL_ANALYSIS

% 2016 M Caetano
% Revised 2019 (SM 0.1.1)
% 2020 MCaetano SMT 0.1.1 (Revised)
% 2020 MCaetano SMT 0.2.0
% 2020 MCaetano SMT 0.2.1
% 2021 M Caetano SMT
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(15,16);

% Check number of output arguments
nargoutchk(0,5);

if nargin == 15
    
    dispflag = false;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Handle partial tracking
if isempty(ptrackflag)
    
    disp('Standard peak-to-peak matching for resynthesis');
    
    % Peak-to-peak matching
    ptrackflag = 'p2p';
    
    % Partial tracking
    [amp,freq,ph,npartial] = partial_tracking(amp,freq,ph,delta,hop,fs,nframe,ptrackflag);
    
end

% Select resynthesis method
switch lower(synthflag)
    
    case 'ola'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % OVERLAP ADD
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        disp('Overlap-Add Resynthesis')
        
        [sinusoidal,partial,amplitude,frequency,phase] = sinusoidal_resynthesis_OLA...
            (amp,freq,ph,framelen,hop,fs,nsample,center_frame,npartial,nframe,winflag,causalflag,dispflag);
        
    case 'pi'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % POLYNOMIAL INTERPOLATION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        disp('Resynthesis by Polynomial Interpolation')
        
        [sinusoidal,partial,amplitude,frequency,phase] = sinusoidal_resynthesis_PI...
            (amp,freq,ph,framelen,hop,fs,nsample,center_frame,npartial,nframe,causalflag,dispflag);
        
    case 'prfi'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % PHASE RECONSTRUCTION VIA FREQUENCY INTEGRATION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        disp('Resynthesis by Phase Reconstruction via Frequency Integration')
        
        [sinusoidal,partial,amplitude,frequency,phase] = sinusoidal_resynthesis_PRFI...
            (amp,freq,framelen,hop,fs,nsample,center_frame,npartial,nframe,causalflag,dispflag);
        
    otherwise
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % POLYNOMIAL INTERPOLATION BY DEFAULT
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        warning('SMT:SINUSOIDAL_RESYNTHESIS:NoSynthFlag',['Undefined synthesis flag.\n'...
            'SYNTHFLAG must be OLA, PI, or PRFI.\n'...
            'SYNTHFLAG entered was %s.\n'...
            'Using default PI (polynomial interpolation) synthesis'],synthflag)
        
        disp('Resynthesis by Polynomial Interpolation')
        
        [sinusoidal,partial,amplitude,frequency,phase] = sinusoidal_resynthesis_PI...
            (amp,freq,ph,framelen,hop,fs,nsample,center_frame,npartial,nframe,causalflag,dispflag);
        
end

end
