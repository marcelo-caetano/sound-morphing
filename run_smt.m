% RUN SOUND MORPHING TOOLBOX

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sourcePath = fullfile('C:','Users','Marcelo','Documents','Sound Database',...
%     'Vienna','Sounds','Accordion_C#3_f.wav');
% 
% targetPath = fullfile('C:','Users','Marcelo','Documents','Sound Database',...
%     'Vienna','Sounds','Tuba_oV_hA_2-120_ff_C3.wav');

% Get current working directory
currDir = pwd;

% Get name of currently executing file
currExFile = mfilename('fullpath');

% Change into directory of currently executing file
cd(fileparts(currExFile))

% Path relative to CURREXFILE
sourcePath = fullfile('.','audio','Accordion_C#3_f.wav');

targetPath = fullfile('.','audio','Tuba_oV_hA_2-120_ff_C3.wav');

% Morphing factor
morphFactor = 0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUN SMT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

morph = smt(sourcePath,targetPath,morphFactor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LISTEN TO SOUNDS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sampling rate
fs = 44100;

% Play MORPH
sound(morph,fs)

% Change back to current working directory
cd(currDir);