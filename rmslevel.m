function [y] = rmslevel(x)
%RMSLEVEL Root mean square level.
%   Y = RMSLEVEL(X) returns the root-mean-square level of X.
%   RMS(X) = SQRT((1/L)*SUM(X.^2)), where L is the length of X.
%   Y has the RMS level per channel when X has one channel per column.
%
%   See also PEAKLEVEL, RMSDB, PEAKDB.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
if nargin ~= 1
    
    error('NumInArg:wrongNumber',['Wrong Number of Input Arguments.\n'...
        'RMSLEVEL takes 1 input arguments.\n'...
        'Type HELP RMSLEVEL for more information.\n'])
    
end

% Check input argument type
if not(isnumeric(x))
    
    error('TypeInArg:wrongType',['Wrong Type of Input Argument.\n'...
        'X must be a numeric class not %s.\n'...
        'Type HELP RMSLEVEL for more information.\n'],class(x))
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get NSAMPLE and NCHANNEL
[nsample,nchannel] = size(x);

% RMS level
y = sqrt((1/nsample) * sum(x .* conj(x)));

end