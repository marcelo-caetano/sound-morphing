function [outpath] = makepath(filecomp)
%MAKEPATH Make system-dependent path from path components.
%   P = MAKEPATH(C) returns in P a system-dependent path specified in C.
%
%   C is a cell array of strings, each specifying one component of C.
%   For example, C = {'Users','UserName','DataSet'} returns
%   C = '/Users/UserName/DataSet' on a Mac
%   C = 'C:\Users\UserName\DataSet' on a PC (with drive C:)

if ismac
    
    basedir = filesep;
    
    userName = 'mcaetano';
    
    wrongUser = 'Marcelo';
    
elseif ispc
    
    basedir = 'C:';
    
    userName = 'Marcelo';
    
    wrongUser = 'mcaetano';
    
else
    
    error('wrongOS:Only Mac or PC')
    
end

if any(not(cellfun('isempty',regexp(filecomp,userName))))
    
    outpath = fullfile(basedir,filecomp{:});
    
else
    
    filecomp = strrep(filecomp,wrongUser,userName);
    
    outpath = fullfile(basedir,filecomp{:});
    
end

end

% if ismac
%     userName = 'mcaetano';
% elseif ispc
%     userName = 'Marcelo';
% else
%     error('wrongOS:Only Mac or PC')
% end
% 
% sol = {'Users',userName,'Documents','Sound Database','Studio Online','Sounds'};
% 
% target = {'Users',userName,'Documents','Sound Database','_Results','CAMO','target_sounds','experiment','non_tvar'};
% 
% if ismac
%     pathSOL = fullfile(filesep,sol{:},filesep);
%     pathTarget = fullfile(filesep,target{:},filesep);
% elseif ispc
%     % Find drive letter
%     currPath = regexp(pwd,filesep,'split');
%     % create path;
%     pathSOL = fullfile(currPath{1},sol{:},filesep);
%     pathTarget = fullfile(currPath{1},target{:},filesep);
% else
%     error('wrongOS:Only Mac or PC')
% end
