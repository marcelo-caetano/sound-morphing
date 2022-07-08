function [ind_first,ind_last] = findIndFirstLastTrueVal(bool_ind,nrow,ncol,npage)
%FINDINDFIRSTLASTTRUEVAL Find linear indices of first/last TRUE value per column.
%   [IF,IL] = FINDINDFIRSTLASTTRUEVAL(BOOL,NROW,NCOL,NPAGE) returns the
%   linear indices IF of the first and IL of the last TRUE value for each
%   column (also across pages).
%
%   See also

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(4,4);

% Check number of output arguments
nargoutchk(0,2);

validateattributes(bool_ind,{'numeric','logical'},{'nonempty','binary'},mfilename,'BOOL',1)
validateattributes(nrow,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NROW',2)
validateattributes(ncol,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NCOL',3)
validateattributes(npage,{'numeric'},{'scalar','integer','nonempty','real','positive'},mfilename,'NPAGE',4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% HOW TO FIND THE LINEAR INDEX OF THE FIRST/LAST TRUE VALUE FOR EACH COLUMN
% Find subscript index (SUB_ROW and SUB_COL_PAGE) of all TRUE values in BOOL_IND
% Transitions to new COLUMN_PAGE numbers in SUB_COL_PAGE mark the first/last
% occurance in the new COLUMN_PAGE. So find first/last occurance of each
% COLUMN_PAGE in SUB_COL_PAGE and convert those into the corresponding
% linear index for the dimensions of the original BOOL_IND

% Generic anonymous function to find first/last instance of I in ARR
% The flag DIR determines the direction of the search as DIR='first' or DIR='last'
% The argument 1 determines that only one occurance is returned (only first or last)
findIndex = @(arr,dir) (@(i) find(arr==i,1,dir));

% WARNING! When the input is a multidimensional array (N > 2), find
% returns SUB_COL_PAGE as a linear index over the N-1 trailing dimensions
% of BOOL_IND (effectively returning COLUMN_PAGE when N == 3)
[sub_row,sub_col_page] = find(bool_ind);

% Linear index across columns and pages
ind_col_page = [1:ncol*npage]';

ind_first = getLinearIndex(sub_row,sub_col_page,ind_col_page,[nrow,ncol,npage],findIndex,'first');

ind_last = getLinearIndex(sub_row,sub_col_page,ind_col_page,[nrow,ncol,npage],findIndex,'last');

end

% LOCAL FUNCTION TO GET LINEAR INDICES OF FIRST/LAST TRUE PER COLUMN
function linIndex = getLinearIndex(subRow,subColPage,linColPage,arrDim,findFun,dirflag)

% Anonymous function to find first/last index in SUBCOLPAGE
% FINDLININDEXFUN @(I) FIND(SUBCOLPAGE==I,1,DIRFLAG)
findLinIndexFun = findFun(subColPage,dirflag);

% Apply FINDLININDEXFUN to each LINCOLPAGE
cellArrLinIndex = arrayfun(findLinIndexFun,linColPage,'UniformOutput',false);

% Convert cell array to array
subLinIndex = cell2mat(cellArrLinIndex);

% Convert to linear index using original dimensions ARRDIM
linIndex = sub2ind(arrDim,subRow(subLinIndex),subColPage(subLinIndex));

end
