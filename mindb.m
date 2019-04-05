function [norm_amp,norm_freq,norm_ph] = mindb(amp,freq,ph,threshold)
%MINDB only return peaks with minimum relative amplitude
%   Detailed explanation goes here

if isinf(threshold)
    
    norm_amp = amp;
    norm_freq = freq;
    norm_ph = ph;
    
elseif amp == 0
    
    norm_amp = amp;
    norm_freq = freq;
    norm_ph = ph;
    
else
    
    normampdb = 20*log10(amp/max(amp));
    norm_amp = amp(normampdb > -abs(threshold));
    norm_freq = freq(normampdb > -abs(threshold));
    norm_ph = ph(normampdb > -abs(threshold));
    
end

end