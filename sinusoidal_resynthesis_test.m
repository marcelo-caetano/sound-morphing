function [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis_test(amp,freq,phase,delta,hopsize,winlen,sr,duration,wintype,center,cframe,synthflag,maxnpeak)
%SINUSOIDAL_RESYNTHESIS Summary of this function goes here
%   Detailed explanation goes here

% M Caetano

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUTS
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
    
    case 'pi'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % PARAMETER INTERPOLATION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        disp('Resynthesis by Parameter Interpolation')
        
        % [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis_PI(amp,freq,phase,delta,cframe,hopsize,winlen,sr,duration,center,maxnpeak);
        [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis_PI_test(amp,freq,phase,delta,cframe,hopsize,winlen,sr,duration,center,maxnpeak);
             
    case 'ola'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % OVERLAP ADD
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        disp('Overlap-Add Resynthesis')
        
        [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis_OLA(amp,freq,phase,hopsize,winlen,sr,duration,wintype,center,cframe);
        
    case 'addwp'
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ADDITIVE RESYNTHESIS WITHOUT PHASE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        disp('Additive Resynthesis without Phase')
        
        [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis_without_phase_PI(amp,freq,delta,cframe,hopsize,winlen,sr,duration,center,maxnpeak);
        
    otherwise
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % PARAMETER INTERPOLATION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        warning(['NoSynthFlag: Undefined synthesis flag.\n'...
            'Using default PI (parameter interpolation) synthesis'])
        
        disp('Resynthesis by parameter interpolation')
        
        [sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis_PI(amp,freq,phase,delta,cframe,hopsize,winlen,sr,duration,center,maxnpeak);
        
end

end