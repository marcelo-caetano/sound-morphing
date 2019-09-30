%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADD FOLDER FROM CURRENTLY RUNNING SCRIPT TO MATLAB PATH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get current working directory
currDir = pwd;

% Get full path & name of executing file
exeFile = mfilename('fullpath');

% Get full path of executing directory
exeDir = fileparts(exeFile);

% Add EXEDIR to Matlab path
addpath(genpath(exeDir));

% Change into directory of currently executing file
cd(exeDir);