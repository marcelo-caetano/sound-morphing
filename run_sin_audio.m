%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ SOUND FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

origs = fullfile('.','audio','Accordion_C#3_f.wav');
% origs = fullfile(pwd,'MCaetano','Production','sound-morphing','audio','Accordion_C#3_f.wav');

[fpath,fname,fext] = fileparts(origs);

[soundData,sr] = audioread(origs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Maximum number of peaks to resynthesize
maxnpeak = 100;

% Male voice from 85 Hz to 180 Hz (female 165 to 255 Hz)
F0 = 130; % C#3

% Window_size=3*T0
% framesize = fix(3*sr/F0);
framesize = 2^nextpow2(fix(3*sr/F0));

% 50% overlap
hopsize = fix(framesize/2);

% FFT size
nfft = 2^nextpow2(framesize);
% nfft = framesize;

% Normalize window during analysis (sum(window)==1) and preserve energy upon resynthesis
normflag = 1;

% Use zero phase window
zphflag = 1;

% Magnitude spectrum scaling
magflag = {'nne','lin','log','pow'};
mf = 3;

% Hann analysis window
wintype = 3;

% Store window name
winname = whichwin(wintype);

% Flag for center of first window
cfwflag = {'nhalf','one','half'};
cf = 3;

% Frame-wise threshold
% thresfr = inf(1);
thresfr = 66;

% Global threshold
% threstot = inf(1);
threstot = 66;

% Resynthesis flag
rsflag = {'OLA','PI','PRFI'};
rf = 1;

% Frequency difference for peak matching (Hz)
delta = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[amplitude,frequency,phase,duration,dc,cframe] = sinusoidal_analysis(soundData,...
    hopsize,framesize,wintype,nfft,sr,maxnpeak,thresfr,threstot,cfwflag{cf},normflag,zphflag,magflag{mf});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINUSOIDAL RESYNTHESIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[sinusoidal,partials,amplitudes,frequencies] = sinusoidal_resynthesis(amplitude,...
    frequency,phase,delta,hopsize,framesize,wintype,sr,duration,cframe,maxnpeak,cfwflag{cf},rsflag{rf});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT FIGURE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time = gentime(duration,sr);

% Plot Orig vs Sinusoidal
figure
plot(time,soundData,'r')
hold on
plot(time,sinusoidal,'k')
hold off
title('Original vs Sinusoidal')
legend('Original','Sinusoidal')
xlabel('Time (s)')
ylabel('Amplitude (linear)')

% Make residual
residual = soundData - sinusoidal;

SRER = 20*log10(std(soundData)/std(residual));

% Plot Orig vs Residual
figure
plot(time,soundData,'r')
hold on
plot(time,residual,'k')
hold off
title('Original vs Residual')
legend('Original','Residual')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % WRITE AUDIO FILES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Path to sinusoidal component
% sin = makepath({'Users','mcaetano','Documents','Sound Database','_Results','Sinusoidal','_Misc',[fname '_sin_' lower(rsflag{rf}) '_' lower(magflag{mf}) fext]});
% 
% % Write sinusoidal component
% audiowrite(sin,sinusoidal,sr);
% 
% % Path to residual component
% res = makepath({'Users','mcaetano','Documents','Sound Database','_Results','Sinusoidal','_Misc',[fname '_res_' lower(rsflag{rf}) '_' lower(magflag{mf}) fext]});
% 
% % Write residual component
% audiowrite(res,residual,sr);
% 
% % Path to original audio
% orig = makepath({'Users','mcaetano','Documents','Sound Database','_Results','Sinusoidal','_Misc',[fname fext]});
% 
% % Only write original if it does not exist in ORIG
% if exist(orig,'file') == 0
%     
%     [suc,mess,messid] = copyfile(origs,orig);
%     
% end