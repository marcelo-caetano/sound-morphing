function tsm = solafs(orig,synth_hopsize,winl,center,Kmax,alpha)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPLIT SIG INTO OVERLAPPING FRAMES OF WINSIZE SEPARATED BY ANALYSIS HOPSIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[wsig,dur] = soffs(orig,synth_hopsize,winl,center,Kmax,alpha);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OVERLAP-ADD RESULT WITH SYNTHESIS HOPSIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tsm = olafs(wsig,fix(alpha*dur),winl,synth_hopsize,center);