function t = solveForward(nx, nz, slow, sx, sz)
% SOLVEFORWARD Find the traveltimes at the surface.
% 
% Input:
%   - nx    number of elements in x direction
%   - nz    number of elements in z direction
%   - slow  slowness matrix
%   - sx    source x index
%   - sz    source z index

tarr = time_2d(nx, nz, slow, sx, sz);
tmat = reshape(tarr,nz,nx);
t = tmat(1,:);

end