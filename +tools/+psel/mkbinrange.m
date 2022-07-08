function bin = mkbinrange(binStart,binEnd,nbin)
%MKBINRANGE Make frequency bins within range.
%   Detailed explanation goes here

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(3,3);

% Check number of output arguments
nargoutchk(0,1);

% TODO: VALIDATE ARGUMENTS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aux_cell = arrayfun(@tools.spec.mkbinvec,binStart,binEnd,'UniformOutput',false);

bool = cellfun(@isempty,aux_cell);

aux_cell(bool) = {nan(nbin,1)};

[npeak,nframe,npage] = size(aux_cell);

aux_array = cell2mat(aux_cell);

aux = reshape(aux_array,nbin,npeak,nframe,npage);

bin = permute(aux,[2 3 4 1]);

end
