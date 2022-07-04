function [vel_z,vel_v] = loadVelocityModel(model)
%LOADVELOCITYMODEL Load the chosen velocity model
%   Three velocity models can be chosen:
%    * Uniform
%    * Two layers
%    * Three layers
%   Velocity model is formatted as depth levels with corresponding
%   velocities.

if strcmp(model,'twoLayer')
    
    vel_z = [0 5.999 6 120];
    vel_v = [2 2 4 4];
    
elseif strcmp(model,'threeLayer')
    
    vel_z = [0 5 5.01 10 10.01 120];
    vel_v = [2 2 3 3 4 4];
    
elseif strcmp(model,'uniform')
    
    vel_z = [0 120];
    vel_v = [3 3];
    
else
    error('Velocity model not found')
end

end

