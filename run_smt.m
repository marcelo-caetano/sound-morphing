% RUN SOUND MORPHING TOOLBOX

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Path relative to CURREXFILE
% sourcePath = fullfile('.','audio','Accordion_C#3_f.wav');
sourcePath = fullfile(pwd,'MCaetano','Production','sound-morphing','audio','Accordion_C#3_f.wav');

% targetPath = fullfile('.','audio','Tuba_oV_hA_2-120_ff_C3.wav');
targetPath = fullfile(pwd,'MCaetano','Production','sound-morphing','audio','Tuba_oV_hA_2-120_ff_C3.wav');

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