function add2path(dirname,posflag,recursiveflag)
%ADD2PATH Add to Matlab Path
%   ADD2PATH(DIRNAME) add the folder DIRNAME to the top of the Matlab
%   search path for the current session.
%
%   ADD2PATH(DIRNAME,POS) uses the text flag POS to specify the position to
%   add to the path. POS = 'TOP' adds to the top of the path and POS =
%   'END' adds to the bottom of the path. The default is POS = 'TOP'.
%
%   ADD2PATH(DIRNAME,RECURSIVEFLAG) uses the logical flag RECURSIVEFLAG to
%   specify if all subfolders in DIRNAME will also be added to the Matlab
%   path. RECURSIVEFLAG = TRUE adds all subfolders and RECURSIVEFLAG =
%   FALSE only adds DIRNAME (so functions or scripts located inside
%   subfolders will not be found). The default is RECURSIVEFLAG = TRUE.
%
%   See also ISDIRONPATH, ISONPATH

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

narginchk(1,3)

nargoutchk(0,0)

if nargin == 1
    
    posflag = 'top';
    recursiveflag = true;
    
elseif nargin == 2
    
    recursiveflag = true;
    
end

validateattributes(dirname,{'char','string'},{'nonempty'},mfilename,'DIRNAME',1)
validateattributes(posflag,{'char','string'},{'nonempty'},mfilename,'POSFLAG',2)
validateattributes(recursiveflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'RECURSIVEFLAG',3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(posflag)
    
    case 'top'
        
        pos = '-begin';
        
    case 'end'
        
        pos = '-end';
        
    otherwise
        
        warning('SMT:ADD2PATH:InvalidArgument',...
            ['Invalid input argument\n'...
            'POSFLAG must be either TOP or END\n'...
            'POSFLAG entered was %s\n'...
            'Using default POSFLAG = TOP'],posflag);
        
        pos = '-begin';
        
end

if recursiveflag
    
    % Generate recursive path (recursive)
    decorator = @genpath;
    
else
    
    % Anonymous function that returns input (not recursive)
    decorator = @(x) x;
    
end

addpath(decorator(dirname),pos)

end
