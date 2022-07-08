function arr = callArrayFunReturnArray(fun,varargin)
%CALLARRAYFUNRETURNARRAY Call arrayfun and return an array.
%   ARR = CALLARRAYFUNRETURNARRAY(FUN,ARR1,...,ARRN) calls FUN with arrayfun
%   passing all subsequent arguments as input arrays to FUN. All array
%   input arguments ARRN must have the same size. ARR = FUN(ARR1,...,ARRN)
%   for each element of ARRA1,...,ARRAN.
%
%   See also ARRAYFUN

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


cellArr = arrayfun(fun,varargin{:},'UniformOutput',false);
arr = cell2mat(cellArr);

end
