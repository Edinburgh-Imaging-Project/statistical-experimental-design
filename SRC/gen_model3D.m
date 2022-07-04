function [nx, nz, slow, sx, sz] = gen_model3D(M)
% GEN_MODEL Generate the model arrays for the travel time calculations.
% 
% Finds the number of elements in both lateral and depth directions, the 
% slowness matrix and the indices of the source location.
% 
% Inputs:
% M containing:
% * vel_z: depths at which velocity is defined [vector]
% * vel_v: defined velocities corresponding to the depths [vector]
% * src: source location in physical coordinates, first entry in x direction 
%        and second in z direction
% * h: discretization length

    % load velocity model
    [vel_z, vel_v] = loadVelocityModel(M.vmodel);

    % Size in horizontal and vertical dimension 
    nx = round((M.dMax+M.source(1)+2*sqrt(M.sig(1)^2+M.sig(1)^2))/M.h);
    nz = round((M.source(2)+M.sig(2).*1.2)/M.h)+1;
    
    % Vector with x and z coordinates
    xvect = (1:1:nx).*M.h-M.sig(1);
    zvect = (1:1:nz).*M.h;
    
    % Source position
    sx = find(xvect==M.source(1)); 
    sz = round(M.source(2)/M.h); 
    
    % Find velocities for every element in z direction
    vel_vect = interp1(vel_z,vel_v,zvect,'nearest','extrap');
    
    % Find velocity for 2D grid and convert to slowness
    vmodel2 = repmat(vel_vect(:),[1 nx]);
    slow = reshape(vmodel2,nx*nz,1);
    slow = M.h./slow;                 % Normalize by grid size
    
end