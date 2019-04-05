function win = gencolawin(winlen,wintype)
% GENCOLAWIN Generates a WINTYPE window that is COLA(WINSIZE).
%   W = GENCOLAWIN(M,WINTYPE)
%
% The possibilities for WINTYPE are:
%
%   1 - Rectangular
%   2 - Bartlett
%   3 - Hann
%   4 - Hanning
%   5 - Blackman
%   6 - Blackman-Harris
%   7 - Hamming
% See also coladen, colasum, colacond, colahs, ol2hs

if isevenl(winlen)
    % Even window length
    wflag = 'periodic';
else
    % Odd window length
    wflag = 'symmetric';
end

% Type of window
switch wintype
    
    case 1
        % RECTANGULAR
        win = rectwin(winlen);
        
    case 2
        % BARTLETT
        if isevenl(winlen)
            win = bartlett(winlen+1);
            win(end)=[];
        else
            win = bartlett(winlen);
        end      
        
    case 3
        % HANN
        win = hann(winlen,wflag);
                
    case 4
        % HANNING (OLA > 1)
        win = hanning(winlen,wflag);
              
    case 5
        % BLACKMAN
        win = blackman(winlen,wflag);
             
    case 6
        % BLACKMAN-HARRIS
        win = blackmanharris(winlen,wflag);
        
        if isoddl(winlen)
            win(1) = win(1)/2;
            win(end) = win(end)/2;
        end
        
    case 7
        % HAMMING (OLA > 1)
        win = hamming(winlen,wflag);

        if isoddl(winlen)
            win(1) = win(1)/2;
            win(end) = win(end)/2;
        end
        
    otherwise
        
        warning('UnknownWindowFlag: The flag entered is out of the range [1,...,7]. Using default HANN window')
        % HANN
        win = hann(winlen,wflag);
        
end

end