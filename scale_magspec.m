function [smagspec,p] = scale_magspec(magspec,winlen,wintype,magflag,powerflag)

% Scale the magnitude spectrum
switch lower(magflag)
    
    case {'nne','lin'}
        
        % disp('Lin')
        p = 1;
        smagspec = abs(magspec);
        
    case 'log'
        
        % disp('Log')
        p = 1;
        smagspec = 20*log10(magspec);
        
    case 'pow'
        
        % disp('Power')
        p = xqifft_temp(winlen,wintype);
        smagspec = magspec.^p;
        
    otherwise
        
        warning(['InvalidMagFlag: Invalid Magnitude Scaling Flag.\n'...
            'Flag for magnitude scaling must be LOG, LIN, or POW.\n'...
            'Using default magnitude scaling flag LOG'])
        
        smagspec = 20*log10(magspec);
        
end

end