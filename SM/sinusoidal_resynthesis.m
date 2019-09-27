function [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis(amp,freq,phase,delta,hopsize,framesize,wintype,fs,nsample,cframe,center,synthflag,maxnpeak)
%SINUSOIDAL_RESYNTHESIS Summary of this function goes here
%   Detailed explanation goes here

% M Caetano

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
% if nargin == 13
%
%     dblevel = 0;
%
% elseif nargin ~= 14
%
%     error('NumInArg:wrongNumber',['Wrong Number of Input Arguments.\n'...
%         'NORMDB takes 3 input arguments.\n'...
%         'Type HELP NORMDB for more information.\n'])
%
% end

% % Check type of input argument
% if not(isnumeric(dblevel))
%
%     error('TypeArg:wrongType',['Wrong Type of Input Argument.\n'...
%         'DBLEVEL must be class NUMERIC not %s.\n'...
%         'Type HELP NORMDB for more information.\n'],class(flag))
%
% end
%
% % Check type of input argument
% if not(ischar(flag))
%
%     error('TypeArg:wrongType',['Wrong Type of Input Argument.\n'...
%         'FLAG must be class CHAR not %s.\n'...
%         'Type HELP NORMDB for more information.\n'],class(flag))
%
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(synthflag)
    
    case 'ola'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % OVERLAP ADD
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        disp('Overlap-Add Resynthesis')
        
        [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis_OLA(amp,freq,phase,hopsize,framesize,wintype,fs,nsample,cframe,center);
        
    case 'pi'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % PARAMETER INTERPOLATION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        disp('Resynthesis by Parameter Interpolation')
        
        [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis_PI(amp,freq,phase,delta,hopsize,framesize,fs,nsample,cframe,center,maxnpeak);
        
        
    case 'prfi'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ADDITIVE RESYNTHESIS WITHOUT PHASE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        disp('Resynthesis by Phase Reconstruction via Frequency Integration')
        
        [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis_PRFI(amp,freq,delta,hopsize,framesize,fs,nsample,cframe,center,maxnpeak);
        
    otherwise
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % PARAMETER INTERPOLATION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        warning(['NoSynthFlag: Undefined synthesis flag.\n'...
            'Using default PI (parameter interpolation) synthesis'])
        
        disp('Resynthesis by Parameter Interpolation')
        
        [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis_PI(amp,freq,phase,delta,hopsize,framesize,fs,nsample,cframe,center,maxnpeak);
        
end

end