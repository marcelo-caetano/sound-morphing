function zpadframe = flexpad(frame,nfft,padflag)
%FLEXPAD Flexible padding.
%   ZP = FLEXPAD(FR,NFFT) pads the columns of FR with zeros up to NFFT.
%   Assuming SIZE(FR) = [WINLEN,NFR]:
%
%   ZP = [FR;ZEROS(NFFT-WINLEN,NFR)] when NFFT >= WINLEN and
%
%   ZP = [FR;ZEROS(NFFT+WINLEN,NFR)] when NFFT < WINLEN.
%
%   ZP = FLEXPAD(FR,NFFT,PADFLAG) uses PADFLAG to specify values other than
%   zeros to do the padding. PADFLAG can be one of the following:
%
%   ONE: Ones
%
%   +INF, PINF, INF: Plus infinity
%
%   -INF, MINF: Minus infinity
%
%   NAN: Not a number
%
%   EPS: eps(1)
%
%   MIN: realmin
%
%   MAX: realmax
%
%   ZERO: Fallback to the default value of zeros.
%
%   See also ZPAD, IZPAD

% 2020 MCaetano SMT 0.1.1
% $Id 2021 M Caetano SMT 0.2.0-alpha.1 $Id


%TODO: CHECK CLASS OF INPUT ARGUMENTS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,3);

% Check number of output arguments
nargoutchk(0,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARSE INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Window length, number of frames, number of channels
[framelen,nframe,nchannel] = size(frame);

% Get length of padding
padlen = parseinput(framelen,nfft);

if nargin == 2
    
    % Padding function
    padfun = @zeros;
    
    % Multiplicative factor
    mult = 1;
    
else
    
    % Padding function handle and multiplicative factor
    [padfun,mult] = mkpadfun(padflag);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERFORM ZERO PADDING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Padding array
padarray = mult*padfun(padlen,nframe,nchannel);

% Zero pad (concatenate PADARRAY to FRAME)
zpadframe = [frame;padarray];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOCAL FUNCTION TO PARSE THE PADFLAG AND CALL MKPADFUNHANDLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [padfunhandle,mult] = mkpadfun(funinput)

% list of possibilities: {zero,one,minf,pinf,nan,eps,min,max};
funflag = {'zero','one','-inf','minf','+inf','pinf','inf',...
    'nan','eps','min','max'};

% Check if PADFLAG matches any of the supported options
boolfun = strcmpi(funinput,funflag);

if any(boolfun)
    
    % Create padding function handle and mult factor using PADFLAG
    [padfunhandle,mult] = mkpadfunhandle(funinput);
    
else
    
    % Throw warning: Invalid PADFLAG
    warning('SMT:WrongFlag',['Invalid PADFLAG: %s.\n Using default ZERO.\n'...
        'Type help tools.dsp.flexpad for a list of valid flags'],funinput);
    
    % Fall back to default zeropad
    padfunhandle = @zeros;
    
    % Fall back mult factor
    mult = 1;
    
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOCAL FUNCTION TO MAKE THE PADDING FUNCTION HANDLE AND MULT FACTOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [anonymfunhandle,mult] = mkpadfunhandle(funchar)

% List of possible function handles
funhandlelist = {@zeros,@ones,@inf,@nan};

switch lower(funchar)
    
    case {'-inf','minf'}
        
        ihandle = 3;
        mult = -1;
        
    case {'+inf','pinf','inf'}
        
        ihandle = 3;
        mult = 1;
        
    case 'eps'
        
        ihandle = 2;
        mult = eps;
        
    case 'min'
        
        ihandle = 2;
        mult = realmin;
        
    case 'max'
        
        ihandle = 2;
        mult = realmax;
        
    case 'nan'
        
        ihandle = 4;
        mult = 1;
        
    case 'one'
        
        ihandle = 2;
        mult = 1;
        
    case 'zero'
        
        ihandle = 1;
        mult = 1;
        
end

% Make handle to padding function
anonymfunhandle = funhandlelist{ihandle};

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOCAL FUNCTION TO GET THE LENGTH OF PADDING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plen = parseinput(wlen,nfft)

if nfft >= wlen
    
    % Pad up to length NFFT
    plen = nfft - wlen;
    
else
    
    % Pad with NFFT lines
    plen = nfft;
    
end

end
