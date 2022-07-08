function ind = bin2ind(bin,nfft)
%BIN2IND Convert frequency bin number into array index.
%   IND = BIN2IND(K) converts the frequency bins K into the corresponding
%   array index IND. Fractional bin numbers are rounded off to the nearest
%   integer. K can be a scalar, array, or matrix. This syntax is equivalent
%   to IND = K + 1, so only non-negative bin numbers are allowed.
%
%   IND = BIN2IND(K,NFFT) is the syntax for when there are negative bin
%   numbers corresponding to the negative half of the sectrum. Negative
%   frequency bins are shifted by NFFT/2 - 1 to always result in positive
%   indices. Use MKFREQ with FREQLIMFLAG = 'NEGPOS' to generate negative
%   bin numbers or negative frequencies in Hertz.
%
%   See also IND2BIN, IND2FREQ, FREQ2IND, FREQ2BIN, BIN2FREQ, MKFREQ, NYQ_FREQ

% 2020 MCaetano SMT 0.1.1
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


% TODO: REPLACE NARGIN LOGIC WITH EXPLICIT OPTION FLAGS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,2);

% Check number of output arguments
nargoutchk(0,1);

if nargin == 1
    
    % Invalid NFFT (unused)
    nfft = nan(1);
    
end

% Validate BIN
validateattributes(bin,{'numeric'},{'nonempty','real'},mfilename,'BIN',1)

if isnan(nfft)
    
    % Additional constraint for BIN (No negative bin numbers)
    validateattributes(bin,{'numeric'},{'nonnegative'},mfilename,'BIN',1)
    
else
    
    % Validate NFFT
    validateattributes(nfft,{'numeric'},{'scalar','finite','nonnan','integer','real','positive'},mfilename,'NFFT',2)
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Shift zero-frequency bin back to beginning of array
if ~isnan(nfft)
    
    bin = tools.spec.ibinshift(bin,nfft);
    
end

% Conversion (round off to nearest integer)
ind = round(bin) + 1;

end
