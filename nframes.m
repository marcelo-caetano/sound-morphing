function [number_frames] = nframes(duration,winlen,hopsize,center)
%NFRAMES number of frames
%   F = NFRAMES(N,M,H,C) returns the number of frames F a length N signal
%   will have when split into overlapping frames of length M by a hopsize H 
%   and first window centered at C. The flag C specifies the sample corresponding
%   to the center of the first analysis window. C can be ONE, HALF, or NHALF.
%
%   See also NSAMPLES

switch center
    
    case 'one'
        
        offset = 0;
        
    case 'half'
        
        offset = -rhw(winlen)-lhw(winlen);
        
    case 'nhalf'
        
        offset = rhw(winlen)+1+lhw(winlen)+1;
        
    otherwise
        
        warning('InvalidFlag: Flag that specifies the center of the first analysis window must be ONE, HALF, or NHALF. Using default ONE');
        offset = 0;
        
end

% Number of times hop_size fits into total duration (rounded up)
number_frames = ceil((duration + offset) / hopsize);

end