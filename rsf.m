function listfiles = rsf(basedir,ext)
%RSF Recursive search for file.
%
%   FILES = RSF(BASEDIR,EXT) performs a recursive search in BASEDIR
%   for files of type .EXT. The recursive search looks in BASEDIR and all
%   subfolders. BASEDIR must be a path to a valid folder. EXT must be a
%   valid file extension. FILES is a list of absolute paths to all the
%   files of type .EXT found.
%
%   EXT can be preceded by the dot (.ext) or not (ext). RSF adds the
%   dot internally so the search is always for .ext
%
%   See also RECURSLISTDIR

%   M Caetano 2018.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK INPUTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
if nargin ~= 2
    
    error('NumInArg:wrongNumber',['Wrong Number of Input Arguments.\n'...
        'RECURSDIR takes 2 input arguments.\n'...
        'Type HELP RECURSDIR for more information.\n'])
    
end

% Check input argument type
if not(ischar(basedir))
    
    error('TypeInArg:wrongType',['Wrong Type of Input Argument.\n'...
        'BASEDIR must be class CHAR not %s.\n'...
        'Type HELP RECURSDIR for more information.\n'],class(basedir))
    
end

% Check input argument type
if not(ischar(ext))
    
    error('TypeInArg:wrongType',['Wrong Type of Input Argument.\n'...
        'EXPR must be class CHAR not %s.\n'...
        'Type HELP RECURSDIR for more information.\n'],class(ext))
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BEGIN OF FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Search current directory and put results in structure
listdir = dir(basedir);

% Number of directories inside first level
[ndir,~] = size(listdir);

% Initialize output variable
listfiles = {};

% Remove . from beginning of EXT (added back in call to REGEXP))
if ext(1) == '.'
    
    % Remove . from EXT
    ext = ext(2:end);
    
end

for idir = 1:ndir
    
    % If LISTDIR(IDIR) is not a directory AND the file name has EXPR
    if ~listdir(idir).isdir && ~isempty(regexpi(listdir(idir).name,['\.' ext],'match'))
        
        % Add file to the list
        listfiles{length(listfiles)+1} = fullfile(basedir, listdir(idir).name);
        
        % If LISTDIR(IDIR) is a directory (not current directory nor parent directory)
    elseif listdir(idir).isdir && ~strcmp(listdir(idir).name,'.') && ~strcmp(listdir(idir).name,'..')
        
        % If LISTDIR(IDIR) is a directory(and not current or up a level), search in that
        pname = fullfile(basedir,listdir(idir).name);
        
        % Recursive search
        OutfilesTemp = rsf(pname,ext);
        
        if ~isempty(OutfilesTemp)
            
            % If recursive search is fruitful, add it to the current list
            listfiles((length(listfiles)+1):(length(listfiles)+length(OutfilesTemp))) = OutfilesTemp;
            
        end
        
    end
    
end

% Return list of files as a column vector
listfiles = listfiles';

end
