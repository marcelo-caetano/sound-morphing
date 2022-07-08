function dot_prod = dotprod(v1,v2,dim,normflag)
%DOTPROD Dot product.
%   D = DOTPROD(V1,V2) returns the dot product D between the columns of the
%   multidimensional arrays V1 and V2. D = ||V1|| ||V2|| cos(\Theta), where
%   ||.|| represents the magnitude of the column vectors. V1 and V2 must
%   have the same size NROW x NCOL x NPAGE and D is size 1 x NCOL x NPAGE.
%
%   D = DOTPROD(V1,V1,DIM) returns the dot product D along the dimension
%   DIM. DIM must be an integer scalar.
%
%   D = DOTPROD(V1,V2,DIM,NORMFLAG) uses the logical flag NORMFLAG to
%   normalize D by the magnitudes of V1 and V2, effectively returning
%   cos(\Theta).
%
%   See also QUADFIT

% 2021 M Caetano SMT
% $Id 2022 M Caetano SMT 0.3.0-alpha.1 $Id


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of input arguments
narginchk(2,4);

% Check number of output arguments
nargoutchk(0,1);

if nargin == 2
    
    dim = 1;
    
    normflag = false;
    
elseif nargin == 3
    
    normflag = false;
    
end

validateattributes(v1,{'numeric'},{},mfilename,'V1',1)

validateattributes(v2,{'numeric'},{},mfilename,'V2',2)

validateattributes(dim,{'numeric'},{'scalar','finite','nonnan','integer','positive'},mfilename,'DIM',3)

validateattributes(normflag,{'numeric','logical'},{'scalar','finite','nonnan','binary'},mfilename,'NORMFLAG',4)

% Check if sizes are compatible
if ~isequal(size(v1),size(v2))
    
    [nrow1,ncol1,npage1,nd1] = size(v1);
    [nrow2,ncol2,npage2,nd2] = size(v2);
    
    error('SMT:DOTPROD:inputSizeMismatch',...
        ['Dimensions of inputs must match.\n'...
        'V1 is %d x %d x %d x %d\nV2 is %d x %d x %d x %d\n'],...
        nrow1,ncol1,npage1,nd1,nrow2,ncol2,npage2,nd2)
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dot product of V1 and V2
dot_prod = sum(conj(v1).*v2,dim);

if normflag
    
    % Magnitude of V1
    mag_v1 = tools.math.vecnorm(v1,dim);
    
    % Magnitude of V2
    mag_v2 = tools.math.vecnorm(v2,dim);
    
    % Cosine of the angle between V1 and V2
    dot_prod = dot_prod./(mag_v1.*mag_v2);
    
end

end
