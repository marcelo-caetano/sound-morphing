function vnorm = vecnorm(v,dim)
%VECNORM Vector norm.
%   VNORM = VECNORM(V) returns the norm of the multidimensional array V
%   calculated as VNORM = sqrt(sum(V.^2)). V is assumed to be column
%   vectors of size NROW x NCOL x NPAGE, so VNORM is calculated along the
%   columns of V and is size 1 x NCOL x NPAGE.
%
%   VNORM = VECNORM(V,DIM) returns the norm of the multidimensional array V
%   alond dimension DIM calculated as VNORM = sqrt(sum(v.^2,DIM)). DIM must
%   be an integer scalar.
%
%   See also DOT, EUCLIDIST, COSDIST

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(1,2);

% Check number of output arguments
nargoutchk(0,1);

if nargin == 1
    
    dim = 1;
    
end

validateattributes(v,{'numeric'},{},mfilename,'V',1)

validateattributes(dim,{'numeric'},{'scalar','finite','nonnan','integer','positive'},mfilename,'DIM',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vnorm = sqrt(sum(v.^2,dim));

end
