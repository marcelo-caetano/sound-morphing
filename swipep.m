function [p,t,s] = swipep(x,fs,plim,dt,dlog2p,dERBs,woverlap,sTHR)
% SWIPEP Pitch estimation using SWIPE'.
%    P = SWIPEP(X,Fs,[PMIN PMAX],DT,DLOG2P,DERBS,STHR) estimates the pitch 
%    of the vector signal X every DT seconds. The sampling frequency of
%    the signal is Fs (in Hertz). The spectrum is computed using a Hann
%    window with an overlap WOVERLAP between 0 and 1. The spectrum is
%    sampled uniformly in the ERB scale with a step size of DERBS ERBs. The
%    pitch is searched within the range [PMIN PMAX] (in Hertz) with samples
%    distributed every DLOG2P units on a base-2 logarithmic scale of Hertz. 
%    The pitch is fine-tuned using parabolic interpolation with a resolution
%    of 1 cent. Pitch estimates with a strength lower than STHR are treated
%    as undefined.
%    
%    [P,T,S] = SWIPEP(X,Fs,[PMIN PMAX],DT,DLOG2P,DERBS,WOVERLAP,STHR) 
%    returns the times T at which the pitch was estimated and the pitch 
%    strength S of every pitch estimate.
%
%    P = SWIPEP(X,Fs) estimates the pitch using the default settings PMIN =
%    30 Hz, PMAX = 5000 Hz, DT = 0.001 s, DLOG2P = 1/48 (48 steps per 
%    octave), DERBS = 0.1 ERBs, WOVERLAP = 0.5, and STHR = -Inf.
%
%    P = SWIPEP(X,Fs,...,[],...) uses the default setting for the parameter
%    replaced with the placeholder [].
%
%    REMARKS: (1) For better results, make DLOG2P and DERBS as small as 
%    possible and WOVERLAP as large as possible. However, take into account
%    that the computational complexity of the algorithm is inversely 
%    proportional to DLOG2P, DERBS and 1-WOVERLAP, and that the  default 
%    values have been found empirically to produce good results. Consider 
%    also that the computational complexity is directly proportional to the
%    number of octaves in the pitch search range, and therefore , it is 
%    recommendable to restrict the search range to the expected range of
%    pitch, if any. (2) This code implements SWIPE', which uses only the
%    first and prime harmonics of the signal. To convert it into SWIPE,
%    which uses all the harmonics of the signal, replace the word
%    PRIMES with a colon (it is located almost at the end of the code).
%    However, this may not be recommendable since SWIPE' is reported to 
%    produce on average better results than SWIPE (Camacho and Harris,
%    2008).
%
%    EXAMPLE: Estimate the pitch of the signal X every 10 ms within the
%    range 75-500 Hz using the default resolution (i.e., 48 steps per
%    octave), sampling the spectrum every 1/20th of ERB, using a window 
%    overlap factor of 50%, and discarding samples with pitch strength 
%    lower than 0.2. Plot the pitch trace.
%       [x,Fs] = wavread(filename);
%       [p,t,s] = swipep(x,Fs,[75 500],0.01,[],1/20,0.5,0.2);
%       plot(1000*t,p)
%       xlabel('Time (ms)')
%       ylabel('Pitch (Hz)')
%
%    REFERENCES: Camacho, A., Harris, J.G, (2008) "A sawtooth waveform 
%    inspired pitch estimator for speech and music," J. Acoust. Soc. Am.
%    124, 1638-1652.
%
%    MAINTENANCE HISTORY:
%    - Added line 153 to avoid division by zero in line 154 if loudness
%      equals zero (06/23/2010).
if ~ exist( 'plim', 'var' ) || isempty(plim), plim = [30 5000]; end
if ~ exist( 'dt', 'var' ) || isempty(dt), dt = 0.001; end
if ~ exist( 'dlog2p', 'var' ) || isempty(dlog2p), dlog2p = 1/48; end
if ~ exist( 'dERBs', 'var' ) || isempty(dERBs), dERBs = 0.1; end
if ~ exist( 'woverlap', 'var' ) || isempty(woverlap)
    woverlap = 0.5;
elseif woverlap>1 || woverlap<0
    error('Window overlap must be between 0 and 1.')
end
if ~ exist( 'sTHR', 'var' ) || isempty(sTHR), sTHR = -Inf; end
t = [ 0: dt: length(x)/fs ]'; % Times
% Define pitch candidates
log2pc = [ log2(plim(1)): dlog2p: log2(plim(2)) ]';
pc = 2 .^ log2pc;
S = zeros( length(pc), length(t) ); % Pitch strength matrix
% Determine P2-WSs
logWs = round( log2( 8*fs ./ plim ) ); 
ws = 2.^[ logWs(1): -1: logWs(2) ]; % P2-WSs
pO = 8 * fs ./ ws; % Optimal pitches for P2-WSs
% Determine window sizes used by each pitch candidate
d = 1 + log2pc - log2( 8*fs./ws(1) );
% Create ERB-scale uniformly-spaced frequencies (in Hertz)
fERBs = erbs2hz([ hz2erbs(min(pc)/4): dERBs: hz2erbs(fs/2) ]');
for i = 1 : length(ws)
    dn = max( 1, round( 8*(1-woverlap) * fs / pO(i) ) ); % Hop size
    % Zero pad signal
    xzp = [ zeros( ws(i)/2, 1 ); x(:); zeros( dn + ws(i)/2, 1 ) ];
    % Compute spectrum
    w = hanning( ws(i) ); % Hann window 
    o = max( 0, round( ws(i) - dn ) ); % Window overlap
    [ X, f, ti ] = specgram( xzp, ws(i), fs, w, o );
    % Select candidates that use this window size
    if length(ws) == 1
        j=[(pc)]'; k = [];
    elseif i == length(ws)
        j=find(d-i>-1); k=find(d(j)-i<0);
    elseif i==1
        j=find(d-i<1); k=find(d(j)-i>0);
    else
        j=find(abs(d-i)<1); k=1:length(j);
    end
    % Compute loudness at ERBs uniformly-spaced frequencies
    fERBs = fERBs( find( fERBs > pc(j(1))/4, 1, 'first' ) : end );
    L = sqrt( max( 0, interp1( f, abs(X), fERBs, 'spline', 0) ) );
    % Compute pitch strength
    Si = pitchStrengthAllCandidates( fERBs, L, pc(j) );
    % Interpolate pitch strength at desired times
    if size(Si,2) > 1
        warning off MATLAB:interp1:NaNinY
        Si = interp1( ti, Si', t, 'linear', NaN )';
        warning on MATLAB:interp1:NaNinY
    else
        Si = repmat( NaN, length(Si), length(t) );
    end
    % Add pitch strength to combination
    lambda = d( j(k) ) - i;
    mu = ones( size(j) );
    mu(k) = 1 - abs( lambda );
    S(j,:) = S(j,:) + repmat(mu,1,size(Si,2)) .* Si;
end
% Fine tune pitch using parabolic interpolation
p = repmat( NaN, size(S,2), 1 );
s = repmat( NaN, size(S,2), 1 );
for j = 1 : size(S,2)
    [ s(j), i ] = max( S(:,j), [], 1 );
    if s(j) < sTHR, continue, end
    if i == 1 || i == length(pc)
        p(j) = pc(i);
    else
        I = i-1 : i+1;
        tc = 1 ./ pc(I);
        ntc = ( tc/tc(2) - 1 ) * 2*pi;
        c = polyfit( ntc, S(I,j), 2 );
        ftc = 1 ./ 2.^[ log2(pc(I(1))): 1/12/100: log2(pc(I(3))) ];
        nftc = ( ftc/tc(2) - 1 ) * 2*pi;
        [s(j) k] = max( polyval( c, nftc ) );
        p(j) = 2 ^ ( log2(pc(I(1))) + (k-1)/12/100 );
    end
end

function S = pitchStrengthAllCandidates( f, L, pc )
% Create pitch strength matrix
S = zeros( length(pc), size(L,2) );
% Define integration regions
k = ones( 1, length(pc)+1 );
for j = 1 : length(k)-1
    k(j+1) = k(j) - 1 + find( f(k(j):end) > pc(j)/4, 1, 'first' );
end
k = k(2:end);
% Create loudness normalization matrix
N = sqrt( flipud( cumsum( flipud(L.*L) ) ) );
for j = 1 : length(pc)
    % Normalize loudness
    n = N(k(j),:);
    n(n==0) = Inf; % to make zero-loudness equal zero after normalization
    NL = L(k(j):end,:) ./ repmat( n, size(L,1)-k(j)+1, 1);
    % Compute pitch strength
    S(j,:) = pitchStrengthOneCandidate( f(k(j):end), NL, pc(j) );
end

function S = pitchStrengthOneCandidate( f, NL, pc )
n = fix( f(end)/pc - 0.75 ); % Number of harmonics
if n==0, S=NaN; return, end
k = zeros( size(f) ); % Kernel
% Normalize frequency w.r.t. candidate
q = f / pc;
% Create kernel
for i = [ 1 primes(n) ]
    a = abs( q - i );
    % Peak's weigth
    p = a < .25; 
    k(p) = cos( 2*pi * q(p) );
    % Valleys' weights
    v = .25 < a & a < .75;
    k(v) = k(v) + cos( 2*pi * q(v) ) / 2;
end
% Apply envelope
k = k .* sqrt( 1./f  ); 
% K+-normalize kernel
k = k / norm( k(k>0) ); 
% Compute pitch strength
S = k' * NL; 

function erbs = hz2erbs(hz)
erbs = 6.44 * ( log2( 229 + hz ) - 7.84 );

function hz = erbs2hz(erbs)
hz = ( 2 .^ ( erbs./6.44 + 7.84) ) - 229;