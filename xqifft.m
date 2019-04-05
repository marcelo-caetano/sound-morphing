function [p] = xqifft(winlen,wintype)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

XQIFFT = load('xqifft.mat');

switch wintype
    % Rectangular
    case 1
        warning('WindowType Rectangular: Using default value p = 1.\n')
        p = 1;
        % Bartlett
    case 2
        if any(winlen==XQIFFT.Length)
            p = XQIFFT.Bartlett(winlen==XQIFFT.Length);
        else
            error('WindowSize must be a power of two between 512 and 8179.\n')
            %             % Fit quadratic curve
            %             [pol,s] = polyfit(XQIFFT.Length,Hann,2);
            %             % Evaluate P at WINSIZE
            %             p = polyval(pol,winlen,s);
        end
        % Hann
    case 3
        if any(winlen==XQIFFT.Length)
            p = XQIFFT.Hann(winlen==XQIFFT.Length);
        else
            error('WindowSize must be a power of two between 512 and 8179.\n')
            %             % Fit quadratic curve
            %             [pol,s] = polyfit(XQIFFT.Length,Hann,2);
            %             % Evaluate P at WINSIZE
            %             p = polyval(pol,winlen,s);
            %             % Plot curve
            %             x = linspace(XQIFFT.Length(1),XQIFFT.Length(end),1000);
            %             v = polyval(pol,x,s);
            %             figure(1)
            %             plot(x,v,'r')
            %             hold on
            %             plot(XQIFFT.Length,Hann,'*k')
            %             hold off
            %             axis([510,4100,0.229,0.2292])
        end
        % Hanning
    case 4
        if any(winlen==XQIFFT.Length)
            p = XQIFFT.Hanning(winlen==XQIFFT.Length);
        else
            error('WindowSize must be a power of two between 512 and 8179.\n')
            %             % Fit quadratic curve
            %             [pol,s] = polyfit(XQIFFT.Length,Hann,2);
            %             % Evaluate P at WINSIZE
            %             p = polyval(pol,winlen,s);
        end
        % Blackman
    case 5
        if any(winlen==XQIFFT.Length)
            p = XQIFFT.Blackman(winlen==XQIFFT.Length);
        else
            error('WindowSize must be a power of two between 512 and 8179.\n')
            %             % Fit quadratic curve
            %             [pol,s] = polyfit(XQIFFT.Length,Hann,2);
            %             % Evaluate P at WINSIZE
            %             p = polyval(pol,winlen,s);
        end
        % Blackman-Harris
    case 6
        if any(winlen==XQIFFT.Length)
            p = XQIFFT.Blackman_Harris(winlen==XQIFFT.Length);
        else
            error('WindowSize must be a power of two between 512 and 8179.\n')
            %             % Fit quadratic curve
            %             [pol,s] = polyfit(XQIFFT.Length,Hann,2);
            %             % Evaluate P at WINSIZE
            %             p = polyval(pol,winlen,s);
        end
        % Hamming
    case 7
        if any(winlen==XQIFFT.Length)
            p = XQIFFT.Hamming(winlen==XQIFFT.Length);
        else
            error('WindowSize must be a power of two between 512 and 8179.\n')
            %             % Fit quadratic curve
            %             [pol,s] = polyfit(XQIFFT.Length,Hann,2);
            %             % Evaluate P at WINSIZE
            %             p = polyval(pol,winlen,s);
        end
        % Default Hann
    otherwise
        warning('WindowType Out of Bounds: Using default Hann window.\n')
        if any(winlen==XQIFFT.Length)
            p = XQIFFT.Hann(winlen==XQIFFT.Length);
        else
            error('WindowSize must be a power of two between 512 and 8179.\n')
            %             % Fit quadratic curve
            %             [pol,s] = polyfit(XQIFFT.Length,Hann,2);
            %             % Evaluate P at WINSIZE
            %             p = polyval(pol,winlen,s);
        end
        
end

% clear Rectangular Bartlett Hann Hanning Blackman Blackman_Harris Hamming XQIFFT.Length

end