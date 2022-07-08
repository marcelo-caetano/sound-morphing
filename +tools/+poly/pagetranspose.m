function [arr_transp] = pagetranspose(arr)
%PAGETRANSPOSE Transpose each page of a multidimensional array.
%   T = PAGETRANSPOSE(A) transposes each page of the multidimentional array
%   A. The page-wise transpose permutes the first two dimensions of the
%   array A with PERMUTE(X,[2 1 3:NDIMS(X)]).
%
%   NOTE: This function is simply a polyfill for PAGETRANSPOSE, which is
%   only available after R2020b
%
%   See also

%   2021 M Caetano
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


arr_transp = permute(arr,[2 1 3:ndims(arr)]);

end
