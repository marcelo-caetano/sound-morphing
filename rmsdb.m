function [ydb] = rmsdb(x,flag)
%RMSDB Root mean square level in dB.
%   Y = RMSDB(X,FLAG) returns the root-mean-square (RMS) level of X in dB.
%   FLAG can be either 'SIN' or 'SQ' to determine the reference level used.
%   SIN uses 0 dB as RMS(SIN) and SQ uses 0 dB as RMS(SQUARE), where
%   RMS(SIN) is the RMS level of a full-scale sine wave [1] and RMS(SQUARE)
%   is the RMS level of a full-scale square wave [2].
%
%   Y = RMSDB(X) uses 'SIN' as default reference level.
%
%   Y has the RMS level per channel when X has one channel per column.
%
%   [1] AES17-2015: AES standard method for digital audio engineering -
%   Measurement of digital audio equipment.
%   (http://www.aes.org/publications/standards/search.cfm?docID=21)
%
%   [2] Recommendation ITU-T G.100.1 provides the definition for different
%   logarithmic power level measurement units in current use in
%   telecommunication systems.
%   (http://www.itu.int/ITU-T/recommendations/rec.aspx?rec=5596&lang=en)
%
%   See also PEAKDB, RMSLEVEL, PEAKLEVEL.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
if nargin > 2
    
    error('NumInArg:wrongNumber',['Wrong Number of Input Arguments.\n'...
        'RMSDB takes 1 or 2 input arguments.\n'...
        'Type HELP RMSDB for more information.\n'])
    
end

% Check input argument type
if not(isnumeric(x))
    
    error('TypeInArg:wrongType',['Wrong Type of Input Argument.\n'...
        'X must be a numeric class not %s.\n'...
        'Type HELP RMSDB for more information.\n'],class(x))
    
end
   
% Check input argument type
if nargin == 2 && not(ischar(flag))
    
    error('TypeInArg:wrongType',['Wrong Type of Input Argument.\n'...
        'FLAG must be class CHAR not %s.\n'...
        'Type HELP RMSDB for more information.\n'],class(flag))
    
end

% Default reference level (0 dB)
if nargin == 1
    
    flag = 'sin';
    
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reference level specified by FLAG
switch flag
    
    case 'sin'
        
        zerodb = sqrt(2)/2;
        
    case 'sq'
        
        zerodb = 1;
        
    otherwise
        
        warning('RMSdB:wrongFlag','Flag must be either SIN or SQ\nUsing default SIN.')
        
        zerodb = sqrt(2)/2;
        
        
end

% RMS level in dB
ydb = 20*log10(rmslevel(x)/zerodb);

end