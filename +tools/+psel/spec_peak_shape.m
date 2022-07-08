function [fft_peak,dft_mag_peak] = spec_peak_shape(fft_frame,amp,freq,ph,framelen,nfft,fs,nframe,nchannel,...
    maxnpeak,nbinspan,winflag,posfreqflag,realsigflag,normflag,zphflag,npeakflag)
%SPEC_PEAK_SHAPE Spectral peak shape.
%   Detailed explanation goes here

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(17,17);

% Check number of output arguments
nargoutchk(0,2);

validateattributes(fft_frame,{'numeric'},{'nonempty','finite'},mfilename,'FFRFR',1)
validateattributes(amp,{'numeric'},{'nonempty','real'},mfilename,'AMP',2)
validateattributes(freq,{'numeric'},{'nonempty','real'},mfilename,'FREQ',3)
validateattributes(ph,{'numeric'},{'nonempty','real'},mfilename,'PH',4)
validateattributes(framelen,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'FRAMELEN',5)
validateattributes(nfft,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'NFFT',6)
validateattributes(fs,{'numeric'},{'scalar','nonempty','integer','real','positive'},mfilename,'Fs',7)
validateattributes(nframe,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NFRAME',8)
validateattributes(nchannel,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NCHANNEL',9)
validateattributes(maxnpeak,{'numeric'},{'nonempty','scalar','real','positive'},mfilename,'MAXNPEAK',10)
validateattributes(nbinspan,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NBINSPAN',11)
validateattributes(winflag,{'numeric'},{'scalar','integer','nonempty','>=',1,'<=',8},mfilename,'WINFLAG',12)
validateattributes(posfreqflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'POSFREQ  FLAG',13)
validateattributes(realsigflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'REALSIGFLAG',14)
validateattributes(normflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NORMFLAG',15)
validateattributes(zphflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'ZPHFLAG',16)
validateattributes(npeakflag,{'numeric','logical'},{'scalar','nonempty','binary'},mfilename,'NPEAKFLAG',17)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NBINSPAN frequency bins
[binspan,bindelta] = calcNumBin(nbinspan,nfft,framelen);

% FFT bin numbers corresponding to frequencies of spectral peaks
bin_frequency = tools.spec.freq2bin(freq,fs,nfft);

% Bin range around each spectral peak
binrange = calcBinRange(bin_frequency,bindelta);

if isinf(maxnpeak) || ~npeakflag
    npeak = tools.spec.nyq_ind(nfft);
else
    npeak = maxnpeak;
end

% Synthetic complex DFT spectrum (around eack spectral peak)
dft_peak = tools.dft.mkwin(bin_frequency,amp,ph,binrange,binspan,framelen,nfft,winflag,posfreqflag,realsigflag,normflag,zphflag);

% Linear magnitude of DFT_PEAK
dft_mag_peak = tools.fft2.fft2lin_mag_spec(dft_peak);

% Select FFT peaks
fft_peak = getPeaksFFT(fft_frame,freq,fs,nfft,npeak,nframe,nchannel,binspan,bindelta);

end

% LOCAL FUNCTION TO CALCULATE NUMBER OF BINS
function [binSpan,binDelta] = calcNumBin(nbinspan,nfft,framelen)

bin = tools.spec.interp_bin(nfft,framelen);

binSpan = ceil(nbinspan*bin);

binSpan = tools.misc.mkodd(binSpan);

binDelta = (binSpan-1)/2;

end

% LOCAL FUNCTION TO CALCULATE BIN RANGE
function binRange = calcBinRange(binFreq,binDelta)

rangeStart = binFreq - binDelta;
rangeEnd = binFreq + binDelta;

binRange = cat(4,rangeStart,rangeEnd);

end

% LOCAL FUNCTION TO GET PEAKS OF THE FFT
function peaksFFT = getPeaksFFT(fftFrame,Freq,Fs,nfft,npeak,nframe,nchannel,binSpan,binDelta)

% Convert frequencies of spectral peaks to the corresponding indices
% FFT indices corresponding to spectral peaks
ind_frequency = tools.spec.freq2ind(Freq,Fs,nfft);

% Initialize FFT_PEAK
peaksFFT = zeros(npeak,nframe,nchannel,binSpan);
frameLowerBound = ones(npeak,nframe,nchannel);
frameUpperBound = binSpan*ones(npeak,nframe,nchannel);
bool_freq = ~isnan(Freq);

frameLowerBound(bool_freq) = ind_frequency(bool_freq) - binDelta;
frameUpperBound(bool_freq) = ind_frequency(bool_freq) + binDelta;

% Initialize
peakLowerBound = ones(npeak,nframe,nchannel);
peakUpperBound = binSpan*ones(npeak,nframe,nchannel);
peakSpan = binSpan*ones(npeak,nframe,nchannel);
nBinUnderflow = nan(npeak,nframe,nchannel);
nBinOverflow = nan(npeak,nframe,nchannel);

boolFrameLower = frameLowerBound < 1;
boolFrameUpper = frameUpperBound > nfft;

if any(boolFrameLower(:))
    nBinUnderflow(boolFrameLower) = 1 - frameLowerBound(boolFrameLower);
    peakLowerBound(boolFrameLower) = nBinUnderflow(boolFrameLower) + 1;
    peakSpan(boolFrameLower) = binSpan - nBinUnderflow(boolFrameLower);
    frameLowerBound(boolFrameLower) = max(1,frameLowerBound(boolFrameLower));
end

if any(boolFrameUpper(:))
    nBinOverflow(boolFrameUpper) = frameUpperBound(boolFrameUpper) - nfft;
    peakUpperBound(boolFrameUpper) = binSpan - nBinOverflow(boolFrameUpper);
    peakSpan(boolFrameUpper) = binSpan - nBinUnderflow(boolFrameUpper);
    frameUpperBound(boolFrameUpper) = min(nfft,frameUpperBound(boolFrameUpper));
end

% Subindices: Rows
ipeak = arrayfun(@(x,y) y.*ones(x,1),peakSpan,repmat(repmat((1:npeak)',1,nframe),1,1,nchannel),'UniformOutput',false);
% Subindices: Columns
iframe = arrayfun(@(x,y) y.*ones(x,1),peakSpan,repmat(repmat((1:nframe),npeak,1),1,1,nchannel),'UniformOutput',false);
% Subindices: Pages
ichannel = arrayfun(@(x,y) y.*ones(x,1),peakSpan,repmat(repmat(reshape((1:nchannel),1,1,nchannel),1,nframe),npeak,1,1),'UniformOutput',false);
% Index range for DFT
rangeFFT = arrayfun(@tools.spec.mkbinvec,peakLowerBound,peakUpperBound,'UniformOutput',false);
% Index range for FFT
rangeDFT = arrayfun(@tools.spec.mkbinvec,frameLowerBound,frameUpperBound,'UniformOutput',false);

% Linear indices for FFT
indFFT = sub2ind([npeak,nframe,nchannel,binSpan],cat(1,ipeak{:}),cat(1,iframe{:}),cat(1,ichannel{:}),cat(1,rangeFFT{:}));
% Linear indices for DFT
indDFT = sub2ind([nfft,nframe,nchannel],cat(1,rangeDFT{:}),cat(1,iframe{:}),cat(1,ichannel{:}));

% Assignment
peaksFFT(indFFT) = tools.fft2.fft2lin_mag_spec(fftFrame(indDFT));
peaksFFT = reshape(peaksFFT,npeak,nframe,nchannel,binSpan);

end
