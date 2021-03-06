function [amp,freq,phase] = track2peak(amptrack,freqtrack,phasetrack,nframe)
%UNTITLED Convert frequency track to spectral peak representation.
%   [A,F,P] = TRACK2PEAK(At,Ft,Pt,NFRAME)

amp = cell(nframe,1);
freq = cell(nframe,1);
phase = cell(nframe,1);

for iframe = 1:nframe
    
    amp{iframe} = amptrack(not(isnan(amptrack(:,iframe))),iframe);
    freq{iframe} = freqtrack(not(isnan(freqtrack(:,iframe))),iframe);
    phase{iframe} = phasetrack(not(isnan(phasetrack(:,iframe))),iframe);
    
end

end

