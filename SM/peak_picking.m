function [index] = peak_picking(mag)
% PEAK_PICKING finds the peaks of the input.
%   [INDEX] = PEAK_PICKING(MAG) returns a logical vector INDEX with the
%   indices of the sinusoidal peaks in MAG.
%   INDEX is the same size as MAG and contains logical 1 for positions
%   that correspond to peaks and logical 0 otherwise.

% M Caetano

mag(isinf(mag)) = 0;

mag(isnan(mag)) = 0;

index = [false(1,1) ; mag(2:end-1) > mag(1:end-2) & mag(2:end-1) > mag(3:end) ; false(1,1)];

end