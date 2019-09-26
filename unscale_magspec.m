function [smagspec] = unscale_magspec(magspec,p,magflag)

% Unscale the magnitude spectrum
switch lower(magflag)
    
    case {'nne','lin'}
        
        % No need to do anything
        smagspec = magspec;
        
    case 'log'
        
        % magspec(ipeak) = 10^(magspec(ipeak)/10);
        smagspec = 10.^(magspec./20);
        
    case 'pow'
        
        % p = xqifft(winlen,wintype);
        smagspec = nthroot(magspec,p);
        
    otherwise
        
        warning(['InvalidMagFlag: Invalid Magnitude Scaling Flag.\n'...
            'Flag for magnitude scaling must be LOG, LIN, or POW.\n'...
            'Using default magnitude scaling flag LOG'])
        
        smagspec = 10.^(magspec./20);
        
end

end