function [zpadframes] = zpad(frames,winlen,nfft)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%   
%   See also IZPAD

% M Caetano

% Number of frames
nframes = size(frames,2);

% Zero pad
zpadframes = [frames;zeros(nfft-winlen,nframes)];

end

